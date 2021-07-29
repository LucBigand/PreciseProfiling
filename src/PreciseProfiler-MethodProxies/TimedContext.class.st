"
I am a class that registers the context and time of a method's execution

Instance variables
	time : an integer representing the time of a method's execution
	context : the calling context of this method
"
Class {
	#name : #TimedContext,
	#superclass : #Object,
	#instVars : [
		'time',
		'context',
		'converted'
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
	"Convert the method context as to only keep the methods that are assumed to be studied by a
	MpProfilingAdministrator, and then add a new top method"
	| convertedStack stackLoopLength |
	converted ifTrue: [ ^ self ].
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
	context := convertedStack.
	converted := true.
]

{ #category : #initialization }
TimedContext >> initialize [
	super initialize.
	converted := false.
	time := Time primUTCMicrosecondsClock
]

{ #category : #accessing }
TimedContext >> time [
	^ time
]
