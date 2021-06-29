Class {
	#name : #CHInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter',
		'receiver',
		'collaborator'
	],
	#category : #'Champollion-Tests'
}

{ #category : #ast }
CHInterpreterTest >> class: aClass hasMethod: aSelector [
	^ (aClass methods collect: [ :each | each selector ]) includes: aSelector.
]

{ #category : #ast }
CHInterpreterTest >> executeSelector: aSymbol [
	^ self executeSelector: aSymbol withReceiver: receiver.
]

{ #category : #ast }
CHInterpreterTest >> executeSelector: aSymbol withReceiver: aReceiver [
	| ast lookupClass |
	lookupClass := CHInterpretable.
	[ (lookupClass isNotNil) and: (self class: lookupClass hasMethod: aSymbol) not ] whileTrue: 
		[ lookupClass := lookupClass superclass ].
	ast := (lookupClass >> aSymbol) parseTree.
	^ interpreter execute: ast withReceiver: aReceiver.
]

{ #category : #accessing }
CHInterpreterTest >> interpreter [
	^ CHInterpreter new.
]

{ #category : #utility }
CHInterpreterTest >> peanoToInt: aPeanoNumber [
	^ aPeanoNumber
		ifEmpty: [ 0 ] 
		ifNotEmpty: [ 1 + (self peanoToInt: aPeanoNumber first) ].
]

{ #category : #running }
CHInterpreterTest >> setUp [
	super setUp.
	receiver := CHInterpretable new.
	collaborator := CHInterpretable new.
	receiver collaborator: collaborator.
	interpreter := CHInterpreter new.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testArgumentAccess [
	receiver x: 200.
	collaborator x: 300.
	self executeSelector: #changeCollaboratorWithArgument.
	self assert: receiver x equals: 200.
	self assert: collaborator x equals: 500.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testAssignmentReturnsAssignedValue [
	self
		assert: (self executeSelector: #store100intoX)
		equals: receiver .
	self
		assert: receiver x
		equals: 100
]

{ #category : #'tests - return' }
CHInterpreterTest >> testBalancingStack [
	self
		assert: (self executeSelector: #setXAndMessage)
		equals: 1000.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testBlockValueIsLastStatementValue [
	"TODO : rewrite the test"
	
]

{ #category : #'tests - return' }
CHInterpreterTest >> testBlockValueWithTemporaries [
	self
		assert: (self executeSelector: #returnBlockValueWithTemporaries)
		equals: 3.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testCascadeMessage [
	self
		assert: (self executeSelector: #cascadeMessage)
		equals: 300.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testEvaluationOrder [
	| argumentEvaluationOrder |
	argumentEvaluationOrder := self executeSelector: #returnEvaluationOrder.
	self assert: (self peanoToInt: receiver evaluationOrder) equals: 0.
	self
		assert: (argumentEvaluationOrder collect:[ :peano | self peanoToInt: peano])
		equals: #(1 2 3).
]

{ #category : #'tests - return' }
CHInterpreterTest >> testFailingPrimitive [
	self
		assert: (self executeSelector: #callingFailingPrimitive)
		equals: 'failure'.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testIncreaseEnclosingTemporary [
	self
		assert: (self executeSelector: #increaseEnclosingTemporary)
		equals: 1.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testInstanceVariableStoreInMethodActivationDoesNotChangeSender [
	receiver x: 200.
	collaborator x: 300.
	self executeSelector: #changeCollaboratorX.
	self assert: receiver x equals: 200.
	self assert: collaborator x equals: 100.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testLastExpression [
	self
		assert: (self executeSelector: #lastExpression)
		equals: 43.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testLookupMessageInSuperclass [
	self
		assert: (self executeSelector: #sendMessageInSuperclass)
		equals: 5.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testLookupRedefinedMethod [
	self
		assert: (self executeSelector: #overridenMethod)
		equals: 5.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testLookupSuperMessage [
	self 
		assert: (self executeSelector: #doesSuperLookupFromSuperclass)
		equals: true.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testLookupSuperMessageNotInReceiverSuperclass [
	self
		assert: (self executeSelector: #redefinedMethod)
		equals: 5.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testMethodWithGuard [
	self 
		assert: (self executeSelector: #methodWithGuard)
		equals: 0.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReadSelfInBlock [
	self
		assert: (self executeSelector: #readSelfInBlock)
		equals: receiver.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnBoolean [
	self
		assert: (self executeSelector: #returnBoolean)
		equals: false.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnEmptyLiteralArray [
	self
		assert: (self executeSelector: #returnEmptyLiteralArray)
		equals: #().
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnFloat [
	self
		assert: (self executeSelector: #returnFloat)
		equals: 3.14.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnGlobal [
	| globalObject |
	globalObject := Object new.
	interpreter globalEnvironmentAt: #Global put: globalObject.
	self 
		assert: (self executeSelector: #returnGlobal)
		equals: globalObject.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnInstanceVariableRead [
	receiver x: 100.
	self
		assert: (self executeSelector: #returnX)
		equals: 100.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnInteger [
	self
		assert: (self executeSelector: #returnInteger)
		equals: 5.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnRecursiveLiteralArray [
	self
		assert: (self executeSelector: #returnRecursiveLiteralArray)
		equals: #(true 1 #('ahah')).
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnResultOfBlockWithArgument [
	self
		assert: (self executeSelector: #returnResultOfBlockWithArgument)
		equals: #(2 4 6 8 10).
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnSelf [
	self
		assert: (self executeSelector: #returnSelf)
		== receiver.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testReturnSuper [
	self
		assert: (self executeSelector: #returnSuper)
		== receiver.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testSelfSend [
	receiver x: 100.
	self
		assert: (self executeSelector: #sendMessageReturnX)
		equals: 100.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testSmallIntAddPrimitive [
	self
		assert: (self executeSelector: #smallIntAdd)
		equals: 6.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testStore100intoX [
	receiver x: 17.
	self executeSelector: #store100intoX.
	self assert: receiver x equals: 100.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testUnassignedTempHasNilValue [
	self
		assert: (self executeSelector: #returnUnassignedTemp)
		equals: nil.
]

{ #category : #'tests - return' }
CHInterpreterTest >> testWriteTemporaryVariable [
	self
		assert: (self executeSelector: #writeTemporaryVariable)
		equals: 100.
]
