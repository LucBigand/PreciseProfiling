# PreciseProfiling

PreciseProfiling is a project meant to implement precise profiling tools in Pharo.

Profiling is a discipline of programming that consists in analyzing the
execution of a program or software in order to gather informations
related to its inner behaviour ; these informations can include its
execution time, its memory usage, or the list of all functions or
methods called by this program and the individual behaviour of each
one of them.

We define here precise profiling as a particular type of profiling technique 
in which data is gathered upon execution of a method before being interpreted
as useful information to examine a program's behavior. So far, we've created
profilers for plotting the method call tree of a program and track its
memory usage, code coverage and garbage collection / memory leaks.

Be aware that this is a work in progress, and as such many tools/aspects of
this project are still incomplete or prone to errors, or might not work
in particular circumstances.

## Overview of the implementation

Two techniques have been used to create precise profiling tools during this project :
Abstract syntax tree interpretation and method proxies.

#### Abstract syntax tree interpreter and associated profiling tools

Based on the work of Stéphane Ducasse and Guillermo Polito in "Fun with Interpreters
in Pharo", the package `Champollion-Core` implement a full AST interpreter.
This interpreter is mostly functionnal, although still unexplained problems
of infinite loops still subsist in particular cases. This AST interpreter makes it
possible to simulate the execution of a program without directly executing it
per se. It has been used to create three profiling tools :
* `PreciseProfiler` (tag `Core` of package `PreciseProfiler`) records method calls
when the AST interpreter visits a message node.
* `PreciseMemoryProfiler` (tag `Memory` of package `PreciseProfiler`) records memory
usage when the AST interpreter simulates an object allocation.
* Inspired by the article "
[SPY : A flexible code profiling framework](https://www.sciencedirect.com/science/article/pii/S1477842411000327#:~:text=Spy%20is%20an%20innovative%20framework%20to%20easily%20build,structure%20in%20terms%20of%20packages%2C%20classes%2C%20and%20methods)
",
`PreciseCodeProfiler` (tag `Spy` of package `PreciseProfiler`) records method calls
when the AST interpreter visits a message node, although the exact informations it
extracts from them are different from the ones extracted by `PreciseProfiler`.

#### Method proxies and associated profiling tools

The GitHub project [Method Proxies](https://github.com/tesonep/MethodProxies)
provides tools to decorate and control method executions. It allows
for the modification of a method in the Pharo library so they can
accomplish miscellaneous actions before or after their standard
execution. These tools are called method proxies. It has been used to create
two profiling tools :
* `MpProfilingAdministrator` (package `PreciseProfiler-MethodProxies`)
uses self-propagating handlers to record method calls
* `MpAllocProfilerByEphemeronHandler` (package `EphemeronTest`) uses
[ephemerons](https://www.researchgate.net/publication/221320677_Ephemerons_A_New_Finalization_Mechanism)
to record memory usage and garbage-collecting.

## How to use

`PreciseProfiler` records a complete list of all methods called,
the number of times they have been executed, and a complete tree
of methods called. Here is an example of how to use it :
```
profiler := PreciseProfiler new.
profiler runOn: 3 method: #** andArguments: #(5).
profiler display.
```

`PreciseMemoryProfiler` records the same information than `PreciseProfiler`,
as well as amount of memory used in bytes, number of object allocations,
and a breakdown by class instanciated of direct and indirect memory used and number
of allocations. Here is an example of how to use it :
```
profiler := PreciseMemoryProfiler new.
profiler runOn: Time method: #now.
profiler display.
```

`CodeProfiler` records the code coverage of a program within a package :
methods called, number of different receivers that called each method,
and incoming and outgoing method calls. Here is an example of how to use it :
TODO

`MpProfilingAdministrator` records a complete tree of methods called. Here
is an example of how to use it :
```
admin := MpProfilingAdministrator new.
admin addMethod: Time class >> #now.
admin runOn: [ Time now ].
admin display.
```

`MpAllocationByEphemeronHandler`
```
obj := MyClass new.
block := [ obj createFigures ]. "MyClass>>#createFigures instantiates 15 rectangles but only keep 10 of them in memory"
h := MpAllocProfilerByEphemeronHandler new
addClass: Rectangle;
yourself.
h garbageCollectedObjects. "Should return a set of 5 rectangles"
h notGarbageCollectedObjects. "Should return a set of 10 rectangles"
```

## TODO

As this is a work in progress, several functions need to be fixed or added :
* Solve the problem of infinite loop in some instances of execution of `CHInterpreter`
* Initially, `MpProfilingAdministrator` and `MpAllocationByEphemeronHandler` were
meant to be a single profiling tool single-handedly capable of plotting method call
tree, memory allocation, and garbe-collecting, but it is left unfinished due to
problems with self-propagating handler (they can inadvertently install themselves
onto methods used by the Pharo environment or debugging tools). Solve these problems.
* Create a UI for `CodeProfiler` and `MpAllocationByEphemeronHandler`
* Repackage classes of `EphemeronTest` (its most useful classes should probably be part
of another package).
* Create a tool for profiling not a single program but the entire Pharo environment.
