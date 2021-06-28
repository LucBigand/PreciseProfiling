Class {
	#name : #ClassSpy,
	#superclass : #AbstractClassSpy,
	#instVars : [
		'metaclassSpy'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #initialization }
ClassSpy >> initializeWith: aClass [ 
	super initializeWith: aClass.
	metaclassSpy := (MetaclassSpy new initializeWith: aClass class)
]

{ #category : #accessing }
ClassSpy >> metaclassSpy [
	^ metaclassSpy
]
