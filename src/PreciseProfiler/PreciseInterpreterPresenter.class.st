"
I offer a visual display for the informations registered by a PreciseInterpreter, more precisely a tree of method contexts and a list of all methods called in descending order of number of calls.

    Instance Variables
	code:		A ByteString, equal to the code of the method selected
	codePresenter:		A SpTextPresenter, used to display the code
	interpreter:		The PreciseInterpreter whose informations are being displayed
	mainPresenter:		A SpNotebook, with two pages : One for the tree of method contexts and the other for the list of all method called
"
Class {
	#name : #PreciseInterpreterPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'interpreter',
		'mainPresenter',
		'codePresenter',
		'code'
	],
	#category : #'PreciseProfiler-Core'
}

{ #category : #specs }
PreciseInterpreterPresenter class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #mainPresenter;
		add: #codePresenter;
		yourself.
]

{ #category : #specs }
PreciseInterpreterPresenter class >> defaultSpec [ 
	^ self defaultLayout
]

{ #category : #opening }
PreciseInterpreterPresenter class >> openOn: aPreciseInterpreter [
	^ self basicNew
		interpreter: aPreciseInterpreter;
		initialize;
		openWithSpec.
]

{ #category : #accessing }
PreciseInterpreterPresenter >> codePresenter [
	^ codePresenter
]

{ #category : #initialization }
PreciseInterpreterPresenter >> initializeListPage [
	"Initialize the page with the list of all methods called, with a contextual menu used to inspect the associated PreciseNode or to open the method in the browser"
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
PreciseInterpreterPresenter >> initializePresenter [
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
PreciseInterpreterPresenter >> initializeTreePage [
	"Initialize the page with the tree of methods contexts, with a contextual menu used to inspect the associated PreciseNode or to open the method in the browser"
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
PreciseInterpreterPresenter >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter
		title: 'Precise Profiler Display';
		initialExtent: 750@500;
		toolbar: (self newToolbar
			addItem: (self newToolbarButton
				label: 'Memory usage';
				icon: (self application iconNamed: #smallAdd);
				action: [ PreciseMemoryPresenter openOn: interpreter ];
				yourself );
			yourself).
]

{ #category : #setting }
PreciseInterpreterPresenter >> interpreter: aPreciseInterpreter [
	interpreter := aPreciseInterpreter
]

{ #category : #accessing }
PreciseInterpreterPresenter >> mainPresenter [
	^ mainPresenter
]

{ #category : #updating }
PreciseInterpreterPresenter >> updateCodePresenter [
	codePresenter text: code
]

{ #category : #updating }
PreciseInterpreterPresenter >> updatePresenter [
	self updateCodePresenter
]
