Class {
	#name : #TimedContext,
	#superclass : #Object,
	#instVars : [
		'time',
		'context'
	],
	#category : #'PreciseProfiler-MethodProxies'
}

{ #category : #'instance creation' }
TimedContext class >> newFrom: aCollection [
	^ self new
		context: aCollection;
		yourself
]

{ #category : #comparing }
TimedContext >> <= aTimedContext [
	^ (context size == aTimedContext context size)
		ifTrue: [ time <= aTimedContext time ]
		ifFalse: [ context size < aTimedContext context size ]
]

{ #category : #accessing }
TimedContext >> context [
	^ context
]

{ #category : #setting }
TimedContext >> context: aCollection [
	context := aCollection
]

{ #category : #converting }
TimedContext >> convertContextWithTopMethod: aCompiledMethod [
	| convertedStack stackLoopLength |
	stackLoopLength := MpProfilingHandler classPool at: #StackLoopLength.
	convertedStack := OrderedCollection new.
	convertedStack add: aCompiledMethod.
	stackLoopLength to: context size by: stackLoopLength do: [ :i |
		convertedStack add: (context at: i) method ].
	(convertedStack anySatisfy: [ :each | each isDoIt or: each isCompiledBlock ])
		ifTrue: [ | i |
			i := 1.
			[ ((convertedStack at: i) isDoIt or: (convertedStack at: i) isCompiledBlock) ]
				whileFalse: [ i := i + 1 ].
			[ convertedStack size >= i ] whileTrue: [ convertedStack removeLast ] ]
		ifFalse: [ convertedStack := nil ].
	context := convertedStack
]

{ #category : #initialization }
TimedContext >> initialize [
	super initialize.
	time := Time primUTCMicrosecondsClock
]

{ #category : #accessing }
TimedContext >> time [
	^ time
]
