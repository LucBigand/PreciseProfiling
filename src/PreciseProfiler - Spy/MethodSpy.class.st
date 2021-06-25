Class {
	#name : #MethodSpy,
	#superclass : #Object,
	#instVars : [
		'incomingCalls',
		'outgoingCalls'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #initialization }
MethodSpy >> initialize [ 
	super initialize.
	incomingCalls := Set new.
	outgoingCalls := Set new.
]
