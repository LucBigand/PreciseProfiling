Class {
	#name : #AbstractClassSpy,
	#superclass : #Object,
	#instVars : [
		'methodSpies',
		'superclassSpy'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #setting }
AbstractClassSpy >> addMethod: aMethod [
	methodSpies at: aMethod put: MethodSpy new.
]

{ #category : #initialization }
AbstractClassSpy >> initialize [
	super initialize.
	methodSpies := Dictionary new.
]

{ #category : #initialization }
AbstractClassSpy >> initializeWith: aClass [
	aClass methods do: [ :method | self addMethod: method ]
]

{ #category : #setting }
AbstractClassSpy >> setSuperclassSpy: aClassSpy [
	superclassSpy := aClassSpy
]
