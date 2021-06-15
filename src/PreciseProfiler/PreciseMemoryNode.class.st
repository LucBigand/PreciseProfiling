Class {
	#name : #PreciseMemoryNode,
	#superclass : #PreciseNode,
	#instVars : [
		'memoryUsed',
		'numberOfAllocations',
		'updated',
		'allocationDict'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
PreciseMemoryNode >> addAllocation: anObject [
	memoryUsed := memoryUsed + anObject sizeInMemory.
	numberOfAllocations := numberOfAllocations + 1.
	allocationDict addAllocation: anObject.
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
	allocationDict := AllocationDictionary new.
	childNodeClass := self class.
	updated := false.
]

{ #category : #printing }
PreciseMemoryNode >> longDescription [
	| res |
	method ifNil: [ ^ '' ].
	res := '<' , method classBinding value asString, '>>', method selector asString, '>', String cr,
		'# Executions: ', numberOfCalls asString , String cr.
	allocationDict get keysDo: [ :class | | entry |
		entry := allocationDict at: class.
		res := res , class asString , ' - ' , entry totalAllocations asString , ' allocations, ',
			 entry totalMemoryUsed asString , ' bytes', String cr ].
	^ res
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
PreciseMemoryNode >> update [

	updated ifTrue: [ ^ self ].
	self updateNumberOfAllocations;
		updateMemoryUsed;
		updateAllocationDict.
	updated := true
]

{ #category : #updating }
PreciseMemoryNode >> updateAllocationDict [
	childs do: [ :child | 
		allocationDict addFromDictionary: child updateAllocationDict ].
	^ allocationDict
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
