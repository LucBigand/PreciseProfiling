Class {
	#name : #LogGCEphemeron,
	#superclass : #Association,
	#type : #ephemeron,
	#instVars : [
		'wasGarbageCollected'
	],
	#category : #EphemeronTest
}

{ #category : #initialization }
LogGCEphemeron >> = anEphemeron [
	^ key == anEphemeron key
]

{ #category : #initialization }
LogGCEphemeron >> initialize [
	super initialize.
	wasGarbageCollected := false
]

{ #category : #mourning }
LogGCEphemeron >> mourn [
	key printString traceCr.
	wasGarbageCollected := true
]

{ #category : #accessing }
LogGCEphemeron >> wasGarbageCollected [
	^ wasGarbageCollected 
]
