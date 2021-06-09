Class {
	#name : #PreciseInterpreterPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'window'
	],
	#category : #PreciseProfiler
}

{ #category : #test }
PreciseInterpreterPresenterTest >> tearDown [
	super tearDown.
	window ifNotNil: [ window close ]
]

{ #category : #test }
PreciseInterpreterPresenterTest >> testSelectingElementInTheListUpdatesCodePresenter [
	| interpreter presenter methodTree |
	interpreter := PreciseInterpreter new.
	interpreter runOn: 5 method: #+ andArguments: #(3).
	window := interpreter display.
	presenter := window presenter.
	methodTree := presenter mainPresenter selectedPage activePresenter.
	
	methodTree selectPath: #(1).
	self assert: ( presenter codePresenter text ) 
		equals: (SmallInteger >> #+) sourceCode .
]

{ #category : #test }
PreciseInterpreterPresenterTest >> testSmallIntegerAddition [
	| interpreter presenter methodTree |
	interpreter := PreciseInterpreter new.
	interpreter runOn: 5 method: #+ andArguments: #(3).
	window := interpreter display.
	presenter := window presenter.
	methodTree := presenter mainPresenter selectedPage activePresenter.
	self assert: ( methodTree roots at: 1 ) method
		equals: SmallInteger >> #+.
]
