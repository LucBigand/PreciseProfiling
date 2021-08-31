"
I represent the internal representation of the Pharo environment and its global variables within a CHInterpreter within a CHInterpreter. 

    Instance Variables
	globalsDictionary:		A dictionary that associates the names of global variables in the simulation of the program's execution with their values
"
Class {
	#name : #CHGlobalScope,
	#superclass : #Object,
	#instVars : [
		'globalsDictionary'
	],
	#category : #'Champollion-Core'
}

{ #category : #accessing }
CHGlobalScope >> at: aKey ifAbsent: aBlock [
	"^ globalsDictionary at: aKey ifAbsent: aBlock."
	^ globalsDictionary at: aKey ifAbsent: [ 
		^ self class environment at: aKey ifAbsent: aBlock ]
]

{ #category : #setting }
CHGlobalScope >> at: aKey put: aValue [
	globalsDictionary at: aKey put: aValue.
]

{ #category : #setting }
CHGlobalScope >> globalsDictionary: anObject [
	globalsDictionary := anObject.
]

{ #category : #initialization }
CHGlobalScope >> initialize [
	super initialize.
	globalsDictionary := Dictionary new.
]

{ #category : #accessing }
CHGlobalScope >> read: aString [
	globalsDictionary at: aString.
]

{ #category : #utility }
CHGlobalScope >> scopeDefining: aString [
	(globalsDictionary includesKey: aString)
		ifTrue: [ ^ self ] 
		ifFalse: [ Exception new signal ]
]
