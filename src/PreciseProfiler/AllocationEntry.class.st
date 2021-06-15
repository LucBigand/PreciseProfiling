Class {
	#name : #AllocationEntry,
	#superclass : #Object,
	#instVars : [
		'directAllocations',
		'totalAllocations',
		'directMemoryUsed',
		'totalMemoryUsed'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
AllocationEntry >> addAllocation: anObject [
	| memoryUsed |
	directAllocations := directAllocations + 1.
	totalAllocations := totalAllocations + 1.
	memoryUsed := anObject sizeInMemory.
	directMemoryUsed := directMemoryUsed + memoryUsed.
	totalMemoryUsed := totalMemoryUsed + memoryUsed.
]

{ #category : #adding }
AllocationEntry >> addFromEntry: anAllocationEntry [
	totalAllocations := totalAllocations + anAllocationEntry totalAllocations.
	totalMemoryUsed := totalMemoryUsed + anAllocationEntry totalMemoryUsed.
]

{ #category : #accessing }
AllocationEntry >> directAllocations [
	^ directAllocations 
]

{ #category : #accessing }
AllocationEntry >> directMemoryUsed [
	^ directMemoryUsed 
]

{ #category : #initialization }
AllocationEntry >> initialize [
	super initialize.
	directAllocations := totalAllocations := directMemoryUsed := totalMemoryUsed := 0
]

{ #category : #accessing }
AllocationEntry >> totalAllocations [
	^ totalAllocations 
]

{ #category : #accessing }
AllocationEntry >> totalMemoryUsed [
	^ totalMemoryUsed 
]
