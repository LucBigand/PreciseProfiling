"
I contain the profiling data for a non-meta class. I extend AbstractClassSpy with a reference to a class spy for my metaclass

    Instance Variables
	metaclassSpy: The metaclass spy corresponding to the metaclass of the class being spied
"
Class {
	#name : #ClassSpy,
	#superclass : #AbstractClassSpy,
	#instVars : [
		'metaclassSpy'
	],
	#category : #'PreciseProfiler-Spy'
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
