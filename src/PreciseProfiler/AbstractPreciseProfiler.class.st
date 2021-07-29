"
I am an abstract class for profilers that keep a trace of a program's method calls by using an abstract syntaxic tree interpreter.
"
Class {
	#name : #AbstractPreciseProfiler,
	#superclass : #CHInterpreter,
	#category : #'PreciseProfiler-Core'
}

{ #category : #registering }
AbstractPreciseProfiler >> registerMethodCall: aMethod [
	self subclassResponsibility
]

{ #category : #running }
AbstractPreciseProfiler >> runOn: aReceiver method: aSelector [
	^ self runOn: aReceiver method: aSelector andArguments: #()
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
