Class {
	#name : #AbstractPreciseNode,
	#superclass : #Object,
	#instVars : [
		'childs'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
AbstractPreciseNode >> addAllocation [
	childs do: [ :child |
		(child class == PreciseAllocationNode) ifTrue: [ 
			child incrementNumberOfCalls.
			^ child ] ].
	^ PreciseAllocationNode new
		parent: self;
		yourself.
]

{ #category : #adding }
AbstractPreciseNode >> addChild: aNode [ 
	childs add: aNode
]

{ #category : #adding }
AbstractPreciseNode >> addMethodCall: aCompiledMethod [
	childs do: [ :child |
		(child class == PreciseMethodCallNode) ifTrue: [ 
			(child method == aCompiledMethod ) ifTrue: [ 
				child incrementNumberOfCalls.
				^ child ] ] ].
	^ PreciseMethodCallNode new
		method: aCompiledMethod;
		parent: self;
		yourself.
]

{ #category : #accessing }
AbstractPreciseNode >> childs [
	^ childs
]

{ #category : #initialization }
AbstractPreciseNode >> description [
	^ ''
]

{ #category : #initialization }
AbstractPreciseNode >> initialize [
	super initialize.
	childs := OrderedCollection new.
]

{ #category : #printing }
AbstractPreciseNode >> printString [
	^ self className , '(' , self description , ')'
]
