Class {
	#name : #PreciseRoot,
	#superclass : #AbstractPreciseNode,
	#instVars : [
		'maxNumberOfCalls'
	],
	#category : #PreciseProfiler
}

{ #category : #setting }
PreciseRoot >> childNodeClass: aClass [
	childNodeClass := aClass 
]

{ #category : #accessing }
PreciseRoot >> maxNumberOfCalls [
	^ maxNumberOfCalls
]
