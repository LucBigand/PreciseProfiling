Class {
	#name : #PreciseInterpreter,
	#superclass : #CHInterpreter,
	#instVars : [
		'methodList'
	],
	#category : #PreciseProfiler
}

{ #category : #running }
PreciseInterpreter >> class: aClass hasMethod: aSelector [
	^ (aClass methods collect: [ :each | each selector ]) includes: aSelector.
]

{ #category : #initialization }
PreciseInterpreter >> initialize [
	super initialize.
	methodList := Dictionary new.
]

{ #category : #accessing }
PreciseInterpreter >> methodList [
	^ methodList
]

{ #category : #visiting }
PreciseInterpreter >> registerMethodCall: aCompiledMethod [
	(methodList includesKey: aCompiledMethod)
		ifTrue: [ methodList at: aCompiledMethod update: [ :count | count + 1 ] ]
		ifFalse: [ methodList at: aCompiledMethod put: 1 ].
]

{ #category : #running }
PreciseInterpreter >> runOn: aClass method: aSelector [
	methodList := Dictionary new.
	^ self runOn: aClass method: aSelector andArguments: #()
]

{ #category : #running }
PreciseInterpreter >> runOn: aReceiver method: aSelector andArguments: args [
	| ast lookupClass |
	lookupClass := aReceiver class.
	[ (lookupClass isNotNil) and: (self class: lookupClass hasMethod: aSelector) not ] whileTrue: 
		[ lookupClass := lookupClass superclass ].
	ast := (lookupClass >> aSelector) parseTree.
	^ self execute: ast withReceiver: aReceiver andArguments: args.
]

{ #category : #visiting }
PreciseInterpreter >> visitMessageNode: aNode [
	| newReceiver method args lookupClass |
	newReceiver := self visitNode: aNode receiver.
	args := aNode arguments collect: [ :each | self visitNode: each ].
	lookupClass := aNode receiver isSuperVariable
		               ifTrue: [ self currentMethod methodClass superclass ]
		               ifFalse: [ newReceiver class ].
	method := self lookup: aNode selector fromClass: lookupClass.
	self registerMethodCall: method.
	^ self execute: (method ast) withReceiver: newReceiver andArguments: args.
]
