# Roblox Character AI StateMachine (Luau)

TBD

A flat StateMachine for managing the creation of controllable characters.
Knowledge representation uses Blackboard architectures.
Modular and allows access to each element individually to support creating building blueprints.

This implementation uses type definition syntax supported by Luau.

This implementation uses a Module-Metatable inheritance model for elements.
A second implementation not requiring metatable inheritance will be added soon.

Currently undergoing testing and debugging.

## Script Organization
The following script organization should be maintained if importing 
this suite into Roblox.

Root/
|--State
|--StateMachine
|--StateTransition
|--Blackboard
|--Action
|--SMTypes
|--SMArgValidation
|--Condition/
   |--AndCondition
   |--OrCondition
   |--NotCondition
   |--ValueCondition

Instructions and samples for use to be added soon.
References and explanations for StateMachine concepts to be added.
UML diagrams will also be added to explain table structure and communication.