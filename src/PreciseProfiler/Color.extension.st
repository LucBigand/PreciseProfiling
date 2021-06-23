Extension { #name : #Color }

{ #category : #'*PreciseProfiler' }
Color >> reverseTranslucence [
	self isTranslucent
		ifTrue: [ ^ self beOpaque ]
		ifFalse: [ ^ self translucent ].
]
