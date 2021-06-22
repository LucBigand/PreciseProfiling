"
I am a type of PreciseNode that also registers informations pertaining to the objects that my associated method has allocated : their class, number, and memory used.

    Instance Variables
	allocationDict:		An AllocationDictionary
	memoryUsed:		An integer, represents the total amount of memory used in bytes (only among directly allocated objects before updated, and among all allocated objects after).
	numberOfAllocations:		An integer, represents the total amount of allocations done (only among directly allocated objects before updated, and among all allocated objects after).
	updated:		A boolean, false before this node has been updated and true after
"
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
	"Register the allocation of anObject as though it was directly instantiated in this context call"
	memoryUsed := memoryUsed + anObject sizeInMemory.
	numberOfAllocations := numberOfAllocations + 1.
	allocationDict addAllocation: anObject.
]

{ #category : #accessing }
PreciseMemoryNode >> allocationDict [
	^ allocationDict get
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
	"Returns a string that contains information related to the classes, number and used memory of allocated object within this method context"
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
	"Update the number of allocations, memory used and allocation dictionary to include indirectly allocated object"
	updated ifTrue: [ ^ self ].
	self updateNumberOfAllocations;
		updateMemoryUsed;
		updateAllocationDict.
	updated := true
]

{ #category : #updating }
PreciseMemoryNode >> updateAllocationDict [
	"Update the allocation dictionary to include indirectly allocated object"
	childs do: [ :child | 
		allocationDict addFromDictionary: child updateAllocationDict ].
	^ allocationDict
]

{ #category : #updating }
PreciseMemoryNode >> updateMemoryUsed [
	"Update the memory used to include indirectly allocated object"
	childs do: [ :child | 
		memoryUsed := memoryUsed + child updateMemoryUsed ].
	^ memoryUsed
	
]

{ #category : #updating }
PreciseMemoryNode >> updateNumberOfAllocations [
	"Update the number of allocations to include indirectly allocated object"
	childs do: [ :child | 
		numberOfAllocations := numberOfAllocations + child updateNumberOfAllocations ].
	^ numberOfAllocations
]
