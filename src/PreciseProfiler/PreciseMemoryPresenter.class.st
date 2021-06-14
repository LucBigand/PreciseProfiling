Class {
	#name : #PreciseMemoryPresenter,
	#superclass : #RSCanvas,
	#instVars : [
		'depth',
		'line',
		'scale',
		'interpreter',
		'colorDictionary'
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
		translateTo: (depth * 20)@(line * 20);
		yourself).
	box border width: 2.
	^ self add: box
]

{ #category : #display }
PreciseMemoryPresenter >> displayNode: aPreciseMemoryNode [
	| selfBox childBox |
	selfBox := self createBoxFor: aPreciseMemoryNode.
	depth := depth + 1.
	aPreciseMemoryNode childs do: [ :node |
		childBox := self displayNode: node.
		self add: (RSLine new
			withBorderAttachPoint;
			from: selfBox;
			to: childBox;
			width: (self lineWidthFor: node );
			yourself).
		line := line + 1 ].
	depth := depth - 1.
	aPreciseMemoryNode childs ifNotEmpty: [ line := line - 1 ].
	^ selfBox
]

{ #category : #display }
PreciseMemoryPresenter >> displayNodes [
	interpreter rootNode childs do: [ :node | 
		self displayNode: node.
		line := line + 1 ].
	self zoomToFit.
]

{ #category : #initialization }
PreciseMemoryPresenter >> initialize [
	super initialize.
	colorDictionary := Dictionary new.
	depth := 0.
	line := 0.
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
	^ aNode numberOfCalls / interpreter rootNode maxNumberOfCalls
]
