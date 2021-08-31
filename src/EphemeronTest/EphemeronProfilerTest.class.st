Class {
	#name : #EphemeronProfilerTest,
	#superclass : #TestCase,
	#type : #ephemeron,
	#category : #EphemeronTest
}

{ #category : #tests }
EphemeronProfilerTest >> testProfilingOfObjectCreationIsAccurate [
	| obj block handler |
	
	obj := MyClass new.
	block := [ obj createFigures ].
	
	handler := MpAllocProfilerByEphemeronHandler new
		addClass: Rectangle;
		yourself.
		
	[ handler proxy install.
	  block value.
	  handler proxy uninstall ] valueUninterruptably.

	5 timesRepeat: [ Smalltalk garbageCollect ].

	self assert: handler garbageCollectedObjects size equals: 5.
	self assert: handler notGarbageCollectedObjects size equals: 10.
]
