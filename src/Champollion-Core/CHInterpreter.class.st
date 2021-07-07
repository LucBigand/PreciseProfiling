Class {
	#name : #CHInterpreter,
	#superclass : #Object,
	#instVars : [
		'stack',
		'globalScope',
		'primitives'
	],
	#category : #'Champollion-Core'
}

{ #category : #accessing }
CHInterpreter >> argumentAt: anInteger [
	^ self tempAt: (self currentMethod arguments at: anInteger) name.
]

{ #category : #utility }
CHInterpreter >> assertFloatArgument [
	| argument |
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
		
	argument := self argumentAt: 1.
	argument class = Float
		ifFalse: [ CHPrimitiveFail signal ].
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
	^ Dictionary newFrom: { #method -> method . #receiver -> newReceiver . #args -> args }
]

{ #category : #utility }
CHInterpreter >> class: aSubclass isDescendentOf: aClass [
	| currentClass |
	aSubclass isClass ifFalse: [ ^ false ].
	currentClass := aSubclass.
	[ currentClass isNotNil ] whileTrue: [ 
		currentClass  == aClass ifTrue: [ ^ true ].
		currentClass := currentClass superclass ].
	^ false
]

{ #category : #accessing }
CHInterpreter >> currentMethod [
	| method |
	method := self tempAt: #___method.
	(method methodClass == FullBlockClosure)
		ifTrue: [ ^ self homeFrame read: #___method ]
		ifFalse: [ ^ method ]
	"^ self homeFrame read: #___method."	
	"^ self tempAt: #___method."
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
	| result thisFrame stackSize |
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
	stackSize := stack size. "Used for tests"
	result := [ self visitNode: anAst ]
		on: CHReturn
		do: [ :return |
			return homeFrame = thisFrame
				ifTrue: [ return value ]
				ifFalse: [ 
					self popFrame.
					return pass ] ].
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
	primitives 
		at: 1	put: #primitiveSmallIntegerAdd;
		at: 2	put: #primitiveSmallIntegerMinus;
		at: 3	put: #primitiveSmallIntegerLessThan;
		at: 4	put: #primitiveSmallIntegerGreaterThan;
		at: 5	put: #primitiveSmallIntegerLessOrEqualsThan;
		at: 6	put: #primitiveSmallIntegerGreaterOrEqualsThan;
		at: 7	put: #primitiveSmallIntegerEqualsThan;
		at: 8	put: #primitiveSmallIntegerNotEqualsThan;
		at: 9	put: #primitiveSmallIntegerMultiply;
		at: 10	put: #primitiveSmallIntegerDivide;
		at: 11	put: #primitiveSmallIntegerModulo;
		at: 12	put: #primitiveSmallIntegerEuclidianDivide;
		at: 13	put: #primitiveSmallIntegerQuo;
		at: 14	put: #primitiveSmallIntegerBitAnd;
		at: 17	put: #primitiveSmallIntegerBitShift;
		at: 18	put: #primitiveSmallIntegerPoint;
		at: 29	put: #primitiveSmallIntegerMultiply;
		at: 40	put: #primitiveAsFloat;
		at: 60	put: #primitiveAt;
		at: 61	put: #primitiveAtPut;
		at: 62	put: #primitiveSize;
		at: 63	put: #primitiveAt;
		at: 64	put: #primitiveAtPut;
		at: 70	put: #primitiveBasicNew;
		at: 71	put: #primitiveBasicNewVariable;
		at: 75	put: #primitiveBasicIdentityHash;
		at: 83	put: #primitivePerformWith;
		at: 84	put: #primitivePerformWithArguments;
		at: 105	put: #primitiveReplaceFromToWithStartingAt;
		at: 110	put: #primitiveIdentical;
		at: 111	put: #primitiveClass;
		at: 148	put: #primitiveShallowCopy;
		at: 159	put: #primitiveHashMultiply;
		at: 163	put: #primitiveIsReadOnlyObject;
		at: 169	put: #primitiveDifferent;
		at: 170	put: #primitiveValue;
		at: 171	put: #primitiveAsInteger;
		at: 175	put: #primitiveBasicIdentityHash;
		at: 199	put: #primitiveBlockOnDo;
		at: 201	put: #primitiveBlockValue;
		at: 202	put: #primitiveBlockValueWithArg;
		at: 207	put: #primitiveBlockValue;
		at: 541	put: #primitiveFloatAdd;
		at: 542	put: #primitiveFloatMinus;
		at: 547	put: #primitiveFloatEqualsThan;
		at: 549	put: #primitiveFloatMultiply;
		at: 550	put: #primitiveFloatDivide;
		at: 554	put: #primitiveTimesTwoPower;
		at: 'primDigitBitShiftMagnitude' put: #primitiveDigitBitShiftMagnitude;
		at: 'primDigitMultiplyNegative' put: #primitiveDigitMultiplyNegative;
		at: 'primitiveCompareString' put: #primitiveCompareString ;
		at: 'primitiveFindSubstring' put: #primitiveFindSubstring;
		at: 'primitiveIndexOfAsciiInString' put: #primitiveIndexOfAsciiInString ;
		at: 'primitiveStringHash' put: #primitiveStringHash
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
CHInterpreter >> primitiveAsFloat [
	^ self receiver asFloat
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
	self receiver basicSize < (self argumentAt: 1)
		ifTrue: [ CHPrimitiveFail signal ].
	[ ^ self receiver at: (self argumentAt: 1) ]
		on: Exception do: [ ^ self receiver basicAt: (self argumentAt: 1) ].
]

{ #category : #primitives }
CHInterpreter >> primitiveAtPut [
	self numberOfArguments < 2
		ifTrue: [ CHPrimitiveFail signal ].
	self receiver class classLayout isVariable
		ifFalse: [ CHPrimitiveFail signal ].
	((self argumentAt: 1) isKindOf: SmallInteger)
		ifFalse: [ CHPrimitiveFail signal ].
	self receiver basicSize < (self argumentAt: 1)
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver at: (self argumentAt: 1) put: (self argumentAt: 2).
]

{ #category : #primitives }
CHInterpreter >> primitiveBasicIdentityHash [
	^ self receiver basicIdentityHash
]

{ #category : #primitives }
CHInterpreter >> primitiveBasicNew [
	^ self receiver basicNew
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
CHInterpreter >> primitiveBlockOnDo [
	"Work in progress"
	| exception alternativeBlock currentFrame |
	exception := (self argumentAt: 1).
	alternativeBlock := (self argumentAt: 2).
	currentFrame := self topFrame.
	[ ^ self primitiveBlockValue ]
		on: exception
		do: [ 
			[ self topFrame == currentFrame ] whileFalse: [ self popFrame ].
			self receiver: alternativeBlock.
			^ self primitiveBlockValue ]
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
CHInterpreter >> primitiveBlockValueWithArg [
	| sequenceNode theBlock |
	theBlock := self receiver.
	sequenceNode := theBlock code body.
	self receiver: (theBlock definingContext read: #self).
	self tempAt: #__definingContext put: theBlock definingContext. 
	sequenceNode temporaryNames do: [ :e | self tempAt: e put: nil ].
	self tempAt: (theBlock code arguments at: 1) name put: (self argumentAt: 1).
	^ self visitNode: sequenceNode.
]

{ #category : #primitives }
CHInterpreter >> primitiveClass [
	^ self receiver class
]

{ #category : #primitives }
CHInterpreter >> primitiveCompareString [
	self numberOfArguments < 3
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver 
		compare: (self argumentAt: 1)
		with: (self argumentAt: 2) 
		collated: (self argumentAt: 3).
]

{ #category : #primitives }
CHInterpreter >> primitiveDifferent [
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	^ (self receiver) ~~ (self argumentAt: 1)
]

{ #category : #primitives }
CHInterpreter >> primitiveDigitBitShiftMagnitude [
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver bitShiftMagnitude: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveDigitMultiplyNegative [
	self numberOfArguments < 2
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver
		digitMultiply: (self argumentAt: 1)
		neg: (self argumentAt: 2).
]

{ #category : #primitives }
CHInterpreter >> primitiveFindSubstring [
	self numberOfArguments < 4
		ifTrue: [ CHPrimitiveFail signal ].
	self receiver
		findSubstringViaPrimitive: (self argumentAt: 1)
		in: (self argumentAt: 2) 
		startingAt: (self argumentAt: 3)
		matchTable: (self argumentAt: 4)
]

{ #category : #primitives }
CHInterpreter >> primitiveFloatAdd [
	self assertFloatArgument.
	^ (self receiver) + (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveFloatDivide [
	self assertFloatArgument.
	^ (self receiver) / (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveFloatEqualsThan [
	self assertFloatArgument.
	^ (self receiver) = (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveFloatMinus [
	self assertFloatArgument.
	^ (self receiver) - (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveFloatMultiply [
	self assertFloatArgument.
	^ (self receiver) * (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveHashMultiply [
	^ self receiver hashMultiply
]

{ #category : #primitives }
CHInterpreter >> primitiveIdentical [ 
	self numberOfArguments < 1
		ifTrue: [ CHPrimitiveFail signal ].
	^ (self receiver) == (self argumentAt: 1)
]

{ #category : #primitives }
CHInterpreter >> primitiveIndexOfAsciiInString [
	self numberOfArguments < 3
		ifTrue: [ CHPrimitiveFail signal ].
	^ self receiver
		indexOfAscii: (self argumentAt: 1) 
		inString: (self argumentAt: 2) 
		startingAt: (self argumentAt: 3)
]

{ #category : #primitives }
CHInterpreter >> primitiveIsReadOnlyObject [
	^ self receiver isReadOnlyObject
]

{ #category : #primitives }
CHInterpreter >> primitivePerformWith [
	self numberOfArguments < 2
		ifTrue: [ CHPrimitiveFail signal ].
	^ self 
		execute: (self lookup: (self argumentAt: 1) fromClass: self receiver class ) ast
		withReceiver: self receiver
		andArguments: { self argumentAt: 2 }
]

{ #category : #primitives }
CHInterpreter >> primitivePerformWithArguments [
	self numberOfArguments < 2
		ifTrue: [ CHPrimitiveFail signal ].
	^ self 
		execute: (self lookup: (self argumentAt: 1) fromClass: self receiver class ) ast
		withReceiver: self receiver
		andArguments: ( self argumentAt: 2 )
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
CHInterpreter >> primitiveShallowCopy [
	^ self receiver shallowCopy
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
CHInterpreter >> primitiveSmallIntegerPoint [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) @ (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveSmallIntegerQuo [
	self assertSmallIntegerReceiverAndArgument.
	^ (self receiver) quo: (self argumentAt: 1).
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
CHInterpreter >> primitiveTimesTwoPower [
	^ (self receiver) timesTwoPower: (self argumentAt: 1).
]

{ #category : #primitives }
CHInterpreter >> primitiveValue [
	^ self receiver value: (self argumentAt: 1)
]

{ #category : #setting }
CHInterpreter >> pushNewFrame [
	| newTop |
	newTop := CHMethodScope new.
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
	^ self visitTempOrArgVariableNode: aNode
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
		ifFalse: [ [ aNode variable variable write: value to: self receiver ]
			on: Exception do: [ self tempAt: aNode variable name put: value ] ].
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
CHInterpreter >> visitCascadeMessage: aMessageNode withReceiver: anObject [
	| ast args |
	ast := (self lookup: aMessageNode selector fromClass: anObject class) ast.
	args := aMessageNode arguments collect: [ :argNode | self visitNode: argNode ].
	^ self execute: ast withReceiver: anObject andArguments: args.
]

{ #category : #visiting }
CHInterpreter >> visitCascadeNode: aNode [
	| receiver |
	receiver := self visitNode: (aNode messages at: 1).
	aNode messages allButLast do: [ :each |
		self visitCascadeMessage: each withReceiver: receiver ].
	^ self visitCascadeMessage: aNode messages last withReceiver: receiver
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
		execute: ((dict at: #method) ast)
		withReceiver: (dict at: #receiver)
		andArguments: (dict at: #args).
]

{ #category : #visiting }
CHInterpreter >> visitMethodNode: aNode [
	[ aNode isPrimitive ifTrue: [ 
		^ self executePrimitiveMethod: aNode ]]
		on: CHPrimitiveFail do: [ :err | ].
	"aNode isPrimitive ifTrue: [ self halt ]."
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
	| res |
	(aNode statements isEmpty)
		ifTrue: [ ^ self homeFrame receiver ].
	aNode temporaryNames
		do: [ :each | self tempAt: each put: nil ].
	aNode statements allButLast
		do: [ :each | self visitNode: each ].
	res := self visitNode: aNode statements last.
	(aNode statements last isReturn not and: aNode parent isMethod)
		ifTrue: [ ^ self receiver  ]
		ifFalse: [ ^ res ]
]

{ #category : #visiting }
CHInterpreter >> visitSuperNode: aNode [
	^ self homeFrame receiver.
]

{ #category : #visiting }
CHInterpreter >> visitTempOrArgVariableNode: aNode [
	| definingFrame |
	definingFrame := self lookupFrameDefiningTemporary: aNode name.
	^ definingFrame read: aNode name.
]

{ #category : #visiting }
CHInterpreter >> visitTemporaryVariableNode: aNode [
	^ self visitTempOrArgVariableNode: aNode
]

{ #category : #visiting }
CHInterpreter >> visitThisContextNode: aNode [
	^ thisContext
]
