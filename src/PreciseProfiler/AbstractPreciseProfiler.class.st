Class {
	#name : #AbstractPreciseProfiler,
	#superclass : #CHInterpreter,
	#category : #PreciseProfiler
}

{ #category : #registering }
AbstractPreciseProfiler >> registerMethodCall: aMethod [
	self subclassResponsibility
]

{ #category : #running }
AbstractPreciseProfiler >> runOn: aClass method: aSelector [
	^ self runOn: aClass method: aSelector andArguments: #()
]

{ #category : #running }
AbstractPreciseProfiler >> runOn: aReceiver method: aSelector andArguments: args [
	"Runs this interpreter on a program composed of aReveiver, aSelector, and arguments args
	Example : The program '3 ** 5' is called with aReceiver = 3, aSelector = #**, and args = #(5)"
	| ast method res |
	method := (self lookup: aSelector fromClass: aReceiver class).
	ast := method parseTree.
	self registerMethodCall: method.
	res := self execute: ast withReceiver: aReceiver andArguments: args.
	^ res
]
