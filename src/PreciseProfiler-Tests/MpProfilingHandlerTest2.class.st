Class {
	#name : #MpProfilingHandlerTest2,
	#superclass : #TestCase,
	#category : #'PreciseProfiler-Tests'
}

{ #category : #test }
MpProfilingHandlerTest2 >> testNoInfiniteLoopWhenExecutingAddition [
	| methods stacks aBlock proxies |
	[ methods := Set newFrom: { SmallInteger >> #+ }.
	stacks := OrderedCollection new.
	aBlock := [ 3 + 3 ].

	proxies := methods collect: [ :method | MpMethodProxy
	onMethod: SmallInteger >> #+
	handler: MpProfilingHandler new ].
	proxies do: [ :proxy | proxy install ].
	aBlock value.
	MpMethodProxy allInstancesDo: [ :proxy | proxy uninstall ] ] valueUninterruptably .
]
