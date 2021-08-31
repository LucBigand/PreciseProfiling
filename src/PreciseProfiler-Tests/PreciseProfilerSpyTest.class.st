Class {
	#name : #PreciseProfilerSpyTest,
	#superclass : #TestCase,
	#instVars : [
		'profiler',
		'packageTested',
		'kernelPackage'
	],
	#category : #'PreciseProfiler-Tests'
}

{ #category : #setup }
PreciseProfilerSpyTest >> setUp [
	super setUp.
	packageTested := CHInterpreter package.
	profiler := CodeProfiler new addPackage: packageTested .
	kernelPackage := SmallInteger package.
]

{ #category : #test }
PreciseProfilerSpyTest >> testAddKernelPackageToCodeProfiler [
	| kernelClasses |
	kernelClasses := kernelPackage classes reject: [ :class |
		kernelPackage classExtensionSelectors keys includes: class name ].
	profiler addPackage: kernelPackage.
	kernelClasses do: [ :class |
		self assert: ( profiler classSpyAt: class ) class
			equals: ClassSpy].
	self assert: (profiler packageSpyAt: kernelPackage) classSpies size
		equals: kernelClasses size
]

{ #category : #test }
PreciseProfilerSpyTest >> testClassSpiesCreated [
	packageTested classes do: [ :class |
		self assert: ( profiler classSpyAt: class ) class
			equals: ClassSpy].
	self assert: profiler classSpies size
		equals: packageTested classes size
]

{ #category : #test }
PreciseProfilerSpyTest >> testClassSpiesCreatedForSuperclasses [
	| classes |
	classes :=  packageTested classes select: [ :class |
		 class superclass package == packageTested ].
	classes do: [ :class |
		self assert: ( profiler classSpyAt: class ) superclassSpy
			equals: (profiler classSpyAt: class superclass) ].
]

{ #category : #test }
PreciseProfilerSpyTest >> testInterpreteExponentiation [
	profiler addPackage: kernelPackage.
	self assert: (profiler runOn: 5 method: #** andArguments: #(3))
		equals: 125.
]

{ #category : #test }
PreciseProfilerSpyTest >> testMetaclassSpiesCreated [
	packageTested classes do: [ :class |
		self assert: ( profiler metaclassSpyAt: class ) class
			equals: MetaclassSpy].
	self assert: profiler metaclassSpies size
		equals: packageTested classes size
]

{ #category : #test }
PreciseProfilerSpyTest >> testMethodSpiesCreated [
	packageTested classes do: [ :class | | classSpy |
		classSpy := profiler classSpyAt: class .
		class methods do: [ :method |
			self assert: ( classSpy methodSpyAt: method ) class
				equals: MethodSpy].
		self assert: classSpy methodSpies size
			equals: class methods size ]
]

{ #category : #test }
PreciseProfilerSpyTest >> testPackageSpyCreated [
	self assert: ( profiler packageSpyAt: packageTested ) class
		equals: PackageSpy.
	self assert: profiler packageSpies size
		equals: 1
]
