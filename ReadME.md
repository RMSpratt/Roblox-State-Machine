# Roblox Character AI StateMachine (Luau)

A flat StateMachine for managing the creation of controllable characters.
Knowledge representation is based on a Blackboard architecture.
Design is to be modular supporting building-block component creation.

This implementation uses type definition syntax supported by Luau.
This implementation uses a ModuleScript-Metatable model for components.

## Script Organization
The following script organization should be maintained if importing 
this suite into Roblox.

```
Root/
|-- State
|-- StateMachine
|-- StateTransition
|-- Blackboard
|-- Action
|-- SMTypes
|-- SMArgValidation
|-- Condition/
    |-- AndCondition
    |-- OrCondition
    |-- NotCondition
    |-- ValueCondition
```

## Components
A brief explanation of each component ModuleScript is outlined below.
These are organized from Top --> Bottom, with the larger components explained first.

### StateMachine
This represents the Agent's full encapsulated AI behaviour.
This contains a set of States, StateTransitions, Actions, and Conditions.

Agent Behaviour is defined as a set of functions returned when performing a StateMachine update.
The GetActions method of a StateMachine returns this list of functions to execute.
The GetActions method of a StateMachine also updates an active State according to StateTransitions.

When entering a StateMachine without an active State, its InitialState is entered by default.

**Note:**
StateMachines in this framework support StateTransitions to be checked for *any* active state.
These can be triggered multiple times so long as their Condition is continually met.
Use these with caution to avoid accidentally repeating behaviour. (AnyStateTransitions)

```lua
type StateMachine = {
    _Type: string,
    AgentName: string,
    AnyStateTransitions: {StateTransition},
    AgentBlackboard: Blackboard,
    CurrentState: State,
    EntryActions: {Action},
    ExitActions: {Action},
    GlobalActions: {Action},
    InitialState: State,
    States: {State},
    GetActions: (StateMachine) -> {Action},
    GetName: (StateMachine) -> string,
}
```

The StateMachine Module contains two methods for editing StateMachines after creation.

```lua
    SetInitialState: (StateMachine, State) -> nil,
    SetBlackboard: (StateMachine, Blackboard) -> nil
```


### State
These represent repeated behaviour exhibited by AI-controlled agents.
A set of Actions, a State's "RegularActions" are executed every StateMachine Update.

```lua
type State = {
    _Type: string,
    StateName: string,
    EntryActions: {[number]: Action},
    RegularActions: {[number]: Action},
    ExitActions: {[number]: Action},
    Transitions: {[number]: StateTransition},
    AddStateTransition: (State, StateTransition) -> nil,
} 
```

The State Module contains one method for editing States after creation to facilitate the process.

```lua
    AddStateTransition: (State, StateTransition) -> nil,
```


### StateTransition
These represent links between an Agent's States as dynamic behaviour.
Agent's can have at most one active StateTransition at a time.

All StateTransitions are defined with a pre-created State as its Target.
The Source State holds the StateTransition as part of its definition.

A StateTransition is activated when IsTriggered evaluates to true.
This value is determined by checking the StateTransition's sole Condition object.

```lua
type StateTransition = {
    _Type: string,
    TransitionActions: {[number]: Action},
    TransitionCondition: Condition,
    TransitionName: string,
    TargetState: State,
    IsTriggered: (StateTransition, Blackboard) -> boolean,
}
```


### Condition
Conditions are used in triggering a StateTransition.

Conditions come in two primary categories: Aggregate and Value.
All types of Conditions have a method, TestCondition, to evaluate if they are met.

Conditions can be organized in hierarchies, creating Condition Trees.
A StateTransition will store reference to only the 'root' Condition.

```lua
type Condition = {
    _Type: string,
    Name: string,
    Parent: Condition,
    TestCondition: (Condition, Blackboard) -> boolean
}
```

#### ValueCondition
ValueCondition objects are those that evaluate the truth of *one* condition by value comparison.
The value to check is set at creation and corresponds to one found within an Agent's Blackboard.

```lua
type ValueCondition = Condition & {
    ComparisonOperator: number,
    ExpectedValue: any,
    TestKey: string,
}
```

#### AndCondition
AndCondition objects evaluate the truthiness of two or more sub-conditions. (Aggregate)
AndCondition objects return true iff *ALL* of the sub-conditions evaluate to true.

#### OrCondition
OrCondition objects evaluate the truthiness of two or more sub-conditions. (Aggregate)
OrCondition objects return true iff *ANY* of the sub-conditions evaluate to true.

#### NotCondition
NotCondition objects invert the truthiness of a sub-condition.
NotCondition objects return true iff the sub-condition evaluates to false.


## Action
Actions are behaviours executed by Agents within States and StateTransitions.
Actions correspond to a function defined outside of the StateMachine itself.

**Note:**
Action methods *must not* return values. Returned values are not used or considered.

```lua
type Action = {
    _Type: string,
    ActionName: string,
    ActionMethod: (...any) -> nil
}
```

### Blackboard
Blackboards define the full set of knowledge available to an Agent.
Blackboards consist of {key, value} pairs and support storage of any type of value (except nil).

Blackboards support knowledge sharing in a hierarchical manner.
Blackboards can have a single Parent to query for keys not found locally.

**Note:**
Blackboards in this framework support local-value getting and setting to ignore inherited keys.
These features are in-support of testing for missing information, but should be used carefully.

```lua
type Blackboard = {
    _Type: string,
    Name: string,
    Parent: Blackboard,
    Entries: {[string]: any},
    AddEntry: (Blackboard, string, any) -> nil,
    Clone: (Blackboard) -> Blackboard,
    GetName: ( Blackboard) -> string,
    GetValue: (Blackboard, string) -> any,
    GetValueLocal: (Blackboard, string) -> any,
    SetParent: (Blackboard, Blackboard) -> nil,
    SetValue: (Blackboard, string, any) -> boolean,
    SetValueLocal: (Blackboard, string, any) -> boolean,
}
```


## Additional Notes

### Implementation Quirks

#### Extending Behaviour
While the StateMachine components can be modified after creation through direct key-value access,
this can easily lead to an invalid StateMachine if not done with caution.

Dynamic behaviour for an individual State Machine is intended through setting values of an 
Agent's Blackboard at run-time.

More sophisticated behaviours for Agents is recommended by instead extending behaviour, i.e.
- Defining a Hierarchical State Machine
- Using a higher-level Hierarchical Task Planner
- Using a Behaviour Tree within States
- etc.

#### Type Definitions
The approach for type definitions in this framework has a unified source for type access (SMTypes).
(Instead of using setmetatable for type definitions within each Module).

This was done to help prevent excessive Module requirements among StateMachine components, while
still supporting type inference and to satisfy strict type checking.


### Wishlist (Features)
- I hope to add some visual diagrams soon to illustrate how the components tie together.
- I am working on an example to include with this framework.
- I am working on an alternate implementation for StateMachine access.

- StateMachine components (i.e. States) can technically be edited after creation. 
    - This is not recommended behaviour.

- A Hierarchical StateMachine framework implementation may be added in the near future.