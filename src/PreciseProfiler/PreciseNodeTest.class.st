Class {
	#name : #PreciseNodeTest,
	#superclass : #TestCase,
	#category : #PreciseProfiler
}

{ #category : #test }
PreciseNodeTest >> testAddMethodCall [
	| node |
	node := PreciseNode new
		initializeWith: (SmallInteger>>#+);
		yourself.
	node addMethodCall: (SmallInteger>>#-).
	2 timesRepeat: [ node addMethodCall: (SmallInteger>>#*) ].
	self assert: node childs size equals: 2.
	self assert: node childs first method equals: (SmallInteger>>#-).
	self assert: node childs second method equals: (SmallInteger>>#*).
]

{ #category : #test }
PreciseNodeTest >> testSettingParentAddsChildInParent [
	| parentNode childNode |
	parentNode := PreciseNode new.
	childNode := PreciseNode new
		parent: parentNode;
		yourself.
	self assert: parentNode childs first equals: childNode.
	self assert: childNode parent equals: parentNode.
]
