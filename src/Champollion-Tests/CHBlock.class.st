Class {
	#name : #CHBlock,
	#superclass : #Object,
	#instVars : [
		'code',
		'definingContext'
	],
	#category : #'Champollion-Tests'
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
CHBlock >> value [
	<primitive: 201>
	^ nil
]
