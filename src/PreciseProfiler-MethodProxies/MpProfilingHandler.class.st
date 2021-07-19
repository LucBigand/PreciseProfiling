"
I'm a more advanced proxy that propagates itself during execution.
When a proxy is executed, before letting the execution runs, it installs itself on all the implementators of the methods used in the method.

```
testCase := StringTest selector: #testAsCamelCase.
(MpMethodProxy onMethod: testCase testMethod handler: MpProfilingHandler) install.
testCase run.

proxies := MpMethodProxy allInstances.
proxies do: #uninstall.
```
"
Class {
	#name : #MpProfilingHandler,
	#superclass : #MpHandler,
	#instVars : [
		'count',
		'stacks'
	],
	#classVars : [
		'StackLoopLength'
	],
	#category : #'PreciseProfiler-MethodProxies'
}

{ #category : #'class initialization' }
MpProfilingHandler class >> initialize [
	StackLoopLength := 7
]

{ #category : #evaluating }
MpProfilingHandler >> beforeMethod [

	self count: self count + 1.
	
	"Only do instrumentation once"
	stacks add: ( thisContext stack collect: [ :each | each copy ] ).
	
	count > 1 ifTrue: [ ^ self ].
	proxy literalsEvenTheOnesInTheInnerBlocks
		select: [ :literal | literal isSymbol ]
		thenDo: [ :potentialSelector | self instrumentImplementorsOf: potentialSelector ]
]

{ #category : #converting }
MpProfilingHandler >> convertStacks [
	"Return the stacks with only the relevent methods to determine "
	| res topMethod |
	self haltIf: [ proxy ~= proxy handler proxy ].
	topMethod := proxy methodClass >> proxy selector.
	res := stacks collect: [ :stack | | convertedStack |
		convertedStack := OrderedCollection new.
		convertedStack add: topMethod.
		StackLoopLength to: stack size by: StackLoopLength do: [ :i |
			convertedStack add: (stack at: i) method ].
		(convertedStack anySatisfy: [ :each | each isDoIt or: each isCompiledBlock ])
			ifTrue: [ | i |
				i := 1.
				[ ((convertedStack at: i) isDoIt or: (convertedStack at: i) isCompiledBlock) ]
					whileFalse: [ i := i + 1 ].
				[ convertedStack size >= i ] whileTrue: [ convertedStack removeLast ] ]
			ifFalse: [ convertedStack := nil ].
		convertedStack -> stack ].
	^ res reject: [ :stack | stack key isNil ].
]

{ #category : #accessing }
MpProfilingHandler >> count [

	^ count
]

{ #category : #accessing }
MpProfilingHandler >> count: anInteger [

	count := anInteger
]

{ #category : #initialization }
MpProfilingHandler >> initialize [

	super initialize.
	count := 0.
	stacks := Set new.
]

{ #category : #evaluating }
MpProfilingHandler >> instrumentImplementorsOf: potentialSelector [
	potentialSelector implementors
		select: [ :method | method class == CompiledMethod ] 
		thenDo: [ :method | | newProxy |
			newProxy := MpMethodProxy onMethod: method handler: self class new.
			newProxy ifNotNil: [ newProxy install ].
		]
]

{ #category : #accessing }
MpProfilingHandler >> proxy [

	^ proxy
]

{ #category : #accessing }
MpProfilingHandler >> stacks [
	^ stacks
]
