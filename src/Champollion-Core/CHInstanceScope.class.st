"
I represent the internal representation of a receiver within a CHInterpreter. I am able to access and modify the instance variables of this interpreter 

    Instance Variables
	parentScope:		A CHGlobalScope
	receiver:		The receiver of the method currently simulated in CHInterpreter
"
Class {
	#name : #CHInstanceScope,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'parentScope'
	],
	#category : #'Champollion-Core'
}

{ #category : #accessing }
CHInstanceScope >> definedVariables [
	^ receiver class allInstVarNames .
]

{ #category : #setting }
CHInstanceScope >> parentScope: anObject [
	parentScope := anObject.
]

{ #category : #accessing }
CHInstanceScope >> read: aString [
	^ receiver instVarNamed: aString.
]

{ #category : #setting }
CHInstanceScope >> receiver: anObject [
	receiver := anObject.
]

{ #category : #accessing }
CHInstanceScope >> scopeDefining: aString [
	(self definedVariables includes: aString)
		ifTrue: [ ^ self ].
	^ parentScope scopeDefining: aString.
]

{ #category : #setting }
CHInstanceScope >> write: aString withValue: anObject [
	receiver instVarNamed: aString put: anObject.
]
