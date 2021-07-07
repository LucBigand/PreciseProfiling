Class {
	#name : #BaselineOfPreciseProfiler,
	#superclass : #BaselineOf,
	#category : #BaselineOfPreciseProfiler
}

{ #category : #baselines }
BaselineOfPreciseProfiler >> baseline: spec [
	<baseline>
	
	
		spec for: #'common' do: [
			spec package: 'Champollion-Core'.
			spec package: 'Champollion-Tests' with: [ spec requires: #('Champollion-Core') ].
			spec package: 'PreciseProfiler' with: [ spec requires: #('Champollion-Core') ].
			spec package: 'PreciseProfiler-Spy' with: [ spec requires: #('PreciseProfiler') ].
			spec package: 'PreciseProfiler-Tests' with: [ spec requires: #('PreciseProfiler-Spy') ] .
		
		]
]