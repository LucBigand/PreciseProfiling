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
		stack last == ( ScaledDecimal >> #raisedTo: ) ] )
]

{ #category : #test }
MpProfilingHandlerTest >> testProfilerHasRegisteredIsIntegerMethodAndItsSenders [
	self assert: (admin stacks anySatisfy: [ :stack | 
		stack first = ( Integer >> #isInteger )
		and: [ stack second = ( Number >> #raisedTo: ) ] ] )
]

{ #category : #test }
MpProfilingHandlerTest >> testProfilerHasRegisteredSmallIntExponentiationMethod [
	self assert: (admin stacks anySatisfy: [ :stack | 
		stack last == ( Number >> #** ) ] )
]
