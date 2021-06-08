Class {
	#name : #PreciseAllocationNode,
	#superclass : #AbstractPreciseNonRootNode,
	#category : #PreciseProfiler
}

{ #category : #printing }
PreciseAllocationNode >> description [
	^ 'Object allocation - ', numberOfCalls asString
]
