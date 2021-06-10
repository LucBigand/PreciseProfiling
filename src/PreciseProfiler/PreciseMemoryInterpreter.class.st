Class {
	#name : #PreciseMemoryInterpreter,
	#superclass : #PreciseInterpreter,
	#category : #PreciseProfiler
}

{ #category : #initialization }
PreciseMemoryInterpreter >> initialize [
	super initialize.
	currentNode childNodeClass: PreciseMemoryNode
]

{ #category : #primitives }
PreciseMemoryInterpreter >> primitiveBasicNew [
	| result |
	result := super primitiveBasicNew.
	self registerAllocation: result.
	^ result
]

{ #category : #registering }
PreciseMemoryInterpreter >> registerAllocation: anObject [
	currentNode addAllocation: anObject
]

{ #category : #running }
PreciseMemoryInterpreter >> runOn: aReceiver method: aSelector andArguments: args [
	| result |
	result := super runOn: aReceiver method: aSelector andArguments: args.
	currentNode childs do: [ :child | child updateMemoryAndAllocation].
	^ result
]

{ #category : #visiting }
PreciseMemoryInterpreter >> visitArrayNode: aNode [
	self registerAllocation: aNode statements asArray.
	^ super visitArrayNode: aNode
]

{ #category : #visiting }
PreciseMemoryInterpreter >> visitLiteralArrayNode: aNode [
	self registerAllocation: aNode contents asArray.
	^ super visitLiteralArrayNode: aNode
]

{ #category : #visiting }
PreciseMemoryInterpreter >> visitLiteralValueNode: aNode [
	| result |
	result := super visitLiteralValueNode: aNode.
	self registerAllocation: result.
	^ result
]
