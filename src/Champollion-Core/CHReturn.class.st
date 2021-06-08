Class {
	#name : #CHReturn,
	#superclass : #Error,
	#instVars : [
		'value',
		'homeFrame'
	],
	#category : #'Champollion-Core'
}

{ #category : #accessing }
CHReturn >> homeFrame [
	^ homeFrame  
]

{ #category : #setting }
CHReturn >> homeFrame: aFrame [
	homeFrame := aFrame
]

{ #category : #accessing }
CHReturn >> value [
	^ value 
]

{ #category : #setting }
CHReturn >> value: aValue [
	value := aValue
]
