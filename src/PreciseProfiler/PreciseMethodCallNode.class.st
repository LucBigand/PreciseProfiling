Class {
	#name : #PreciseMethodCallNode,
	#superclass : #AbstractPreciseNonRootNode,
	#instVars : [
		'method'
	],
	#category : #PreciseProfiler
}

{ #category : #printing }
PreciseMethodCallNode >> description [
	method ifNil: [ ^ '' ].
	^ method classBinding value asString, '>>#', method selector asString, ' - ', numberOfCalls asString
]

{ #category : #initialization }
PreciseMethodCallNode >> initializeWith: aCompiledMethod [ 
	method := aCompiledMethod.
	numberOfCalls := 1.
]

{ #category : #accessing }
PreciseMethodCallNode >> method [
	^ method
]
