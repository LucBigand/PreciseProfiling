"
I am a class that simulates the behaviour of a block for CHInterpreter (AST interpretation)

    Instance Variables
	code:		The code within this block
	definingContext:		CHMethodScope that represents the context in which this block is called
"
Class {
	#name : #CHBlock,
	#superclass : #Object,
	#instVars : [
		'code',
		'definingContext'
	],
	#category : #'Champollion-Core'
}

{ #category : #accessing }
CHBlock class >> chCompiledMethodAt: aSelector [
	^ FullBlockClosure >> aSelector 
]

{ #category : #accessing }
CHBlock >> code [
	^ code
]

{ #category : #setting }
CHBlock >> code: aRBBlockNode [
	code := aRBBlockNode
]

{ #category : #accessing }
CHBlock >> definingContext [
	^ definingContext
]

{ #category : #setting }
CHBlock >> definingContext: aScope [
	definingContext := aScope
]

{ #category : #accessing }
CHBlock >> numArgs [
	^ code arguments size
]

{ #category : #accessing }
CHBlock >> value [
	<primitive: 201>
	^ nil
]
