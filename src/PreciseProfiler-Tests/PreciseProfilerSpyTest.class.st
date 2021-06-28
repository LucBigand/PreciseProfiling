Class {
	#name : #PreciseProfilerSpyTest,
	#superclass : #TestCase,
	#instVars : [
		'profiler',
		'packageTested'
	],
	#category : #'PreciseProfiler-Tests'
}

{ #category : #setup }
PreciseProfilerSpyTest >> setUp [
	super setUp.
	packageTested := CHInterpreter package.
	profiler := CodeProfiler new addPackage: packageTested .
]

{ #category : #setup }
PreciseProfilerSpyTest >> testClassSpiesCreated [
	packageTested classes do: [ :class |
		self assert: ( profiler classSpyAt: class ) class
			equals: ClassSpy].
	self assert: profiler classSpies size
		equals: packageTested classes size
]

{ #category : #setup }
PreciseProfilerSpyTest >> testClassSpiesCreatedForSuperclasses [
	| classes |
	classes :=  packageTested classes select: [ :class |
		 class superclass package == packageTested ].
	classes do: [ :class |
		self assert: ( profiler classSpyAt: class ) superclassSpy
			equals: (profiler classSpyAt: class superclass) ].
]

{ #category : #setup }
PreciseProfilerSpyTest >> testMetaclassSpiesCreated [
	packageTested classes do: [ :class |
		self assert: ( profiler metaclassSpyAt: class ) class
			equals: MetaclassSpy].
	self assert: profiler metaclassSpies size
		equals: packageTested classes size
]

{ #category : #setup }
PreciseProfilerSpyTest >> testMethodSpiesCreated [
	packageTested classes do: [ :class | | classSpy |
		classSpy := profiler classSpyAt: class .
		class methods do: [ :method |
			self assert: ( classSpy methodSpyAt: method ) class
				equals: MethodSpy].
		self assert: classSpy methodSpies size
			equals: class methods size ]
]

{ #category : #setup }
PreciseProfilerSpyTest >> testPackageSpyCreated [
	self assert: ( profiler packageSpyAt: packageTested ) class
		equals: PackageSpy.
	self assert: profiler packageSpies size
		equals: 1
]
