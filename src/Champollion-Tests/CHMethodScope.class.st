Class {
	#name : #CHMethodScope,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'variables',
		'parentScope',
		'previousScope'
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

{ #category : #setting }
CHMethodScope >> previousScope: aMethodScope [
	previousScope := aMethodScope
]

{ #category : #accessing }
CHMethodScope >> read: aString [
	(self includesKey: aString)
		ifTrue: [ ^ variables at: aString ] 
		ifFalse: [ ^ previousScope read: aString ] .
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

{ #category : #accessing }
CHMethodScope >> variables [
	^ variables copy
]

{ #category : #setting }
CHMethodScope >> write: aString withValue: aValue [
	variables at: aString put: aValue.
]
