"
A value in an AllocationDictionary

All instance variables (directAllocations, directMemoryUsed, totalAllocations and totalMemoryUsed)
are positive or null integers.
"
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
	"Register the allocation of anObject as though it was directly instantiated in this context call"
	| memoryUsed |
	directAllocations := directAllocations + 1.
	totalAllocations := totalAllocations + 1.
	memoryUsed := anObject sizeInMemory.
	directMemoryUsed := directMemoryUsed + memoryUsed.
	totalMemoryUsed := totalMemoryUsed + memoryUsed.
]

{ #category : #adding }
AllocationEntry >> addFromEntry: anAllocationEntry [
	"Add the class, total number of allocations and total amount of memory used by another AllocationEntry to this one."
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
