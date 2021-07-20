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
		'stacks',
		'stacksDict'
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
	stacks add: ( TimedContext newFrom: (thisContext stack collect: [ :each | each copy ]) ).
	
	count > 1 ifTrue: [ ^ self ].
	proxy literalsEvenTheOnesInTheInnerBlocks
		select: [ :literal | literal isSymbol ]
		thenDo: [ :potentialSelector | self instrumentImplementorsOf: potentialSelector ]
]

{ #category : #converting }
MpProfilingHandler >> convertStacks [
	"Return the stacks with only the relevent methods to determine "
	| topMethod |
	topMethod := proxy methodClass >> proxy selector.
	stacks do: [ :stack | 
		stacksDict at: stack put: stack context copy.
		stack convertContextWithTopMethod: topMethod ].
	^ stacksDict associationsSelect: [ :each | each key context isNotNil ].
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
	stacksDict := Dictionary new.
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
