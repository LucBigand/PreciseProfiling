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

{ #category : #running }
PreciseInterpreter >> runOn: aClass method: aSelector [
	^ self runOn: aClass method: aSelector andArguments: #()
]

{ #category : #running }
PreciseInterpreter >> runOn: aReceiver method: aSelector andArguments: args [
	| ast lookupClass |
	lookupClass := aReceiver class.
	[ (lookupClass isNotNil) and: (self class: lookupClass hasMethod: aSelector) not ] whileTrue: 
		[ lookupClass := lookupClass superclass ].
	ast := (lookupClass >> aSelector) parseTree.
	"receiver := (lookupClass isMeta)
		ifTrue: [ nil ]
		ifFalse: [ aReceiver new ]."
	^ self execute: ast withReceiver: aReceiver andArguments: args.
]
