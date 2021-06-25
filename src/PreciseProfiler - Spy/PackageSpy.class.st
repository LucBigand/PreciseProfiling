Class {
	#name : #PackageSpy,
	#superclass : #Object,
	#instVars : [
		'classSpies'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #setting }
PackageSpy >> addClass: aClass [
	| classSpy |
	classSpy := ClassSpy new initializeWith: aClass.
	(aClass package == aClass superclass package)
		ifTrue: [ classSpy setSuperclassSpy: (self addClass: aClass superclass) ].
	classSpies at: aClass put: classSpy.
	^ classSpy
]

{ #category : #initialization }
PackageSpy >> initialize [
	super initialize.
	classSpies := Dictionary new.
]

{ #category : #initialization }
PackageSpy >> initializeWith: aPackage [
	| classes |
	classes := aPackage classes select: [ :class |
		 (class subclasses intersection: aPackage classes) isEmpty ].
	classes do: [ :class | self addClass: class ]
]
