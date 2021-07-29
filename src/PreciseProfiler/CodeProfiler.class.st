"
I am a profiler that keeps a trace of all the methods called in one or multiple packages, as well as informations concerning the senders of each method calls.

  Instance Variables
	packageSpies: A list of package spies
"
Class {
	#name : #CodeProfiler,
	#superclass : #AbstractPreciseProfiler,
	#instVars : [
		'packageSpies',
		'methodCalls',
		'currentReceiver'
	],
	#category : #'PreciseProfiler-Spy'
}

{ #category : #setting }
CodeProfiler >> addPackage: aPackage [
	"Add a package to the list of packages being studied"
	packageSpies at: aPackage put: (PackageSpy new initializeWith: aPackage)
]

{ #category : #accessing }
CodeProfiler >> classSpies [
	| res |
	res := Set new.
	self packageSpies do: [ :packageSpy |
		res addAll: packageSpy classSpies ].
	^ res
]

{ #category : #accessing }
CodeProfiler >> classSpyAt: aClass [
	^ (self packageSpyAt: aClass package) classSpyAt: aClass
]

{ #category : #initialization }
CodeProfiler >> initialize [
	super initialize.
	packageSpies := Dictionary new.
	methodCalls := CTStack new.
]

{ #category : #accessing }
CodeProfiler >> metaclassSpies [
	^ self classSpies collect: [ :classSpy | classSpy metaclassSpy ]
]

{ #category : #accessing }
CodeProfiler >> metaclassSpyAt: aClass [
	^ (self classSpyAt: aClass) metaclassSpy
]

{ #category : #accessing }
CodeProfiler >> methodSpies [
	| res |
	res := Set new.
	self classSpies do: [ :classSpy |
		res addAll: classSpy methodSpies ].
	^ res
]

{ #category : #accessing }
CodeProfiler >> methodSpyAt: aMethod [
	^ ((self packageSpyAt: aMethod classBinding value package)
		classSpyAt: aMethod classBinding value)
			methodSpyAt: aMethod
]

{ #category : #accessing }
CodeProfiler >> packageSpies [
	^ packageSpies values asSet
]

{ #category : #accessing }
CodeProfiler >> packageSpyAt: aPackage [
	^ packageSpies at: aPackage
]

{ #category : #registering }
CodeProfiler >> registerMethodCall: aCompiledMethod [
	"Verifies whether or not the compiled method is currently being spied on, and register information pertaining to the context if its execution id that is the case"
	| method previousMethod packages |
	method := (aCompiledMethod classBinding value == CHBlock)
		ifTrue: [ FullBlockClosure >> (aCompiledMethod selector) ]
		ifFalse: [ aCompiledMethod ].
	previousMethod := methodCalls 
		ifEmpty: [ nil ]
		ifNotEmpty:  [ methodCalls top ].
	methodCalls push: method.
	packages := packageSpies keys.
	(packages includes: method package) ifFalse: [ ^ self ].
	previousMethod ifNil: [ 
		(self methodSpyAt: method) incrementNumberOfCalls.
		^ self ].
	(packages includes: previousMethod package)
		ifTrue: [ 
			(self methodSpyAt: previousMethod) registerOutgoingCall: method.
			(self methodSpyAt: method) 
				registerIncomingCall: previousMethod 
				fromReceiver: currentReceiver ] 
		ifFalse: [ (self methodSpyAt: method) incrementNumberOfCalls ]
]

{ #category : #running }
CodeProfiler >> runOn: aReceiver method: aSelector andArguments: args [
	currentReceiver := aReceiver.
	self registerMethodCall: (self lookup: aSelector fromClass: aReceiver class).
	^ super runOn: aReceiver method: aSelector andArguments: args
]

{ #category : #visiting }
CodeProfiler >> visitMessageNode: aNode [
	| dict result |
	dict := self auxVisitMessageNode: aNode.
	currentReceiver := (dict at: #receiver).
	self registerMethodCall: (dict at: #method).
	result := self 
		execute: ((dict at: #method) ast)
		withReceiver: (dict at: #receiver)
		andArguments: (dict at: #args).
	methodCalls pop.
	^ result
]
