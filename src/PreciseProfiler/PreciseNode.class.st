Class {
	#name : #PreciseNode,
	#superclass : #PreciseRoot,
	#instVars : [
		'parent',
		'method',
		'numberOfCalls'
	],
	#category : #PreciseProfiler
}

{ #category : #setting }
PreciseNode >> incrementNumberOfCalls [
	numberOfCalls := numberOfCalls + 1.
	
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
