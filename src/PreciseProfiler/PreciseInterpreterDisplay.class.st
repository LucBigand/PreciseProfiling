Class {
	#name : #PreciseInterpreterDisplay,
	#superclass : #SpPresenter,
	#instVars : [
		'interpreter',
		'mainPresenter',
		'codePresenter',
		'code'
	],
	#category : #PreciseProfiler
}

{ #category : #specs }
PreciseInterpreterDisplay class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #mainPresenter;
		add: #codePresenter;
		yourself.
]

{ #category : #specs }
PreciseInterpreterDisplay class >> defaultSpec [ 
	^ self defaultLayout
]

{ #category : #opening }
PreciseInterpreterDisplay class >> openOn: aPreciseInterpreter [
	^ self basicNew
		interpreter: aPreciseInterpreter;
		initialize;
		openWithSpec.
]

{ #category : #initialization }
PreciseInterpreterDisplay >> initializeListPage [
	^ self newList
		items: interpreter methodList associations;
		display: [ :anAssociation | | method |
			method := anAssociation key.
			method classBinding value asString, '>>', method selector asString, ' - ',
				anAssociation value asString];
		sortingBlock: [ :e1 :e2 | e1 value > e2 value ];
		yourself.
]

{ #category : #initialization }
PreciseInterpreterDisplay >> initializePresenter [
	code := ''.
	mainPresenter := self newNotebook
		addPageTitle: 'Method tree' provider: self initializeTreePage;
		addPageTitle: 'Method list' provider: self initializeListPage;		
		yourself.
	codePresenter := self newText
		beNotEditable;
		text: code;
		yourself.
]

{ #category : #initialization }
PreciseInterpreterDisplay >> initializeTreePage [
	| treeTemp |
	treeTemp := self newTree
		roots: interpreter rootNode childs;
		children: [ :aNode | aNode childs ];
		display: [ :aNode | aNode description ];
		activateOnSingleClick;
		yourself.
	
	^ treeTemp
]

{ #category : #initialization }
PreciseInterpreterDisplay >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter
		title: 'Precise Profiler Display';
		initialExtent: 750@500
]

{ #category : #setting }
PreciseInterpreterDisplay >> interpreter: aPreciseInterpreter [
	interpreter := aPreciseInterpreter
]
