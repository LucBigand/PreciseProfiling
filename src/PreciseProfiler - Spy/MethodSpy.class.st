Class {
	#name : #MethodSpy,
	#superclass : #Object,
	#instVars : [
		'incomingCalls',
		'outgoingCalls'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #accessing }
MethodSpy >> incomingCalls [
	^ incomingCalls
]

{ #category : #initialization }
MethodSpy >> initialize [ 
	super initialize.
	incomingCalls := Set new.
	outgoingCalls := Set new.
]

{ #category : #accessing }
MethodSpy >> outgoingCalls [
	^ outgoingCalls 
]
