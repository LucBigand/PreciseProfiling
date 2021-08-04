"
I am a method proxy handler applied on the method Behavior>>#basicNew to keep track on instantiated objects through an ephemeron.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	classesSpied:		The set of classes whose instanciated objects are being tracked
	ephemerons:		A set of LogGCEphemeron associated with the tracked objects

Example

obj := MyClass new.
block := [ obj createFigures ]. ""MyClass>>#createFigures instantiates 15 rectangles but only keep 10 of them in memory""
h := MpAllocProfilerByEphemeronHandler new
	addClass: Rectangle;
	yourself.
h garbageCollectedObjects. ""Should return a set of 5 rectangles""
h notGarbageCollectedObjects. ""Should return a set of 10 rectangles""
"
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
	"Add a class to the set of classes whose instanciated objects are being kept track of"
	classesSpied add: aClass
]

{ #category : #evaluating }
MpAllocProfilerByEphemeronHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [
	"Upon instanciation of an object whose class is being spied, add an ephemeron corresponding to
	the object to keep track of it"
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
		thenCollect: [ :ephemeron | ephemeron key ]
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
MpAllocProfilerByEphemeronHandler >> notGarbageCollectedObjects [
	^ ephemerons reject: [ :ephemeron | ephemeron wasGarbageCollected ]
		thenCollect: [ :ephemeron | ephemeron key ]
]

{ #category : #accessing }
MpAllocProfilerByEphemeronHandler >> proxy [
	^ proxy
]
