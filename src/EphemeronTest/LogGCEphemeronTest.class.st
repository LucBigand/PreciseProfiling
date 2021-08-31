Class {
	#name : #LogGCEphemeronTest,
	#superclass : #TestCase,
	#type : #ephemeron,
	#category : #EphemeronTest
}

{ #category : #tests }
LogGCEphemeronTest >> testEphemeronShowsGarbageCollection [
	| obj ephemeron|
	obj := Object new.
	ephemeron := LogGCEphemeron new
   		key: obj;
  		yourself.
	obj := nil.
	5 timesRepeat: [ Smalltalk garbageCollect ].
	self 
		assert: ephemeron wasGarbageCollected
		equals: true
]

{ #category : #tests }
LogGCEphemeronTest >> testEphemeronShowsNoGarbageCollection [
	| obj ephemeron|
	obj := Object new.
	ephemeron := LogGCEphemeron new
   		key: obj;
  		yourself.
	5 timesRepeat: [ Smalltalk garbageCollect ].
	self 
		assert: ephemeron wasGarbageCollected
		equals: false
]
