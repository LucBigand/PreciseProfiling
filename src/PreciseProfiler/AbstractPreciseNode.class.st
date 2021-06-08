Class {
	#name : #AbstractPreciseNode,
	#superclass : #Object,
	#instVars : [
		'childs'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
AbstractPreciseNode >> addChild: aNode [ 
	childs add: aNode
]

{ #category : #adding }
AbstractPreciseNode >> addMethodCall: aCompiledMethod [
	| child |
	"Not optimized, rewrite it later"
	((childs collect: [ :each | each method ]) includes: aCompiledMethod)
		ifTrue: [ 
			child := childs detect: [ :each | each method == aCompiledMethod ].
			child incrementNumberOfCalls. ]
		ifFalse: [ 
			child := PreciseMethodCallNode new
				initializeWith: aCompiledMethod;
				parent: self;
				yourself ].
	^ child
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
