"
I am a utility class for a PreciseMemoryNode.

I register all the classes instanciated directly or directly by a program for the calling context associated with this node, as well as the number of times and the total amount of memory consumed by these instanciations.

    Instance Variables
	dictionary:		Dictionary where keys are classes and values are AllocationEntry
"
Class {
	#name : #AllocationDictionary,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'PreciseProfiler-Memory'
}

{ #category : #adding }
AllocationDictionary >> addAllocation: anObject [
	"Register the allocation of anObject as though it was directly instantiated in this method context"
	(dictionary includesKey: anObject class)
		ifFalse: [ dictionary at: anObject class put: AllocationEntry new ].
	(dictionary at: anObject class) addAllocation: anObject.
]

{ #category : #adding }
AllocationDictionary >> addFromDictionary: anAllocationDictionary [
	"Add the classes, total number of instanciations and total use of memory of another 
	AllocationDictionary to this one.
	Should only be used on AllocationDictionary whose associated PreciseMemoryNode are descendants
	of the one associated with self"
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
