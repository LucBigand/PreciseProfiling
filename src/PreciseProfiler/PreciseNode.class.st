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
	#category : #'PreciseProfiler-Core'
}

{ #category : #accessing }
PreciseNode >> allocationDict [  
	"Workaround to get non-memory node displayed by PreciseMemoryPresenter"
	^ AllocationDictionary new
]

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

{ #category : #printing }
PreciseNode >> longDescription [
	"Returns a string that contains information related to the classes, number and used memory of allocated object within this method context"
	method ifNil: [ ^ '' ].
	^ '<' , method classBinding value asString, '>>', method selector asString, '>', String cr,
		'# Executions: ', numberOfCalls asString
]

{ #category : #accessing }
PreciseNode >> memoryUsed [ 
	"Workaround to get non-memory node displayed by PreciseMemoryPresenter"
	^ 0
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
