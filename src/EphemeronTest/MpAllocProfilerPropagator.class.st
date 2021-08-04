Class {
	#name : #MpAllocProfilerPropagator,
	#superclass : #MpHandler,
	#instVars : [
		'executed',
		'profiler'
	],
	#category : #EphemeronTest
}

{ #category : #evaluating }
MpAllocProfilerPropagator >> beforeMethod [
	| literals |
	executed ifTrue: [ ^ self ].
	profiler ifNil: [ self initializeProfiler ].
	literals := proxy literalsEvenTheOnesInTheInnerBlocks.
	literals
		select: [ :literal | literal isSymbol ]
		thenDo: [ :potentialSelector | self instrumentImplementorsOf: potentialSelector ].
	(literals
		select: [ :literal | (literal class == GlobalVariable) and: [ literal value isClass ] ]
		thenCollect: [ :var | var value ])
		do: [ :class | profiler addClass: class  ].
	executed := true
]

{ #category : #initialization }
MpAllocProfilerPropagator >> initialize [
	super initialize.
	executed := false
]

{ #category : #setting }
MpAllocProfilerPropagator >> initializeProfiler [
	profiler := MpAllocProfilerByEphemeronHandler new.
]

{ #category : #evaluating }
MpAllocProfilerPropagator >> instrumentImplementorsOf: potentialSelector [
	"Add a MpProfilingHandler to the methods that could potentially be called by this method."
	potentialSelector implementors
		select: [ :method | method class == CompiledMethod ] 
		thenDo: [ :method | | newProxy newHandler |
			newHandler := self class new
				profiler: profiler;
				yourself.
			newProxy := MpMethodProxy onMethod: method handler: newHandler.
			newProxy ifNotNil: [ newProxy install ].
		]
]

{ #category : #setting }
MpAllocProfilerPropagator >> profiler: aProfiler [
	profiler := aProfiler
]
