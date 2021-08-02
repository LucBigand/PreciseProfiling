Class {
	#name : #MpAllocProfilerByEphemeronHandler,
	#superclass : #MpAllocationProfilerHandler,
	#category : #EphemeronTest
}

{ #category : #evaluating }
MpAllocProfilerByEphemeronHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [
	| ephemeron |
	ephemeron := LogGCEphemeron new
   		key: returnValue;
  		yourself.
	^ super
		afterExecutionWithReceiver: receiver 
		arguments: arguments  
		returnValue: ephemeron
]
