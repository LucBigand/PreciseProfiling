Class {
	#name : #CodeProfiler,
	#superclass : #CHInterpreter,
	#instVars : [
		'packageSpies'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #setting }
CodeProfiler >> addPackage: aPackage [
	packageSpies at: aPackage put: (PackageSpy new initializeWith: aPackage)
]

{ #category : #initialization }
CodeProfiler >> initialize [
	super initialize.
	packageSpies := Dictionary new.
]
