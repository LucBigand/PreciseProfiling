Class {
	#name : #PreciseMemoryPresenter,
	#superclass : #RSCanvas,
	#instVars : [
		'scale',
		'interpreter',
		'colorDictionary',
		'boxes'
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

{ #category : #display }
PreciseMemoryPresenter >> createBoxFor: aPreciseMemoryNode [
	|  colorr class box |
	class := aPreciseMemoryNode method classBinding.
	colorr := (colorDictionary includesKey: class)
		ifTrue: [ colorDictionary at: class ]
		ifFalse: [ 
			| newColor |
			newColor := Color random.
			colorDictionary at: class put: newColor.
			newColor ].
	box := (RSBox new
		size: 10;
		color: colorr ;
		borderColor: (scale scale: aPreciseMemoryNode memoryUsed);
		@ (RSPopup text: 'test');
		yourself).
	box border width: 2.
	boxes add: box.
	^ box
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
]

{ #category : #calculating }
PreciseMemoryPresenter >> lineWidthFor: aNode [
	" Function that associates to a node the width of the line that connects it to its parent
	in the presenter. Will probably be modified later "
	^ 3 * aNode numberOfCalls / interpreter rootNode maxNumberOfCalls
]
