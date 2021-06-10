Class {
	#name : #AbstractPreciseNode,
	#superclass : #Object,
	#instVars : [
		'childs',
		'childNodeClass'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
AbstractPreciseNode >> addChild: aNode [ 
	childs add: aNode
]

{ #category : #adding }
AbstractPreciseNode >> addMethodCall: aCompiledMethod [
	childs do: [ :child |
		(child method == aCompiledMethod ) ifTrue: [ 
			child incrementNumberOfCalls.
			^ child ] ].
	^ childNodeClass new
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
	childNodeClass := PreciseNode.
]

{ #category : #printing }
AbstractPreciseNode >> printOn: aStream [
	^ aStream << ( self className , '(' , self description , ')' )
]

{ #category : #printing }
AbstractPreciseNode >> printString [
	^ self className , '(' , self description , ')'
]
