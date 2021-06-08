Class {
	#name : #PreciseInterpreter,
	#superclass : #CHInterpreter,
	#instVars : [
		'methodList',
		'currentNode',
		'nextNode'
	],
	#category : #PreciseProfiler
}

{ #category : #running }
PreciseInterpreter >> class: aClass hasMethod: aSelector [
	^ (aClass methods collect: [ :each | each selector ]) includes: aSelector.
]

{ #category : #display }
PreciseInterpreter >> display [
	PreciseInterpreterDisplay openOn: self
]

{ #category : #initialization }
PreciseInterpreter >> initialize [
	super initialize.
	methodList := Dictionary new.
	currentNode := PreciseRoot new.
]

{ #category : #accessing }
PreciseInterpreter >> methodList [
	^ methodList
]

{ #category : #setting }
PreciseInterpreter >> popFrame [
	currentNode := currentNode parent.
	^ super popFrame.
]

{ #category : #setting }
PreciseInterpreter >> pushNewFrame [
	currentNode := nextNode.
	^ super pushNewFrame.
]

{ #category : #visiting }
PreciseInterpreter >> registerAllocation [
	| key |
	key := 'Object allocation'.
	(methodList includesKey: key )
		ifTrue: [ methodList at: key update: [ :count | count + 1 ] ] 
		ifFalse: [ methodList at: key put: 1 ].
]

{ #category : #visiting }
PreciseInterpreter >> registerMethodCall: aCompiledMethod [
	| method |
	method := (aCompiledMethod classBinding value == CHBlock)
		ifTrue: [ FullBlockClosure >> (aCompiledMethod selector) ] 
		ifFalse: [ aCompiledMethod ].
	(methodList includesKey: method)
		ifTrue: [ methodList at: method update: [ :count | count + 1 ] ]
		ifFalse: [ methodList at: method put: 1 ].
	nextNode := currentNode addMethodCall: method.
	
]

{ #category : #accessing }
PreciseInterpreter >> rootNode [
	^ currentNode
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
	self registerMethodCall: (lookupClass >> aSelector).
	^ self execute: ast withReceiver: aReceiver andArguments: args.
]

{ #category : #visiting }
PreciseInterpreter >> visitAssignmentNode: aNode [
	self registerAllocation.
	^ super visitAssignmentNode: aNode
]

{ #category : #visiting }
PreciseInterpreter >> visitMessageNode: aNode [
	| dict |
	dict := self auxVisitMessageNode: aNode.
	self registerMethodCall: (dict at: 'method').
	^ self 
		execute: ((dict at: 'method') ast)
		withReceiver: (dict at: 'receiver')
		andArguments: (dict at: 'args').
]
