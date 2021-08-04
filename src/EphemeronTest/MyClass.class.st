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
	1 to: 10 do: [ :i | figures add: (Rectangle origin: 0@0 corner: 100@100 ) ].
	1 to: 5 do: [ :i | Rectangle origin: 0@0 corner: 100@100 ]
]

{ #category : #initialization }
MyClass >> initialize [
	super initialize.
	figures := OrderedCollection new.
]
