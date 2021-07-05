Class {
	#name : #CHMethodScope,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'variables',
		'parentScope'
	],
	#category : #'Champollion-Core'
}

{ #category : #initialization }
CHMethodScope >> homeFrame [
	| currentLookupFrame |
	currentLookupFrame := self.
	[ currentLookupFrame includesKey: #__definingContext ]
		whileTrue: [ currentLookupFrame := currentLookupFrame read: #__definingContext ].
	^ currentLookupFrame
]

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
	(self includesKey: aString)
		ifTrue: [ ^ variables at: aString ].
	((receiver class == CHBlock) and: (FullBlockClosure allInstVarNames includes: aString))
		ifTrue: [ ^ receiver perform: aString ].
	^ (variables at: #__definingContext) read: aString.
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
	((receiver class == CHBlock) and: (FullBlockClosure allInstVarNames includes: aString))
		ifTrue: [ ^ self ].
	^ self parentScope scopeDefining: aString.
]

{ #category : #accessing }
CHMethodScope >> variables [
	^ variables copy
]

{ #category : #setting }
CHMethodScope >> write: aString withValue: aValue [
	variables at: aString put: aValue.
]
