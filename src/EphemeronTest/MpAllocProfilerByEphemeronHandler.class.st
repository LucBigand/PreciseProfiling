Class {
	#name : #MpAllocProfilerByEphemeronHandler,
	#superclass : #MpHandler,
	#instVars : [
		'classesSpied',
		'ephemerons'
	],
	#category : #EphemeronTest
}

{ #category : #setting }
MpAllocProfilerByEphemeronHandler >> addClass: aClass [
	classesSpied add: aClass
]

{ #category : #evaluating }
MpAllocProfilerByEphemeronHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [
	| ephemeron |
	( classesSpied includes: receiver ) ifFalse: [ ^ returnValue ].
	ephemeron := LogGCEphemeron new
   		key: returnValue;
  		yourself.
	ephemerons add: ephemeron.
	^ returnValue
]

{ #category : #accessing }
MpAllocProfilerByEphemeronHandler >> garbageCollectedObjects [
	^ ephemerons select: [ :ephemeron | ephemeron wasGarbageCollected ]
]

{ #category : #initialization }
MpAllocProfilerByEphemeronHandler >> initialize [
	super initialize.
	classesSpied := Set new.
	ephemerons := Set new.
	proxy := MpMethodProxy
		onMethod: Behavior >> #basicNew
		handler: self
]

{ #category : #accessing }
MpAllocProfilerByEphemeronHandler >> notGarbageCollectedObject [
	^ ephemerons reject: [ :ephemeron | ephemeron wasGarbageCollected ]
]

{ #category : #accessing }
MpAllocProfilerByEphemeronHandler >> proxy [
	^ proxy
]
