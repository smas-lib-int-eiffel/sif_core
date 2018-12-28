# System Interface Framework - SIF - Core


----
## What is System?
The individual components of object oriented software construction are classes. To obtain executable code, we must assemble classes into systems.
We define that executable code is a **system**.


A **system** only has meaning when it is able to exchange information which can be processed by humans or other systems.

Humans and other systems looking from the perspective of the software **system** are external.

----
## What is Interface?
The possible information exchange between the system and the external outside world is defined as the **interface** of the system, system interface for short.

The second word of the system **interface** framework has this meaning.

----
## What is Framework?
The object oriented method allows us to build reusable modules that still have replaceable, not completely frozen elements models that serve as general schemes and can be adapted to various specific situations. When deferred or abstract classes are used and combined with the  idea  off components  intended to work together we call this a **framework**.

This is what the third word means of the system interface **framework**.

Frameworks offer a remarkable way of reconciling reusability with adaptability.

----
## What is SIF?
**S**ystem **I**nterface **F**ramework is abbreviated as **SIF**

----
## What is SIF Core?
This is what the core library of the system interface framework has to offer for software systems in general. Note that this library is **abstract** and only contains a model and design for the following **basic concepts**:

* event driven interaction model

* reusable behaviour

* input validation

* abstract security based on permissions

* defined initialization and launch

----
## How to create a concrete system from SIF Core?
To create a system (executable code) with SIF Core, classes need to be written which are referencing classes from SIF Core, by using inheritance and client relationships. At least the following classes have to be made concrete:

* inherit a class from PRODUCT

* inherit a class from SYSTEM_INTERFACE

* inherit a class from COMMAND

