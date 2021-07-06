"
I am an ast interpreter that keeps a trace of all the method contexts with a tree of nodes composed of a PreciseRoot and instances of PreciseNode.

    Instance Variables
	currentNode:		The node corresponding to the method context currently visited. Returns the PreciseRoot once the tree has been computed
	methodList:		A list of all the methods called
	nextNode:		The calling context that will potentially be visited next (private)
"
Class {
	#name : #PreciseProfiler,
	#superclass : #AbstractPreciseProfiler,
	#instVars : [
		'methodList',
		'currentNode',
		'nextNode'
	],
	#category : #PreciseProfiler
}

{ #category : #display }
PreciseProfiler >> display [
	"Open this interpreter and associated tree node in a PreciseInterpreterPresenter"
	^ PreciseInterpreterPresenter openOn: self
]

{ #category : #initialization }
PreciseProfiler >> initialize [
	super initialize.
	methodList := Dictionary new.
	currentNode := PreciseRoot new.
]

{ #category : #accessing }
PreciseProfiler >> methodList [
	^ methodList
]

{ #category : #setting }
PreciseProfiler >> popFrame [
	currentNode := currentNode parent.
	^ super popFrame.
]

{ #category : #setting }
PreciseProfiler >> pushNewFrame [
	currentNode := nextNode.
	^ super pushNewFrame.
]

{ #category : #registering }
PreciseProfiler >> registerMethodCall: aCompiledMethod [
	"Register the method call within the node tree"
	| method |
	method := (aCompiledMethod classBinding value == CHBlock)
		ifTrue: [ FullBlockClosure >> (aCompiledMethod selector) ] 
		ifFalse: [ aCompiledMethod ].
	(methodList includesKey: method)
		ifTrue: [ methodList at: method update: [ :count | count + 1 ] ]
		ifFalse: [ methodList at: method put: 1 ].
	nextNode := currentNode addMethodCall: method.
	
]

{ #category : #accessing }
PreciseProfiler >> rootNode [
	^ currentNode
]

{ #category : #visiting }
PreciseProfiler >> visitCascadeMessage: aMessageNode withReceiver: anObject [
	self registerMethodCall: (self lookup: aMessageNode selector fromClass: anObject class).
	^  super visitCascadeMessage: aMessageNode withReceiver: anObject
]

{ #category : #visiting }
PreciseProfiler >> visitMessageNode: aNode [
	| dict |
	dict := self auxVisitMessageNode: aNode.
	self registerMethodCall: (dict at: #method).
	^ self 
		execute: ((dict at: #method) ast)
		withReceiver: (dict at: #receiver)
		andArguments: (dict at: #args).
]
