Class {
	#name : #AllocationDictionaryTest,
	#superclass : #TestCase,
	#instVars : [
		'entry1',
		'entry2',
		'dict1',
		'dict2'
	],
	#category : #'PreciseProfiler-Tests'
}

{ #category : #running }
AllocationDictionaryTest >> setUp [
	super setUp.
	entry1 := AllocationEntry new
		addAllocation: '123';
		yourself.
	entry2 := AllocationEntry new
		addAllocation: '123';
		addAllocation: 'abcdefghi';
		yourself.
	dict1 := AllocationDictionary new
		addAllocation: '123';
		yourself.
	dict2 := AllocationDictionary new
		addAllocation: '123';
		addAllocation: 'abcdefghi';
		addAllocation: #(1 2 3)
		yourself.
]

{ #category : #test }
AllocationDictionaryTest >> testAddAllocationToDictionary [
	| entry |
	entry := dict1 at: ByteString.
	self assert: { entry directAllocations . entry totalAllocations .
			entry directMemoryUsed . entry totalMemoryUsed }
		equals: #(1 1 16 16)
]

{ #category : #test }
AllocationDictionaryTest >> testAddAllocationToEntry [
	self assert: { entry1 directAllocations . entry1 totalAllocations .
			entry1 directMemoryUsed . entry1 totalMemoryUsed }
		equals: #(1 1 16 16)
]

{ #category : #test }
AllocationDictionaryTest >> testAddFromAnotherDictionary [
	| tempEntry1 tempEntry2 |
	dict1 addFromDictionary: dict2.
	tempEntry1 := dict1 at: ByteString.
	tempEntry2 := dict1 at: Array.
	self assert: { tempEntry1 directAllocations . tempEntry1 totalAllocations .
			tempEntry1 directMemoryUsed . tempEntry1 totalMemoryUsed }
		equals: #(1 3 16 56).
	self assert: { tempEntry2 directAllocations . tempEntry2 totalAllocations .
			tempEntry2 directMemoryUsed . tempEntry2 totalMemoryUsed }
		equals: #(0 1 0 32).
]

{ #category : #test }
AllocationDictionaryTest >> testAddFromAnotherEntry [
	entry1 addFromEntry: entry2.
	self assert: { entry1 directAllocations . entry1 totalAllocations .
			entry1 directMemoryUsed . entry1 totalMemoryUsed }
		equals: #(1 3 16 56)
]

{ #category : #test }
AllocationDictionaryTest >> testMultipleAddAllocationToDictionary [
	| tempEntry1 tempEntry2 |
	tempEntry1 := dict2 at: ByteString.
	tempEntry2 := dict2 at: Array.
	self assert: { tempEntry1 directAllocations . tempEntry1 totalAllocations .
			tempEntry1 directMemoryUsed . tempEntry1 totalMemoryUsed }
		equals: #(2 2 40 40).
	self assert: { tempEntry2 directAllocations . tempEntry2 totalAllocations .
			tempEntry2 directMemoryUsed . tempEntry2 totalMemoryUsed }
		equals: #(1 1 32 32).
]

{ #category : #test }
AllocationDictionaryTest >> testMultipleAddAllocationToEntry [
	self assert: { entry2 directAllocations . entry2 totalAllocations .
			entry2 directMemoryUsed . entry2 totalMemoryUsed }
		equals: #(2 2 40 40)
]
