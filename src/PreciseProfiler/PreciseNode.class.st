"
I am a concrete implementation of AbstractPreciseNode. I register a method and the number of time this method has been called within this method context.

    Instance Variables
	method:		The method called
	numberOfCalls:		An integer, represents the number of times this method has been called within this method context
	parent:		A PreciseNode associated with the method context in which this method has been called
"
Class {
	#name : #PreciseNode,
	#superclass : #AbstractPreciseNode,
	#instVars : [
		'numberOfCalls',
		'method',
		'parent'
	],
	#category : #PreciseProfiler
}

{ #category : #printing }
PreciseNode >> description [
	method ifNil: [ ^ '' ].
	^ method classBinding value asString, '>>#', method selector asString, ' - ', numberOfCalls asString
]

{ #category : #setting }
PreciseNode >> incrementNumberOfCalls [
	numberOfCalls := numberOfCalls + 1.
	
]

{ #category : #initialization }
PreciseNode >> initialize [
	super initialize.
	numberOfCalls := 1.
]

{ #category : #accessing }
PreciseNode >> method [
	^ method
]

{ #category : #setting }
PreciseNode >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
PreciseNode >> numberOfCalls [
	^ numberOfCalls
]

{ #category : #accessing }
PreciseNode >> parent [
	^ parent
]

{ #category : #setting }
PreciseNode >> parent: aPreciseNode [
	parent := aPreciseNode.
	aPreciseNode addChild: self.
]
