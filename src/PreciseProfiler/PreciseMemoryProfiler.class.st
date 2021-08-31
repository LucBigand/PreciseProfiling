"
I am a type of PreciseInterpreter that also registers informations pertaining to the objects that the program I am running has allocated : their class, number, and memory used. My tree of nodes is composed of a PreciseRoot and instances of PreciseMemoryNode

Example :

profiler := PreciseMemoryProfiler new.
profiler runOn: Time method: #now.
profiler display.
"
Class {
	#name : #PreciseMemoryProfiler,
	#superclass : #PreciseProfiler,
	#category : #'PreciseProfiler-Memory'
}

{ #category : #initialization }
PreciseMemoryProfiler >> initialize [
	super initialize.
	currentNode childNodeClass: PreciseMemoryNode
]

{ #category : #primitives }
PreciseMemoryProfiler >> primitiveBasicNew [
	| result |
	result := super primitiveBasicNew.
	self registerAllocation: result.
	^ result
]

{ #category : #registering }
PreciseMemoryProfiler >> registerAllocation: anObject [
	currentNode addAllocation: anObject
]

{ #category : #running }
PreciseMemoryProfiler >> runOn: aReceiver method: aSelector andArguments: args [
	| result |
	result := super runOn: aReceiver method: aSelector andArguments: args.
	currentNode childs do: [ :child | child update].
	^ result
]

{ #category : #visiting }
PreciseMemoryProfiler >> visitArrayNode: aNode [
	self registerAllocation: aNode statements asArray.
	^ super visitArrayNode: aNode
]

{ #category : #visiting }
PreciseMemoryProfiler >> visitLiteralArrayNode: aNode [
	"self registerAllocation: aNode contents asArray."
	^ super visitLiteralArrayNode: aNode
]

{ #category : #visiting }
PreciseMemoryProfiler >> visitLiteralValueNode: aNode [
	| result |
	result := super visitLiteralValueNode: aNode.
	"self registerAllocation: result."
	^ result
]
