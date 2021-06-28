Class {
	#name : #CodeProfiler,
	#superclass : #CHInterpreter,
	#instVars : [
		'packageSpies',
		'currentMethod'
	],
	#category : #'PreciseProfiler - Spy'
}

{ #category : #setting }
CodeProfiler >> addPackage: aPackage [
	packageSpies at: aPackage put: (PackageSpy new initializeWith: aPackage)
]

{ #category : #accessing }
CodeProfiler >> classSpies [
	| res |
	res := Set new.
	self packageSpies do: [ :packageSpy |
		res addAll: packageSpy classSpies ].
	^ res
]

{ #category : #accessing }
CodeProfiler >> classSpyAt: aClass [
	^ (self packageSpyAt: aClass package) classSpyAt: aClass
]

{ #category : #initialization }
CodeProfiler >> initialize [
	super initialize.
	packageSpies := Dictionary new.
]

{ #category : #accessing }
CodeProfiler >> metaclassSpies [
	^ self classSpies collect: [ :classSpy | classSpy metaclassSpy ]
]

{ #category : #accessing }
CodeProfiler >> metaclassSpyAt: aClass [
	^ (self classSpyAt: aClass) metaclassSpy
]

{ #category : #accessing }
CodeProfiler >> methodSpies [
	| res |
	res := Set new.
	self classSpies do: [ :classSpy |
		res addAll: classSpy methodSpies ].
	^ res
]

{ #category : #accessing }
CodeProfiler >> methodSpyAt: aMethod [
	^ ((self packageSpyAt: aMethod classBinding value package)
		classSpyAt: aMethod class)
			methodSpyAt: aMethod
]

{ #category : #accessing }
CodeProfiler >> packageSpies [
	^ packageSpies values asSet
]

{ #category : #accessing }
CodeProfiler >> packageSpyAt: aPackage [
	^ packageSpies at: aPackage
]

{ #category : #visiting }
CodeProfiler >> visitMessageNode: aNode [
	| dict |
	dict := self auxVisitMessageNode: aNode.
	currentMethod := (dict at: 'method').
	^ self 
		execute: ((dict at: 'method') ast)
		withReceiver: (dict at: 'receiver')
		andArguments: (dict at: 'args').
]
