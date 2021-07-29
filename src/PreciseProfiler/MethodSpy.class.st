"
I contain the profiling data for a method spy. I register information pertaining to the methods that call and are called by this method.
 
    Instance Variables
	incomingCalls: A set of all the methods that call this method
	numberOfCalls:	The number of time this method has been called during the execution of the code being profiled by the code profiler.
	outgoingCalls: A set of all the methods called by this method
	receivers: A set of all the objects that have initialized a call to this method
"
Class {
	#name : #MethodSpy,
	#superclass : #Object,
	#instVars : [
		'incomingCalls',
		'outgoingCalls',
		'receivers',
		'numberOfCalls'
	],
	#category : #'PreciseProfiler-Spy'
}

{ #category : #accessing }
MethodSpy >> incomingCalls [
	^ incomingCalls
]

{ #category : #setting }
MethodSpy >> incrementNumberOfCalls [
	numberOfCalls := numberOfCalls + 1
]

{ #category : #initialization }
MethodSpy >> initialize [ 
	super initialize.
	incomingCalls := Set new.
	outgoingCalls := Set new.
	receivers := Set new.
	numberOfCalls := 0
]

{ #category : #accessing }
MethodSpy >> numberOfCalls [
	^ numberOfCalls  
]

{ #category : #accessing }
MethodSpy >> numberOfExecutions [
	^ numberOfCalls
]

{ #category : #accessing }
MethodSpy >> numberOfReceivers [
	^ receivers size
]

{ #category : #accessing }
MethodSpy >> outgoingCalls [
	^ outgoingCalls 
]

{ #category : #registering }
MethodSpy >> registerIncomingCall: aCompiledMethod fromReceiver: anObject [
	incomingCalls add: aCompiledMethod.
	receivers add: anObject.
	self incrementNumberOfCalls
]

{ #category : #registering }
MethodSpy >> registerOutgoingCall: aCompiledMethod [
	outgoingCalls add: aCompiledMethod
]
