Class {
	#name : #CTStack,
	#superclass : #Object,
	#instVars : [
		'elements'
	],
	#category : #'Champollion-Core'
}

{ #category : #accessing }
CTStack >> capacity [ 
	^  elements capacity
]

{ #category : #accessing }
CTStack >> ifEmpty: aBlock [
	"If the receiver is empty execute the given block, returning its value, otherwise return the receiver."

	
	"Note that the fact that this method returns its receiver in case the receiver is not empty allows one to write expressions like the following ones: self classifyMethodAs: (myProtocol ifEmpty: ['As yet unclassified'])"

	^ elements ifEmpty: aBlock ifNotEmpty: [ self ]
]

{ #category : #accessing }
CTStack >> ifEmpty: aBlockClosure ifNotEmpty: aBlockClosure2 [
	"Evaluate emptyBlock if I'm empty, evalute notEmptyBlock otherwise"
	"If the notEmptyBlock has an argument, execute it using the receiver as its argument"

	
	^ elements ifEmpty: aBlockClosure ifNotEmpty: aBlockClosure2
]

{ #category : #accessing }
CTStack >> ifNotEmpty: aBlock [ 
	"Evaluate the given block with the receiver as its argument, returning its value
	unless the receiver is empty, in which case return the receiver."


	^ elements ifNotEmpty: aBlock ifEmpty: [ self ]
]

{ #category : #accessing }
CTStack >> ifNotEmpty: aBlockClosure ifEmpty: aBlockClosure2 [ 
	"Evaluate emptyBlock if I'm empty, otherwise evaluate notEmptyBlock.
	 If the notEmptyBlock has an argument, execute with the receiver as its argument"
	
	^ elements ifNotEmpty: aBlockClosure ifEmpty: aBlockClosure2
]

{ #category : #accessing }
CTStack >> initialize [ 

	super initialize.
	elements := OrderedCollection new
]

{ #category : #accessing }
CTStack >> initializeWith: aNumber [
	"Pre allocate the number of elements in the underlying data structure to avoid growing it multiple time when dealing with large stacks."
	
	elements := OrderedCollection new: aNumber
]

{ #category : #accessing }
CTStack >> isEmpty [ 
	
	^ elements isEmpty
]

{ #category : #accessing }
CTStack >> pop [ 
	"Returns the first element and removes it from the receiver."

	^ elements removeFirst
]

{ #category : #accessing }
CTStack >> push: anObject [ 
	"Adds a new object of any kind on top of the receiver."
	
	elements addFirst: anObject.
	^ anObject
]

{ #category : #accessing }
CTStack >> size [ 

	^ elements size
]

{ #category : #accessing }
CTStack >> top [ 
	"Returns the first element of the receiver without removing it."
	
	^ elements first
]
