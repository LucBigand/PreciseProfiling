Class {
	#name : #PreciseNodeTest,
	#superclass : #TestCase,
	#category : #PreciseProfiler
}

{ #category : #test }
PreciseNodeTest >> testAddMethodCall [
	| node |
	node := PreciseNode new
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
