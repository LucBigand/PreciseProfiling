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

{ #category : #accessing }
PreciseMethodCallNode >> method [
	^ method
]

{ #category : #setting }
PreciseMethodCallNode >> method: aCompiledMethod [
	method := aCompiledMethod
]
