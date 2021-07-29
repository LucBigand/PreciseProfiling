"
I oversee the profiling of a block of code by using method proxies

    Instance Variables
	initialMethods:		A set of the first methods on which to install a proxy. Preferably, those 
			methods should be ones that are called directly by a block of code being studied 
			(for example, it should include only Integer>>#fact for profiling [ ^ 5 fact ]
	methodList:		Dictionary that registers the methods called directly or indirectly by the block 
			and the number of time each has been called (possible inaccuracies)
	originalStacks:		Associates the converted stacks gathered on the method proxies to their
			original values
	rootNode:		The root node of the generated method context tree
	stacks:		The converted stacks of the method contexts captured during the execution of the
			methods studied
"
Class {
	#name : #MpProfilingAdministrator,
	#superclass : #Object,
	#instVars : [
		'initialMethods',
		'stacks',
		'methodList',
		'rootNode',
		'originalStacks'
	],
	#category : #'PreciseProfiler-MethodProxies'
}

{ #category : #adding }
MpProfilingAdministrator >> addMethod: aCompiledMethod [
	initialMethods add: aCompiledMethod
]

{ #category : #display }
MpProfilingAdministrator >> display [
	PreciseInterpreterPresenter openOn: self
]

{ #category : #computing }
MpProfilingAdministrator >> generateMethodList [
	"Creates a list of method called and the number of times they have been called based on the
	registered stacks"
	methodList := Dictionary new.
	stacks do: [ :stack |
		(methodList includesKey: stack context first)
			ifTrue: [ methodList at: stack context first update: [ :count | count + 1 ] ]
			ifFalse: [ methodList at: stack context first put: 1 ] ]
]

{ #category : #computing }
MpProfilingAdministrator >> generateNodeTree [
	"Generates a tree of method contexts based on the registered stacks"
	rootNode := PreciseRoot new
		childNodeClass: PreciseMemoryNode.
	stacks do: [ :stack | | currentNode |
		currentNode := rootNode.
		stack context allButFirst reverseDo: [ :method |
			currentNode := currentNode childs
				detect: [ :node | node method == method ]
				ifNone: [ currentNode addMethodCall: method. ] ].
		currentNode addMethodCall: stack context first
	]
]

{ #category : #initialization }
MpProfilingAdministrator >> initialize [
	super initialize.
	initialMethods := Set new.
	originalStacks := Dictionary new.
	stacks := OrderedCollection new.
]

{ #category : #accessing }
MpProfilingAdministrator >> methodList [
	^ methodList
]

{ #category : #accessing }
MpProfilingAdministrator >> rootNode [
	^ rootNode
]

{ #category : #running }
MpProfilingAdministrator >> runOn: aBlock [
	"Profile a block of code with self-propagating method proxies (MpProfilingHandler). The proxies
	that have registered activities will then be analyzed to extrapolate informations on the
	block's execution"
	| proxies |
	proxies := initialMethods collect: [ :method | MpMethodProxy
		onMethod: method
		handler: MpProfilingHandler new ].
	[ proxies do: [ :proxy | proxy install ].
	aBlock value.
	MpMethodProxy allInstancesDo: [ :proxy | proxy uninstall ] ] valueUninterruptably .
	MpProfilingHandler allInstances 
		select: [ :handler | handler count > 0 ]
		thenDo: [ :handler | | convertedStacks |
			convertedStacks := handler convertStacks.
			originalStacks addAll: convertedStacks.
			stacks addAll: convertedStacks keys.
			handler count: 0 ].
	stacks := stacks select: [ :stack | initialMethods includes: stack context last ].
	stacks sort.
	self generateMethodList.
	self generateNodeTree.
]

{ #category : #accessing }
MpProfilingAdministrator >> stacks [
	^ stacks
]
