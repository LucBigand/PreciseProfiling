Class {
	#name : #PreciseInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'interpreter'
	],
	#category : #PreciseProfiler
}

{ #category : #setup }
PreciseInterpreterTest >> setUp [
	super setUp.
	interpreter := PreciseInterpreter new.
	
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteBiggerExponentiation [
	self
		assert: (interpreter runOn: 5 method: #** andArguments: #(300))
		equals: (5 ** 300).
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteCHInterpretableLastExpression [
	self
		assert: (interpreter runOn: (CHInterpretable new) method: #lastExpression andArguments: #() )
		equals: 43.
	self
		assert: (interpreter methodList) 
		= (Dictionary newFrom: { 
			'Object allocation' -> 4 .
			CHInterpretable>>#lastExpression -> 1 .
			True>>#ifTrue: -> 1 .
			FullBlockClosure>>#value -> 1 .
			SmallInteger>>#+ -> 1}).
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteExponentiation [
	self
		assert: (interpreter runOn: 5 method: #** andArguments: #(3))
		equals: 125.
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteFactorial1 [
	self
		assert: (interpreter runOn: 1 method: #factorial)
		equals: 1.
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteFactorial5 [
	self
		assert: (interpreter runOn: 5 method: #factorial)
		equals: 120.
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteJavadoc [
	self
		assert: ((interpreter
			runOn: Javadoc 
			method: #runOnPackage: 
			andArguments: { SmallInteger package })
				beginsWith: 'Package : Kernel')
]

{ #category : #test }
PreciseInterpreterTest >> testInterpreteSmallIntegerAddition [
	self
		assert: (interpreter runOn: 3 method: #+ andArguments: #(5) )
		equals: 8.
	self
		assert: (interpreter methodList) 
		= (Dictionary newFrom: { 
			SmallInteger>>#+ -> 1})
]
