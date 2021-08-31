Class {
	#name : #PreciseProfilerPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'window',
		'profiler'
	],
	#category : #'PreciseProfiler-Tests'
}

{ #category : #setup }
PreciseProfilerPresenterTest >> setUp [
	super setUp.
	profiler := PreciseProfiler new
]

{ #category : #test }
PreciseProfilerPresenterTest >> tearDown [
	super tearDown.
	window ifNotNil: [ window close ]
]

{ #category : #test }
PreciseProfilerPresenterTest >> testSelectingElementInTheListUpdatesCodePresenter [
	| presenter methodTree |
	profiler runOn: 5 method: #+ andArguments: #(3).
	window := profiler display.
	presenter := window presenter.
	methodTree := presenter mainPresenter selectedPage activePresenter.
	
	methodTree selectPath: #(1).
	self assert: ( presenter codePresenter text ) 
		equals: (SmallInteger >> #+) sourceCode .
]

{ #category : #test }
PreciseProfilerPresenterTest >> testSmallIntegerAddition [
	| presenter methodTree |
	profiler runOn: 5 method: #+ andArguments: #(3).
	window := profiler display.
	presenter := window presenter.
	methodTree := presenter mainPresenter selectedPage activePresenter.
	self assert: ( methodTree roots at: 1 ) method
		equals: SmallInteger >> #+.
]
