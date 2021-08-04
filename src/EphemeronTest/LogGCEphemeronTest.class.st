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
	self 
		assert: ephemeron wasGarbageCollected
		equals: false
]
