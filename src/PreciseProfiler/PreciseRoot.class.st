Class {
	#name : #PreciseRoot,
	#superclass : #Object,
	#instVars : [
		'childs'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
PreciseRoot >> addChild: aNode [ 
	childs add: aNode
]

{ #category : #adding }
PreciseRoot >> addMethodCall: aCompiledMethod [
	| child |
	"Not optimized, rewrite it later"
	((childs collect: [ :each | each method ]) includes: aCompiledMethod)
		ifTrue: [ 
			child := childs detect: [ :each | each method == aCompiledMethod ].
			child incrementNumberOfCalls. ]
		ifFalse: [ 
			child := self class new
				initializeWith: aCompiledMethod;
				parent: self;
				yourself ].
	^ child
]

{ #category : #accessing }
PreciseRoot >> childs [
	^ childs
]

{ #category : #initialization }
PreciseRoot >> initialize [
	super initialize.
	childs := OrderedCollection new.
]
