"
I offer a visual display for the informations registered by a PreciseMemoryInterpreter, such as :
	- A graphical representation of the method contexts
	- A graphical representation of the objects allocated
	- An interactive list of the classes instanciated

    Instance Variables
	boxes:		A list of RSComposite representing a method context and the objects it instanciated
	classList:		A list of interactive RSLabel representing the classes instanciated
	colorDictionary:		A Dictionary that associates a class instanciated with a color
	interpreter:		The PreciseInterpreter that is being displayed
	maxNumberOfAllocations:		The maximum number of times the same class has been instanciated in the same method context
	maxNumberOfCalls:		The maximum number of times the same method has been called in the same method context
	scale:		A RsScale used to color the boxes based on memory used, from blue for most efficient to red for least efficient
"
Class {
	#name : #PreciseMemoryPresenter,
	#superclass : #RSCanvas,
	#instVars : [
		'scale',
		'interpreter',
		'colorDictionary',
		'boxes',
		'maxNumberOfCalls',
		'maxNumberOfAllocations',
		'classList'
	],
	#classVars : [
		'treeLength',
		'windowHeight',
		'windowLength'
	],
	#category : #PreciseProfiler
}

{ #category : #'class initialization' }
PreciseMemoryPresenter class >> initialize [
	windowHeight := 480.
	windowLength := 1200.
	treeLength := 900.
]

{ #category : #opening }
PreciseMemoryPresenter class >> openOn: aPreciseMemoryInterpreter [
	self new
		initializeWith: aPreciseMemoryInterpreter;
		displayNodes;
		"displayClassList ;"
		openWithTitle: 'Memory profiler presenter'.
]

{ #category : #computing }
PreciseMemoryPresenter >> auxComputeMaxNumberOfAllocations: aPreciseMemoryNode [
	"An auxiliary method called by #computeMaxNumberOfAllocations."
	| res nbAllocPerClass |
	nbAllocPerClass := (aPreciseMemoryNode allocationDict values collect: [ :entry | entry directAllocations ]).
	res := nbAllocPerClass 
		ifEmpty: [ 0 ]
		ifNotEmpty: [ nbAllocPerClass max ].
	aPreciseMemoryNode childs do: [ :child | | childMNOA |
		childMNOA := self auxComputeMaxNumberOfAllocations: child.
		(childMNOA > res) 
			ifTrue: [ res := childMNOA ] ].
	^ res
]

{ #category : #computing }
PreciseMemoryPresenter >> auxComputeMaxNumberOfCall: aPreciseMemoryNode [
	"An auxiliary method called by #computeMaxNumberOfCall."
	| res |
	res := aPreciseMemoryNode numberOfCalls.
	aPreciseMemoryNode childs do: [ :child | | childMNOC |
		childMNOC := self auxComputeMaxNumberOfCall: child.
		(childMNOC > res) 
			ifTrue: [ res := childMNOC ] ].
	^ res
]

{ #category : #display }
PreciseMemoryPresenter >> centerNodesToTheLeft [
	"Makes the nodes take the left portion of the presenter (Does'nt work yet"
	"| newScale newPosition cornerX cornerY |
	cornerX := (boxes collect: [ :box | box matrix x + box baseRectangle corner x ]) max.
	cornerY := (boxes collect: [ :box | box matrix y + box baseRectangle corner y ]) max.
	newScale := (( cornerX / treeLength ) min: ( cornerY / treeLength )) * 0.9.
	newPosition := ( (cornerX @ cornerY ) / 2 ) + 
						((( windowLength - treeLength ) / 2 * newScale ) @ 0 ).
	camera scale: newScale.
	camera position: newPosition.
	self halt."
	self zoomToFit.
]

{ #category : #utilities }
PreciseMemoryPresenter >> colorFor: aClass [
	"Returns the color associated with aClass"
	(colorDictionary includesKey: aClass)
		ifTrue: [ ^ colorDictionary at: aClass ]
		ifFalse: [ | newColor |
			newColor := Color random.
			colorDictionary at: aClass put: newColor.
			^ newColor ].
]

{ #category : #computing }
PreciseMemoryPresenter >> computeMaxNumberOfAllocations [
	" Compute the maximum number of calls for allocations of the same object for a method context "
	| res |
	res := 0.
	interpreter rootNode childs do: [ :child | | childMNOA |
		childMNOA := self auxComputeMaxNumberOfAllocations: child.
		(childMNOA > res) 
			ifTrue: [ res := childMNOA ] ].
	maxNumberOfAllocations := res.
]

{ #category : #computing }
PreciseMemoryPresenter >> computeMaxNumberOfCall [
	" Compute the maximum number of calls for a method context "
	| res |
	res := 0.
	interpreter rootNode childs do: [ :child | | childMNOC |
		childMNOC := self auxComputeMaxNumberOfCall: child.
		(childMNOC > res) 
			ifTrue: [ res := childMNOC ] ].
	maxNumberOfCalls := res.
]

{ #category : #display }
PreciseMemoryPresenter >> createBoxFor: aPreciseMemoryNode [
	"Create a box representing aPreciseMemoryNode, with popups detailing related informations"
	| outterBox allocDict |
	outterBox := RSGroup new.
	allocDict := aPreciseMemoryNode allocationDict.
	allocDict keysDo: [ :class | | entry innerBox |
		entry := allocDict at: class.
		(entry directAllocations > 0) ifTrue: [ 
			innerBox := (RSBox new
				size: (self sizeInnerBoxFor: entry directAllocations) ;
				color: ( self colorFor: class );
				@ (RSPopup text: (entry directAllocations asString,' allocations of ', class asString ));
				yourself).
			outterBox add: innerBox.]].
	RSGridLayout on: outterBox.
	outterBox := outterBox asShape.
	outterBox padding: 3;
		propertyAt: #method put: aPreciseMemoryNode method;
		color: (scale scale: aPreciseMemoryNode memoryUsed);
		@ (RSPopup text: aPreciseMemoryNode longDescription);
		@ (RSMenuActivable new menuDo: [ :menu :element | 
			menu add: 'Inspect' target: aPreciseMemoryNode selector: #inspect;
				add: 'Browse' target: aPreciseMemoryNode method selector: #browse ]).
	boxes add: outterBox.
	^ outterBox
]

{ #category : #display }
PreciseMemoryPresenter >> displayClassList [
	"Displays the list of all classes instanciated by the program executed by the PreciseMemoryInterpreter"
	| allocationDict keys |
	allocationDict := interpreter rootNode childs first allocationDict.
	interpreter rootNode childs allButFirstDo: [ :memoryNode | | allocationDict2 |
		allocationDict2 := memoryNode allocationDict.
		allocationDict addFromDictionary: allocationDict2 ].
	keys := allocationDict keys sorted: [ :a :b |
		(allocationDict at: a) totalAllocations > (allocationDict at: b) totalAllocations ].
	keys do: [ :class | | entry nbAlloc memoryUsed label |
		entry := allocationDict at: class.
		nbAlloc := entry totalAllocations asString .
		memoryUsed := entry totalMemoryUsed asString .
		label := RSLabel text: class asString , ' - ' , nbAlloc , ' - ', memoryUsed , ' bytes' .
		label color: Color black.
		classList add: label ].
	self addAll: classList.
	RSVerticalLineLayout on: classList.
	
]

{ #category : #display }
PreciseMemoryPresenter >> displayNode: aPreciseMemoryNode [
	"Creates the graphical display of aPreciseMemoryNode and connects it to the graphical display of its childs"
	| selfBox childBox |
	selfBox := self createBoxFor: aPreciseMemoryNode.
	aPreciseMemoryNode childs do: [ :node |
		childBox := self displayNode: node.
		self add: (RSLine new
			withBorderAttachPoint;
			from: selfBox;
			to: childBox;
			width: (self lineWidthFor: node );
			yourself)].
	^ selfBox
]

{ #category : #display }
PreciseMemoryPresenter >> displayNodes [
	"Creates the graphical display of the tree of PreciseMemoryNode registered by the interpreter"
	interpreter rootNode childs do: [ :node | self displayNode: node].
	self addAll: boxes.
	RSHorizontalTreeLayout on: boxes.
	self centerNodesToTheLeft.
]

{ #category : #initialization }
PreciseMemoryPresenter >> initialize [
	super initialize.
	colorDictionary := Dictionary new.
	boxes := OrderedCollection new.
	classList := OrderedCollection new.
]

{ #category : #initialization }
PreciseMemoryPresenter >> initializeWith: aPreciseMemoryInterpreter [
	| maxMemory |
	interpreter := aPreciseMemoryInterpreter.
	maxMemory := (aPreciseMemoryInterpreter rootNode childs collect: [ :node | node memoryUsed ]) max.
	scale := NSScale linear
		range: { Color blue . Color red }; 
		domain: { 0 . maxMemory }.
	self computeMaxNumberOfCall.
	self computeMaxNumberOfAllocations.
]

{ #category : #utilities }
PreciseMemoryPresenter >> lineWidthFor: aNode [
	" Function that associates to a node the width of the line that connects it to its parent
	in the presenter. Will probably be modified later "
	^ 3 * aNode numberOfCalls / maxNumberOfCalls
]

{ #category : #opening }
PreciseMemoryPresenter >> openWithTitle: aTitleAsString [
	| window |
	window := super openWithTitle: aTitleAsString.
	window extent: windowLength @ windowHeight .
]

{ #category : #utilities }
PreciseMemoryPresenter >> sizeInnerBoxFor: anInteger [
	" Function that associates to a number of allocations the size of the inner box representing these
	allocations within the method context in the presenter. Will probably be modified later "
	^ 4 + (8 * anInteger / maxNumberOfAllocations)
]
