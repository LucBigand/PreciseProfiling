Class {
	#name : #AbstractPreciseNonRootNode,
	#superclass : #AbstractPreciseNode,
	#instVars : [
		'parent',
		'numberOfCalls'
	],
	#category : #PreciseProfiler
}

{ #category : #setting }
AbstractPreciseNonRootNode >> incrementNumberOfCalls [
	numberOfCalls := numberOfCalls + 1.
	
]

{ #category : #accessing }
AbstractPreciseNonRootNode >> parent [
	^ parent
]

{ #category : #setting }
AbstractPreciseNonRootNode >> parent: aPreciseNode [
	parent := aPreciseNode.
	aPreciseNode addChild: self.
]
