Class {
	#name : #PreciseMemoryNode,
	#superclass : #PreciseNode,
	#instVars : [
		'memoryUsed',
		'classes',
		'numberOfAllocations',
		'updated'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
PreciseMemoryNode >> addAllocation: anObject [
	memoryUsed := memoryUsed + anObject sizeInMemory.
	numberOfAllocations := numberOfAllocations + 1.
	(classes includesKey: anObject class)
		ifTrue: [ classes at: anObject class update: [ :count | count + 1 ] ]
		ifFalse: [ classes at: anObject class put: 1 ]
]

{ #category : #printing }
PreciseMemoryNode >> description [
	method ifNil: [ ^ '' ].
	^ method classBinding value asString, '>>#', method selector asString, ' - ',
		memoryUsed asString , ' bytes, ' , numberOfAllocations asString , ' allocations'
]

{ #category : #initialization }
PreciseMemoryNode >> initialize [
	super initialize.
	memoryUsed := 0.
	numberOfAllocations := 0.
	classes := Dictionary new.
	childNodeClass := self class.
	updated := false.
]

{ #category : #printing }
PreciseMemoryNode >> longDescription [
	method ifNil: [ ^ '' ].
	^ method classBinding value asString, '>>#', method selector asString, ' - ',
		memoryUsed asString , ' bytes, ' , numberOfAllocations asString , ' allocations'
]

{ #category : #accessing }
PreciseMemoryNode >> memoryUsed [
	^ memoryUsed
]

{ #category : #accessing }
PreciseMemoryNode >> numberOfAllocations [ 
	^ numberOfAllocations
]

{ #category : #updating }
PreciseMemoryNode >> updateMemoryAndAllocation [
	updated ifFalse: [ 
		self updateNumberOfAllocations.
		self updateMemoryUsed.
		updated := true.]
]

{ #category : #updating }
PreciseMemoryNode >> updateMemoryUsed [
	childs do: [ :child | 
		memoryUsed := memoryUsed + child updateMemoryUsed ].
	^ memoryUsed
	
]

{ #category : #updating }
PreciseMemoryNode >> updateNumberOfAllocations [
	childs do: [ :child | 
		numberOfAllocations := numberOfAllocations + child updateNumberOfAllocations ].
	^ numberOfAllocations
]
