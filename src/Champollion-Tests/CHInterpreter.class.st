Class {
	#name : #CHInterpreter,
	#superclass : #Object,
	#instVars : [
		'stack',
		'globalScope',
		'primitives'
	],
	#category : #'Champollion-Tests'
}

{ #category : #accessing }
CHInterpreter >> argumentAt: anInteger [
	^ self tempAt: (self currentMethod arguments at: anInteger) name.
]

{ #category : #utility }
CHInterpreter >> assertSmallIntegerReceiverAndArgument [
	| receiver argument |
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	
	receiver := self receiver.
	receiver class = SmallInteger
		ifFalse: [ CHPrimitiveFail signal ].
		
	argument := self argumentAt: 1.
	argument class = SmallInteger
		ifFalse: [ CHPrimitiveFail signal ].
]

{ #category : #visiting }
CHInterpreter >> auxVisitMessageNode: aNode [

	| newReceiver method args lookupClass |
	newReceiver := self visitNode: aNode receiver.
	args := aNode arguments collect: [ :each | self visitNode: each ].
	lookupClass := aNode receiver isSuperVariable
		               ifTrue: [ self currentMethod methodClass superclass ]
		               ifFalse: [ newReceiver class ].
	method := self lookup: aNode selector fromClass: lookupClass.
	^ Dictionary newFrom: { 'method' -> method . 'receiver' -> newReceiver . 'args' -> args }
]

{ #category : #accessing }
CHInterpreter >> currentMethod [
	^ self tempAt: #___method.
]

{ #category : #accessing }
CHInterpreter >> currentScope [
	^ self topFrame.
]

{ #category : #visiting }
CHInterpreter >> execute: anAst [
	^ self
		execute: anAst
		withReceiver: nil
]

{ #category : #visiting }
CHInterpreter >> execute: anAst withReceiver: anObject [
	^ self
		execute: anAst
		withReceiver: anObject 
		andArguments: #().
]

{ #category : #visiting }
CHInterpreter >> execute: anAst withReceiver: anObject andArguments: aCollection [
	| result thisFrame |
	thisFrame := self pushNewFrame.
	self tempAt: #___method put: anAst.
	self tempAt: #self put: anObject.
	self topFrame parentScope: (CHInstanceScope new
		receiver: anObject;
		parentScope: globalScope;
		yourself).
	self topFrame receiver: anObject.
	anAst arguments
		with: aCollection
		do: [ :arg :value | self tempAt: arg name put: value].
	result := [ self visitNode: anAst ]
		on: CHReturn
		do: [ :return |
			return homeFrame = thisFrame
				ifTrue: [ return value ]
				ifFalse: [ return pass ] ].
	self popFrame.
	^ result
]

{ #category : #primitives }
CHInterpreter >> executePrimitiveMethod: anAst [
	| primitiveNumber |
	primitiveNumber := anAst pragmas
		detect: [ :each | each isPrimitive ]
		ifFound: [ :aPragmaPrivitive | aPragmaPrivitive arguments first value ]
		ifNone: [ self error: 'Not a primitive method' ].
	^ self perform: (primitives at: primitiveNumber).
]

{ #category : #setting }
CHInterpreter >> globalEnvironmentAt: aSymbol put: anObject [
	globalScope at: aSymbol put: anObject.
]

{ #category : #accessing }
CHInterpreter >> homeFrame [
	| currentLookupFrame |
	currentLookupFrame := self topFrame.
	[ currentLookupFrame includesKey: #__definingContext ]
		whileTrue: [ currentLookupFrame := currentLookupFrame read: #__definingContext ].
	^ currentLookupFrame
]

{ #category : #initialization }
CHInterpreter >> initialize [
	super initialize.
	globalScope := CHGlobalScope new.
	stack := CTStack new.
	primitives := Dictionary new.
	self initializePrimitiveTable.
]

{ #category : #initialization }
CHInterpreter >> initializePrimitiveTable [
	primitives at: 1	put: #primitiveSmallIntegerAdd.
	primitives at: 2	put: #primitiveSmallIntegerMinus.
	primitives at: 3	put: #primitiveSmallIntegerLessThan.
	primitives at: 4	put: #primitiveSmallIntegerGreaterThan.
	primitives at: 5	put: #primitiveSmallIntegerLessOrEqualsThan.
	primitives at: 6	put: #primitiveSmallIntegerGreaterOrEqualsThan.
	primitives at: 7	put: #primitiveSmallIntegerEqualsThan.
	primitives at: 8	put: #primitiveSmallIntegerNotEqualsThan.
	primitives at: 9	put: #primitiveSmallIntegerMultiply.
	primitives at: 10	put: #primitiveSmallIntegerDivide.
	primitives at: 11	put: #primitiveSmallIntegerModulo.
	primitives at: 12	put: #primitiveSmallIntegerEuclidianDivide.
	primitives at: 14	put: #primitiveSmallIntegerBitAnd.
	primitives at: 17	put: #primitiveSmallIntegerBitShift.
	primitives at: 60	put: #primitiveAt.
	primitives at: 61	put: #primitiveAtPut.
	primitives at: 62	put: #primitiveSize.
	primitives at: 63	put: #primitiveAt.
	primitives at: 64	put: #primitiveAtPut.
	primitives at: 70	put: #primitiveBasicNew.
	primitives at: 71	put: #primitiveBasicNewVariable.
	primitives at: 105	put: #primitiveReplaceFromToWithStartingAt.
	primitives at: 110	put: #primitiveIdentical.
	primitives at: 111	put: #primitiveClass.
	primitives at: 163	put: #primitiveIsReadOnlyObject.
	primitives at: 170	put: #primitiveValue.
	primitives at: 171	put: #primitiveAsInteger.
	primitives at: 175	put: #primitiveBasicIdentityHash.
	primitives at: 201	put: #primitiveBlockValue.
	primitives at: 207	put: #primitiveBlockValue.
	primitives at: 'primitiveStringHash' put: #primitiveStringHash
]

{ #category : #accessing }
CHInterpreter >> lookup: aSelector fromClass: aClass [
	| class |
	class := (aClass == CHBlock)
		ifTrue: [ FullBlockClosure ]
		ifFalse: [ aClass ].
	(aClass includesSelector: aSelector)
		ifTrue: [ ^ class compiledMethodAt: aSelector].
	aClass superclass
		ifNil: [ ^ nil ]
		ifNotNil: [ ^ self lookup: aSelector fromClass: class superclass ]
]

{ #category : #accessing }
CHInterpreter >> lookupFrameDefiningTemporary: aName [
	| currentLookupFrame |
	currentLookupFrame := self topFrame.
	[ currentLookupFrame includesKey: aName ]
		whileFalse: [ currentLookupFrame := currentLookupFrame read: #__definingContext ].
	^ currentLookupFrame
]

{ #category : #accessing }
CHInterpreter >> numberOfArguments [
	^ self currentMethod arguments size
]

{ #category : #setting }
CHInterpreter >> popFrame [
	stack pop.
]

{ #category : #primitives }
CHInterpreter >> primitiveAsInteger [
	^ self receiver asInteger
]

{ #category : #primitives }
CHInterpreter >> primitiveAt [
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	self receiver class classLayout isVariable
		ifFalse: [ CHPrimitiveFail signal ].
	((self argumentAt: 1) isKindOf: SmallInteger)
		ifFalse: [ CHPrimitiveFail signal ].
	self receiver size < (self argumentAt: 1)
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver at: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveAtPut [
	self numberOfArguments < 2
		ifTrue: [ CHPrimitiveFail signal ].
	self receiver class classLayout isVariable
		ifFalse: [ CHPrimitiveFail signal ].
	((self argumentAt: 1) isKindOf: SmallInteger)
		ifFalse: [ CHPrimitiveFail signal ].
	self receiver size <= (self argumentAt: 1)
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver at: (self argumentAt: 1) put: (self argumentAt: 2).
]

{ #category : #primitives }
CHInterpreter >> primitiveBasicIdentityHash [
	^ self receiver basicIdentityHash
]

{ #category : #primitives }
CHInterpreter >> primitiveBasicNew [
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	^ (self receiver) basicNew: (self argumentAt: 1)
]

{ #category : #primitives }
CHInterpreter >> primitiveBasicNewVariable [
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	self receiver isClass
		ifFalse: [ CHPrimitiveFail signal ].
	self receiver classLayout isVariable
		ifFalse: [ CHPrimitiveFail signal ].
	((self argumentAt: 1) isKindOf: SmallInteger)
		ifFalse: [ CHPrimitiveFail signal ].
	^ self receiver basicNew: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveBlockValue [
	| sequenceNode theBlock |
	theBlock := self receiver.
	sequenceNode := theBlock code body.
	self receiver: (theBlock definingContext read: #self).
	self tempAt: #__definingContext put: theBlock definingContext. 
	sequenceNode temporaryNames do: [ :e | self tempAt: e put: nil ].
	^ self visitNode: sequenceNode.
]

{ #category : #primitives }
CHInterpreter >> primitiveClass [
	^ self receiver class
]

{ #category : #primitives }
CHInterpreter >> primitiveIdentical [ 
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	^ (self receiver) == (self argumentAt: 1)
]

{ #category : #primitives }
CHInterpreter >> primitiveIsReadOnlyObject [
	^ self receiver isReadOnlyObject
]

{ #category : #primitives }
CHInterpreter >> primitiveReplaceFromToWithStartingAt [
	^ self receiver 
		replaceFrom: (self argumentAt: 1)
		to: (self argumentAt: 2)
		with: (self argumentAt: 3)
		startingAt: (self argumentAt: 4)
]

{ #category : #primitives }
CHInterpreter >> primitiveSize [
	self receiver class classLayout isVariable
		ifFalse: [ CHPrimitiveFail signal ].
	^ self receiver basicSize
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerAdd [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) + (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerBitAnd [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) bitAnd: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerBitShift [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) bitShift: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerDivide [
	| argument |
	argument := self argumentAt: 1.
	(argument class = SmallInteger and: (argument ~= 0))
		ifFalse: [ CHPrimitiveFail signal ].
	
	^ (self receiver) / argument
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerEqualsThan [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) = (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerEuclidianDivide [
	| argument |
	argument := self argumentAt: 1.
	(argument class = SmallInteger and: (argument ~= 0))
		ifFalse: [ CHPrimitiveFail signal ].
	
	^ (self receiver) // argument
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerGreaterOrEqualsThan [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) >= (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerGreaterThan [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) > (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerLessOrEqualsThan [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) <= (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerLessThan [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) < (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerMinus [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) - (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerModulo [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) \\ (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerMultiply [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) * (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerNotEqualsThan [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) ~= (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveStringAt [
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	self receiver class classLayout isBytes
		ifFalse: [ CHPrimitiveFail signal ].
	((self argumentAt: 1) isKindOf: SmallInteger)
		ifFalse: [ CHPrimitiveFail signal ].
	self receiver size < (self argumentAt: 1)
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver at: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveStringHash [
	self numberOfArguments < 2
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver 
		stringHash: (self argumentAt: 1)
		initialHash: (self argumentAt: 2)
]

{ #category : #primitives }
CHInterpreter >> primitiveValue [
	^ self receiver value: (self argumentAt: 1)
]

{ #category : #setting }
CHInterpreter >> pushNewFrame [
	| newTop |
	newTop := CHMethodScope new.
	stack ifNotEmpty: [ newTop previousScope: self topFrame ].
	stack push: newTop.
	^ newTop.
]

{ #category : #accessing }
CHInterpreter >> receiver [
	^ self topFrame receiver.
]

{ #category : #accessing }
CHInterpreter >> receiver: aValue [
	self topFrame receiver: aValue
]

{ #category : #accessing }
CHInterpreter >> scopeDefining: aName [
	^ [ self currentScope scopeDefining: aName ]
		on: Exception
		do: [ :exc |
			self homeFrame scopeDefining: aName ]
]

{ #category : #accessing }
CHInterpreter >> tempAt: aKey [
	^ self topFrame read: aKey.
]

{ #category : #visiting }
CHInterpreter >> tempAt: aSymbol put: anObject [
	self topFrame write: aSymbol withValue: anObject.
]

{ #category : #accessing }
CHInterpreter >> topFrame [
	^ stack top
]

{ #category : #visiting }
CHInterpreter >> visitArgumentVariableNode: aNode [
	^ self topFrame read: aNode name. 
]

{ #category : #visiting }
CHInterpreter >> visitArrayNode: aNode [
	^ aNode statements
		collect: [ :each | self visitNode: each ] as: Array.
]

{ #category : #visiting }
CHInterpreter >> visitAssignmentNode: aNode [
	| value |
	value := (self visitNode: aNode value).
	aNode variable variable isTempVariable
		ifTrue: [ | definingFrame |
			definingFrame := self lookupFrameDefiningTemporary: aNode variable name.
			definingFrame write: aNode variable name withValue: value ]
		ifFalse: [ aNode variable variable write: value to: self receiver ].
	^ value.
]

{ #category : #visiting }
CHInterpreter >> visitBlockNode: aNode [
	^ CHBlock new
		code: aNode;
		definingContext: self topFrame;
		yourself.
]

{ #category : #visiting }
CHInterpreter >> visitClassVariableNode: aNode [
	| lookupClass |
	lookupClass := self receiver isClass
		ifTrue: [ self receiver ] 
		ifFalse: [ self receiver class ].
	[ lookupClass classPool includesKey: aNode name ] whileFalse: 
		[ lookupClass := lookupClass superclass ].
	^ lookupClass classPool at: aNode name
]

{ #category : #visiting }
CHInterpreter >> visitGlobalVariableNode: aNode [
	^ globalScope
		at: aNode name
		ifAbsent: [ self error: aNode name, 'not found' ]
]

{ #category : #visiting }
CHInterpreter >> visitInstanceVariableNode: aNode [
	^ (self scopeDefining: aNode name) read: aNode name.
]

{ #category : #visiting }
CHInterpreter >> visitLiteralArrayNode: aNode [
	^ aNode contents
		collect: [ :each | self visitNode: each ]
		as: Array.
]

{ #category : #visiting }
CHInterpreter >> visitLiteralValueNode: aNode [
	^ aNode value.
]

{ #category : #visiting }
CHInterpreter >> visitMessageNode: aNode [
	| dict |
	dict := self auxVisitMessageNode: aNode.
	^ self 
		execute: ((dict at: 'method') ast)
		withReceiver: (dict at: 'receiver')
		andArguments: (dict at: 'args').
]

{ #category : #visiting }
CHInterpreter >> visitMethodNode: aNode [
	[ aNode isPrimitive ifTrue: [ 
		^ self executePrimitiveMethod: aNode ]]
		on: CHPrimitiveFail do: [ :err | ].
	^ self visitNode: aNode body.
]

{ #category : #visiting }
CHInterpreter >> visitNode: aNode [
	^ aNode acceptVisitor: self.
]

{ #category : #visiting }
CHInterpreter >> visitReturnNode: aNode [
	CHReturn new
		value: (self visitNode: aNode value);
		homeFrame: self homeFrame;
		signal 
]

{ #category : #visiting }
CHInterpreter >> visitSelfNode: aNode [
	^ self homeFrame receiver.
]

{ #category : #visiting }
CHInterpreter >> visitSequenceNode: aNode [
	(aNode statements size = 0)
		ifTrue: [ ^ self homeFrame receiver ].
	aNode temporaryNames
		do: [ :each | self tempAt: each put: nil ].
	aNode statements allButLast
		do: [ :each | self visitNode: each ].
	^ self visitNode: aNode statements last.
]

{ #category : #visiting }
CHInterpreter >> visitSuperNode: aNode [
	^ self homeFrame receiver.
]

{ #category : #visiting }
CHInterpreter >> visitTemporaryVariableNode: aNode [
	| definingFrame |
	definingFrame := self lookupFrameDefiningTemporary: aNode name.
	^ definingFrame read: aNode name.
]
