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
	block := [ MyClass new createFigures ].
	
	handler := MpAllocProfilerByEphemeronHandler new
		addClass: Rectangle;
		yourself.
		
	[ handler proxy install.
	  block value.
	  handler proxy uninstall ] valueUninterruptably.

	self assert: handler garbageCollectedObjects size equals: 5.
	self assert: handler notGarbageCollectedObject size equals: 10.
]
