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

{ #category : #accessing }
PreciseInterpreterDisplay >> codePresenter [
	^ codePresenter
]

{ #category : #initialization }
PreciseInterpreterDisplay >> initializeListPage [
	| listTemp |
	listTemp := self newList
		items: interpreter methodList associations;
		display: [ :anAssociation | | method |
			method := anAssociation key.
			method isString 
				ifTrue: [ method, ' - ', anAssociation value asString ]
				ifFalse: [ method classBinding value asString, '>>', method selector asString, ' - ',
					anAssociation value asString ] ];
		sortingBlock: [ :e1 :e2 | e1 value > e2 value ];
		activateOnSingleClick;
		yourself.
	
	listTemp
		contextMenu: [
			self newMenu
				addItem: [ :item |
					item name: 'Browse';
					action: [ Smalltalk tools browser openOnMethod: listTemp selectedItem key ] ];
				addItem: [ :item |
					item name: 'Inspect';
					action: [ listTemp selectedItem inspect ] ] ];
		whenActivatedDo: [
			code := listTemp selectedItem key sourceCode.
			self updatePresenter.
		] .
	
	^ listTemp
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
	
	treeTemp
		contextMenu: [
			self newMenu
				addItem: [ :item |
					item name: 'Browse';
					action: [ Smalltalk tools browser openOnMethod: treeTemp selectedItem method ] ];
				addItem: [ :item |
					item name: 'Inspect';
					action: [ treeTemp selectedItem inspect ] ] ];
		whenActivatedDo: [
			code := treeTemp selectedItem method sourceCode.
			self updatePresenter.
		] .
	
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

{ #category : #accessing }
PreciseInterpreterDisplay >> mainPresenter [
	^ mainPresenter
]

{ #category : #updating }
PreciseInterpreterDisplay >> updateCodePresenter [
	codePresenter text: code
]

{ #category : #updating }
PreciseInterpreterDisplay >> updatePresenter [
	self updateCodePresenter
]
