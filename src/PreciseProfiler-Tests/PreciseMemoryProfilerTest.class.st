Class {
	#name : #PreciseMemoryProfilerTest,
	#superclass : #PreciseProfilerTest,
	#category : #'PreciseProfiler-Tests'
}

{ #category : #setup }
PreciseMemoryProfilerTest >> setUp [
	super setUp.
	interpreter := PreciseMemoryProfiler new.
]

{ #category : #test }
PreciseMemoryProfilerTest >> testInterpreteArrayAllocatesMemory [
	interpreter runOn: CHInterpretable new method: #returnEmptyArray.
	self assert: ((interpreter rootNode childs at: 1) memoryUsed)
		equals: 16
]

{ #category : #test }
PreciseMemoryProfilerTest >> testInterpreteLiteralArrayDoesNotAllocateMemory [
	interpreter runOn: CHInterpretable new method: #returnEmptyLiteralArray.
	self assert: ((interpreter rootNode childs at: 1) memoryUsed)
		equals: 0
]
