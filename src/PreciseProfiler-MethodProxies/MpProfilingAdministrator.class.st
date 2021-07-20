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
	methodList := Dictionary new.
	stacks do: [ :stack |
		(methodList includesKey: stack context first)
			ifTrue: [ methodList at: stack context first update: [ :count | count + 1 ] ]
			ifFalse: [ methodList at: stack context first put: 1 ] ]
]

{ #category : #computing }
MpProfilingAdministrator >> generateNodeTree [
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
