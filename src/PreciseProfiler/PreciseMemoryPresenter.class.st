Class {
	#name : #PreciseMemoryPresenter,
	#superclass : #RSCanvas,
	#instVars : [
		'scale',
		'interpreter',
		'colorDictionary',
		'boxes',
		'maxNumberOfCalls',
		'maxNumberOfAllocations'
	],
	#category : #PreciseProfiler
}

{ #category : #opening }
PreciseMemoryPresenter class >> openOn: aPreciseMemoryInterpreter [
	self new
		initializeWith: aPreciseMemoryInterpreter;
		displayNodes;
		open.
]

{ #category : #computing }
PreciseMemoryPresenter >> auxComputeMaxNumberOfAllocations: aPreciseMemoryNode [
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
	| res |
	res := aPreciseMemoryNode numberOfCalls.
	aPreciseMemoryNode childs do: [ :child | | childMNOC |
		childMNOC := self auxComputeMaxNumberOfCall: child.
		(childMNOC > res) 
			ifTrue: [ res := childMNOC ] ].
	^ res
]

{ #category : #utilities }
PreciseMemoryPresenter >> colorFor: aClass [
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
	outterBox := outterBox asShape.
	outterBox padding: 3;
		color: (scale scale: aPreciseMemoryNode memoryUsed);
		@ (RSPopup text: aPreciseMemoryNode longDescription).
	boxes add: outterBox.
	^ outterBox
]

{ #category : #display }
PreciseMemoryPresenter >> displayNode: aPreciseMemoryNode [
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
	interpreter rootNode childs do: [ :node | self displayNode: node].
	self addAll: boxes.
	RSHorizontalTreeLayout on: boxes.
	self zoomToFit.
]

{ #category : #initialization }
PreciseMemoryPresenter >> initialize [
	super initialize.
	colorDictionary := Dictionary new.
	boxes := OrderedCollection new.
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

{ #category : #utilities }
PreciseMemoryPresenter >> sizeInnerBoxFor: anInteger [
	" Function that associates to a number of allocations the size of the inner box representing these
	allocations within the method context in the presenter. Will probably be modified later "
	^ 2 + (8 * anInteger / maxNumberOfAllocations)
]
