Class {
	#name : #CHGlobalScope,
	#superclass : #Object,
	#instVars : [
		'globalsDictionary'
	],
	#category : #'Champollion-Tests'
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
