"
I am a node within a tree of nodes meant to represent the calling context of a program analysed through precise profiling. This tree is usually generated during the execution of a PreciseInterpreter or of one of its subclasses.

    Instance Variables
	childNodeClass:		As for value PreciseNode or one of its subclasses. Defines the class of the childs of this node
	childs:		The childs of this node
"
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
	"Registers a call of aCompiledMethod within this method context"
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
