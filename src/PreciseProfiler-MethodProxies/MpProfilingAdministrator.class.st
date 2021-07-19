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
		(methodList includesKey: stack first)
			ifTrue: [ methodList at: stack first update: [ :count | count + 1 ] ]
			ifFalse: [ methodList at: stack first put: 1 ] ]
]

{ #category : #computing }
MpProfilingAdministrator >> generateNodeTree [
	rootNode := PreciseRoot new
		childNodeClass: PreciseMemoryNode.
	stacks sort: [ :stack1 :stack2 | stack1 size < stack2 size ].
	stacks do: [ :stack | | currentNode |
		currentNode := rootNode.
		stack allButFirst reverseDo: [ :method |
			currentNode := currentNode childs
				detect: [ :node | node method == method ]
				ifNone: [ currentNode addMethodCall: method. ] ].
		currentNode addMethodCall: stack first
	]
]

{ #category : #initialization }
MpProfilingAdministrator >> initialize [
	super initialize.
	initialMethods := Set new.
	originalStacks := OrderedCollection new.
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
			stacks addAll: ( convertedStacks collect: [ :stack | stack key ] ) .
			stacks := stacks select: [ :stack | initialMethods includes: stack last ].
			handler count: 0 ].
	self generateMethodList.
	self generateNodeTree.
]

{ #category : #accessing }
MpProfilingAdministrator >> stacks [
	^ stacks
]
