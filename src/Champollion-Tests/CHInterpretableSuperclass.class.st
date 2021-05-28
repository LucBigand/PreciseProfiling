Class {
	#name : #CHInterpretableSuperclass,
	#superclass : #CHInterpretableSecondSuperclass,
	#category : #'Champollion-Tests'
}

{ #category : #return }
CHInterpretableSuperclass >> isInSuperclass [
	^ true.
]

{ #category : #return }
CHInterpretableSuperclass >> methodInSuperclass [
	^ 5.
]

{ #category : #return }
CHInterpretableSuperclass >> overridenMethod [
	^ 5
]

{ #category : #return }
CHInterpretableSuperclass >> redefinedMethod [
	^ super redefinedMethod.
]
