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

{ #category : #utilities }
PreciseMemoryPresenter >> colorFor: aClass [
	(colorDictionary includesKey: aClass)
		ifTrue: [ ^ colorDictionary at: aClass ]
		ifFalse: [ | newColor |
			newColor := Color random.
			colorDictionary at: aClass put: newColor.
			^ newColor ].
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
				size: 10;
				color: ( self colorFor: class );
				@ (RSPopup text: 'TODO');
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
]

{ #category : #utilities }
PreciseMemoryPresenter >> lineWidthFor: aNode [
	" Function that associates to a node the width of the line that connects it to its parent
	in the presenter. Will probably be modified later "
	^ 3 * aNode numberOfCalls / interpreter rootNode maxNumberOfCalls
]
