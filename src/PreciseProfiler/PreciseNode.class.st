Class {
	#name : #PreciseNode,
	#superclass : #Object,
	#instVars : [
		'childs',
		'parent',
		'method',
		'numberOfCalls'
	],
	#category : #PreciseProfiler
}

{ #category : #setting }
PreciseNode >> addChild: aNode [ 
	childs add: aNode
]

{ #category : #setting }
PreciseNode >> addMethodCall: aMethodName [
	| child |
	"Not optimized, rewrite it later"
	((childs collect: [ :each | each methodName ]) includes: aMethodName)
		ifTrue: [ 
			child := childs detect: [ :each | each methodName == aMethodName ].
			child incrementNumberOfCalls. ]
		ifFalse: [ 
			child := self class new
				initializeWith: aMethodName;
				parent: self;
				yourself ].
	^ child
]

{ #category : #accessing }
PreciseNode >> childs [
	^ childs
]

{ #category : #setting }
PreciseNode >> incrementNumberOfCalls [
	numberOfCalls := numberOfCalls + 1.
	
]

{ #category : #initialization }
PreciseNode >> initialize [
	super initialize.
	childs := OrderedCollection new.
]

{ #category : #initialization }
PreciseNode >> initializeWith: aCompiledMethod [ 
	method := aCompiledMethod.
	numberOfCalls := 1.
]

{ #category : #accessing }
PreciseNode >> method [
	^ method
]

{ #category : #accessing }
PreciseNode >> parent [
	^ parent
]

{ #category : #setting }
PreciseNode >> parent: aPreciseNode [
	parent := aPreciseNode.
	aPreciseNode addChild: self.
]

{ #category : #printing }
PreciseNode >> printString [
	method isNil ifTrue: [ ^ 'aPreciseNode()' ].
	^ 'aPreciseNode(', method classBinding value asString, '>>#', method selector asString,
		' - ', numberOfCalls asString, ')'
]
