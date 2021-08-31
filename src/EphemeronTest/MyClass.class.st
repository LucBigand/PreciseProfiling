"
Class used to test the implementation of ephemerons
"
Class {
	#name : #MyClass,
	#superclass : #Object,
	#instVars : [
		'figures'
	],
	#category : #EphemeronTest
}

{ #category : #creating }
MyClass >> createFigures [
	1 to: 10 do: [ :i | figures add: (Rectangle origin: 0@0 corner: i@i ) ].
	11 to: 15 do: [ :i | Rectangle origin: 0@0 corner: i@i ]
]

{ #category : #initialization }
MyClass >> initialize [
	super initialize.
	figures := OrderedCollection new.
]
