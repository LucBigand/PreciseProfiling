"
I am the root node of a tree of nodes representing the method call context of a program.

I am myself an empty node, in that I don't register a method. However, all my childs and descendents do.
"
Class {
	#name : #PreciseRoot,
	#superclass : #AbstractPreciseNode,
	#category : #PreciseProfiler
}

{ #category : #setting }
PreciseRoot >> childNodeClass: aClass [
	childNodeClass := aClass 
]
