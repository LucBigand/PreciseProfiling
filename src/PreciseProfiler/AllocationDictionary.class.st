Class {
	#name : #AllocationDictionary,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #PreciseProfiler
}

{ #category : #adding }
AllocationDictionary >> addAllocation: anObject [
	(dictionary includesKey: anObject class)
		ifFalse: [ dictionary at: anObject class put: AllocationEntry new ].
	(dictionary at: anObject class) addAllocation: anObject.
]

{ #category : #adding }
AllocationDictionary >> addFromDictionary: anAllocationDictionary [
	anAllocationDictionary get keysDo: [ :class |
		(dictionary includesKey: class )
			ifFalse: [ dictionary at: class put: AllocationEntry new ].
		(dictionary at: class) addFromEntry: (anAllocationDictionary at: class).
	]
]

{ #category : #accessing }
AllocationDictionary >> at: aClass [
	^ dictionary at: aClass
]

{ #category : #accessing }
AllocationDictionary >> get [
	^ dictionary
]

{ #category : #initialization }
AllocationDictionary >> initialize [
	super initialize.
	dictionary := Dictionary new.
]
