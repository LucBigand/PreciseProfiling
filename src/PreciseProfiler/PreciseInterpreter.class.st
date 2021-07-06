"
I am an ast interpreter that keeps a trace of all the method contexts with a tree of nodes composed of a PreciseRoot and instances of PreciseNode.

    Instance Variables
	currentNode:		The node corresponding to the method context currently visited. Returns the PreciseRoot once the tree has been computed
	methodList:		A list of all the methods called
	nextNode:		The calling context that will potentially be visited next (private)
"
Class {
	#name : #PreciseInterpreter,
	#superclass : #CHInterpreter,
	#instVars : [
		'methodList',
		'currentNode',
		'nextNode'
	],
	#category : #PreciseProfiler
}

{ #category : #display }
PreciseInterpreter >> display [
	"Open this interpreter and associated tree node in a PreciseInterpreterPresenter"
	^ PreciseInterpreterPresenter openOn: self
]

{ #category : #initialization }
PreciseInterpreter >> initialize [
	super initialize.
	methodList := Dictionary new.
	currentNode := PreciseRoot new.
]

{ #category : #accessing }
PreciseInterpreter >> methodList [
	^ methodList
]

{ #category : #setting }
PreciseInterpreter >> popFrame [
	currentNode := currentNode parent.
	^ super popFrame.
]

{ #category : #setting }
PreciseInterpreter >> pushNewFrame [
	currentNode := nextNode.
	^ super pushNewFrame.
]

{ #category : #visiting }
PreciseInterpreter >> registerMethodCall: aCompiledMethod [
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
PreciseInterpreter >> rootNode [
	^ currentNode
]

{ #category : #running }
PreciseInterpreter >> runOn: aClass method: aSelector [
	methodList := Dictionary new.
	^ self runOn: aClass method: aSelector andArguments: #()
]

{ #category : #running }
PreciseInterpreter >> runOn: aReceiver method: aSelector andArguments: args [
	"Runs this interpreter on a program composed of aReveiver, aSelector, and arguments args
	Example : The program '3 ** 5' is called with aReceiver = 3, aSelector = #**, and args = #(5)"
	| ast method res |
	method := (self lookup: aSelector fromClass: aReceiver class).
	ast := method parseTree.
	self registerMethodCall: method.
	res := self execute: ast withReceiver: aReceiver andArguments: args.
	^ res
]

{ #category : #visiting }
PreciseInterpreter >> visitCascadeMessage: aMessageNode withReceiver: anObject [
	self registerMethodCall: (self lookup: aMessageNode selector fromClass: anObject class).
	^  super visitCascadeMessage: aMessageNode withReceiver: anObject
]

{ #category : #visiting }
PreciseInterpreter >> visitMessageNode: aNode [
	| dict |
	dict := self auxVisitMessageNode: aNode.
	self registerMethodCall: (dict at: 'method').
	^ self 
		execute: ((dict at: 'method') ast)
		withReceiver: (dict at: 'receiver')
		andArguments: (dict at: 'args').
]
