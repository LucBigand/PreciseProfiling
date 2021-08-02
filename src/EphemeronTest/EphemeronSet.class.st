Class {
	#name : #EphemeronSet,
	#superclass : #Set,
	#type : #ephemeron,
	#category : #EphemeronTest
}

{ #category : #'instance creation' }
EphemeronSet class >> basicNew [
	self allInstances 
		ifEmpty: [ ^ super basicNew ]
		ifNotEmpty: [ ^ self allInstances first ]
]

{ #category : #accessing }
EphemeronSet class >> get [
	^ self basicNew
]
