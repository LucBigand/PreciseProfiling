Class {
	#name : #MpProfilingHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'admin'
	],
	#category : #'PreciseProfiler-Tests'
}

{ #category : #setup }
MpProfilingHandlerTest >> setUp [
	super setUp .
	admin := MpProfilingAdministrator new.
	admin addMethod: Number >> #**.
	admin runOn: [ 5 ** 3 ].
]

{ #category : #test }
MpProfilingHandlerTest >> testProfilerHasNotRegisteredScaledDecimalRaisedTo [
	self assert: (admin stacks noneSatisfy: [ :stack | 
		stack context last == ( ScaledDecimal >> #raisedTo: ) ] )
]

{ #category : #test }
MpProfilingHandlerTest >> testProfilerHasRegisteredIsIntegerMethodAndItsSenders [
	self assert: (admin stacks anySatisfy: [ :stack | 
		stack context first = ( Integer >> #isInteger )
		and: [ stack context second = ( Number >> #raisedTo: ) ] ] )
]

{ #category : #test }
MpProfilingHandlerTest >> testProfilerHasRegisteredSmallIntExponentiationMethod [
	self assert: (admin stacks anySatisfy: [ :stack | 
		stack context last == ( Number >> #** ) ] )
]
