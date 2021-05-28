Class {
	#name : #CHMethodScope,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'variables',
		'parentScope'
	],
	#category : #'Champollion-Tests'
}

{ #category : #testing }
CHMethodScope >> includesKey: aKey [
	^ variables includesKey: aKey
]

{ #category : #initialization }
CHMethodScope >> initialize [
	super initialize.
	variables := Dictionary new.
]

{ #category : #accessing }
CHMethodScope >> parentScope [
	^ parentScope
]

{ #category : #setting }
CHMethodScope >> parentScope: anObject [
	parentScope := anObject.
]

{ #category : #accessing }
CHMethodScope >> read: aString [
	^ variables at: aString
]

{ #category : #accessing }
CHMethodScope >> receiver [
	^ receiver.
]

{ #category : #setting }
CHMethodScope >> receiver: aCHInterpretable [
	receiver := aCHInterpretable.
]

{ #category : #accessing }
CHMethodScope >> scopeDefining: aString [
	(variables includesKey: aString)
		ifTrue: [ ^ self ].
		
	^ self parentScope scopeDefining: aString
]

{ #category : #setting }
CHMethodScope >> write: aString withValue: aValue [
	variables at: aString put: aValue.
]
