Class {
	#name : #CHInterpretable,
	#superclass : #CHInterpretableSuperclass,
	#instVars : [
		'x',
		'collaborator',
		'current',
		'evaluationOrder'
	],
	#category : #'Champollion-Tests'
}

{ #category : #setting }
CHInterpretable >> addToX: anInteger [
	x := x + anInteger
]

{ #category : #'error signalling' }
CHInterpretable >> blockOnDoWithError [
	| res |
	[ res := 0. self errorSignal ] on: Error do: [ res := 1 ].
	^ res
]

{ #category : #'error signalling' }
CHInterpretable >> blockOnDoWithNoError [
	| res |
	[ res := 0 ] on: Error do: [ res := 1 ].
	^ res
]

{ #category : #return }
CHInterpretable >> callingFailingPrimitive [
	^ self failingPrimitive
]

{ #category : #return }
CHInterpretable >> cascadeMessage [
	^ self store100intoX;
		addToX: 200;
		x.
]

{ #category : #setting }
CHInterpretable >> changeCollaboratorWithArgument [
	collaborator x: 500.
]

{ #category : #accessing }
CHInterpretable >> changeCollaboratorX [
	collaborator store100intoX.
]

{ #category : #accessing }
CHInterpretable >> collaborator [
	^ collaborator
]

{ #category : #setting }
CHInterpretable >> collaborator: anObject [
	collaborator := anObject.
]

{ #category : #return }
CHInterpretable >> doesSuperLookupFromSuperclass [
	^ super isInSuperclass.
]

{ #category : #'error signalling' }
CHInterpretable >> errorSignal [
	Error signal
]

{ #category : #accessing }
CHInterpretable >> evaluateReceiver [
	evaluationOrder := self next.
	^ self.
]

{ #category : #accessing }
CHInterpretable >> evaluationOrder [
	^ evaluationOrder.
]

{ #category : #return }
CHInterpretable >> failingPrimitive [
	<primitive: 1>
	^ 'failure'.
]

{ #category : #return }
CHInterpretable >> increaseEnclosingTemporary [
	| temp |
	temp := 0.
	[ temp := temp + 1 ] value.
	^ temp
]

{ #category : #initialization }
CHInterpretable >> initialize [
	super initialize.
	current := #().
]

{ #category : #return }
CHInterpretable >> isInSuperclass [
	^ false.
]

{ #category : #return }
CHInterpretable >> lastExpression [
	| tmp |
	tmp := 1.
	tmp := true ifTrue: [
		tmp := 42.
		tmp := tmp + 1. ].
	^ tmp
]

{ #category : #return }
CHInterpretable >> messageArg1: arg1 arg2: arg2 arg3: arg3 [
	^ { arg1 . arg2 . arg3 }.
]

{ #category : #return }
CHInterpretable >> methodWithGuard [
	true ifTrue: [ ^ 0 ].
	^ 1.
]

{ #category : #accessing }
CHInterpretable >> next [
	| next |
	next := current.
	current := { current }.
	^ next.
]

{ #category : #display }
CHInterpretable >> openRoassalCanvas [

	| canvas scale r aNumber circle label composite |
	canvas := RSCanvas new.
	scale := NSScale category20c.

	r := Random seed: 42.
	81 timesRepeat: [ 
		aNumber := r nextInteger: 10.
		circle := RSCircle new
			          size: 30;
			          color: (scale scale: aNumber).
		label := RSLabel new
			         color: Color black;
			         text: aNumber.
		composite := { 
			             circle.
			             label } asGroup asShapeFor: aNumber.
		canvas add: composite ].

	RSGridLayout new
		lineItemsCount: 9;
		on: canvas nodes.

	canvas @ RSCanvasController.
	canvas open.
	canvas close.
]

{ #category : #return }
CHInterpretable >> overridenMethod [
	^ super overridenMethod
]

{ #category : #return }
CHInterpretable >> readSelfInBlock [
	^ [ self ] value
]

{ #category : #return }
CHInterpretable >> redefinedMethod [
	^ super redefinedMethod.
]

{ #category : #return }
CHInterpretable >> returnBlockValue [
	^ [ 1 . 5 ] value
]

{ #category : #return }
CHInterpretable >> returnBlockValueWithTemporaries [
	^ [ | a b |
		a := 1.
		b := 2.
		a + b ] value
]

{ #category : #return }
CHInterpretable >> returnBoolean [
	^ false
]

{ #category : #return }
CHInterpretable >> returnEmptyLiteralArray [
	^ #().
]

{ #category : #return }
CHInterpretable >> returnEvaluationOrder [
	^ self evaluateReceiver
		messageArg1: self next
		arg2: self next 
		arg3: self next.
]

{ #category : #return }
CHInterpretable >> returnFloat [
	^ 3.14
]

{ #category : #return }
CHInterpretable >> returnGlobal [
	^ Global
]

{ #category : #return }
CHInterpretable >> returnInteger [
	^ 5
]

{ #category : #return }
CHInterpretable >> returnRecursiveLiteralArray [
	^ #(true 1 #('ahah'))
]

{ #category : #return }
CHInterpretable >> returnResultOfBlockWithArgument [
	^ #(1 2 3 4 5) collect: [ :each | 2 * each ]
]

{ #category : #return }
CHInterpretable >> returnResultOfNestedBlocksWithArgument [
	^ #( 1 2 3 ) collect: [ :x1 | (x1 to: (x1 + 2)) collect: [ :x2 | 2 * x2] ]
]

{ #category : #return }
CHInterpretable >> returnSelf [
	^ self
]

{ #category : #return }
CHInterpretable >> returnSuper [
	^ super
]

{ #category : #return }
CHInterpretable >> returnUnassignedTemp [
	| temp |
	^ temp
]

{ #category : #return }
CHInterpretable >> returnX [
	^ x
]

{ #category : #return }
CHInterpretable >> sendMessageInSuperclass [
	^ self methodInSuperclass.
]

{ #category : #return }
CHInterpretable >> sendMessageReturnX [
	^ self returnX.
]

{ #category : #return }
CHInterpretable >> setXAndMessage [
	x := 1000.
	collaborator returnX.
	^ x.
]

{ #category : #return }
CHInterpretable >> smallIntAdd [
	^ 1 + 5
]

{ #category : #setting }
CHInterpretable >> store100intoX [
	x := 100.
]

{ #category : #return }
CHInterpretable >> writeTemporaryVariable [
	| temp |
	temp := 100.
	^ temp.
]

{ #category : #setting }
CHInterpretable >> x [
	^ x
]

{ #category : #setting }
CHInterpretable >> x: anInteger [
	x := anInteger
]
