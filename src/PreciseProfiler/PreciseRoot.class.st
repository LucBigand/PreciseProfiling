Class {
	#name : #PreciseRoot,
	#superclass : #AbstractPreciseNode,
	#instVars : [
		'maxNumberOfCalls'
	],
	#category : #PreciseProfiler
}

{ #category : #computing }
PreciseRoot >> auxComputeMaxNumberOfCall: aNode [
	| res |
	res := aNode numberOfCalls.
	aNode childs do: [ :child | | childMNOC |
		childMNOC := self auxComputeMaxNumberOfCall: child.
		(childMNOC > res) 
			ifTrue: [ res := childMNOC ] ].
	^ res
]

{ #category : #setting }
PreciseRoot >> childNodeClass: aClass [
	childNodeClass := aClass 
]

{ #category : #computing }
PreciseRoot >> computeMaxNumberOfCall [
	" Compute the maximum number of calls for a method in the tree's hierarchy "
	| res |
	res := 0.
	childs do: [ :child | | childMNOC |
		childMNOC := self auxComputeMaxNumberOfCall: child.
		(childMNOC > res) 
			ifTrue: [ res := childMNOC ] ].
	maxNumberOfCalls := res.
]

{ #category : #accessing }
PreciseRoot >> maxNumberOfCalls [
	^ maxNumberOfCalls
]
