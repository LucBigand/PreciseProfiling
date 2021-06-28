Class {
	#name : #MethodSpy,
	#superclass : #Object,
	#instVars : [
		'incomingCalls',
		'outgoingCalls',
		'receivers',
		'numberOfCalls'
	],
	#category : #'PreciseProfiler - Spy'
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
