--Defines an Action (method, function) to be carried out for StateMachine Events.
export type Action = {
    _Type: string,
    ActionName: string,
    ActionMethod: () -> nil
}

--Defines an Agent blackboard encompassing all knowledge known to an Agent. Part of a hierarchy.
export type Blackboard = {
    _Type: string,
    Name: string,
    Parent: Blackboard,
    Entries: {[string]: any},
    AddEntry: (self: Blackboard, entryKey: string, entryValue: any) -> nil,
    Clone: (self: Blackboard) -> Blackboard,
    GetName: (self: Blackboard) -> string,
    GetValue: (self: Blackboard, entryKey: string) -> any,
    GetValueLocal: (self: Blackboard, entryKey: string) -> any,
    SetParent: (self: Blackboard, parent: Blackboard) -> nil,
    SetValue: (self: Blackboard, entryKey: string, newValue: any) -> boolean,
    SetValueLocal: (self: Blackboard, entryKey: string, newValue: any) -> boolean,
}

--Defines a Condition instance within an Agent StateMachine and attached to a StateTransition.
export type Condition = {
    _Type: string,
    Name: string,
    Parent: Condition,
    TestCondition: (Condition, Blackboard) -> boolean
}

--Defines a sub-type of Condition for aggregating sub-conditions.
export type CompoundCondition = Condition & {
    SubConditions: {[number]: Condition},
}

--Defines a StateMachine for controlling an agent.
export type StateMachine = {
    _Type: string,
    AgentName: string,
    AnyStateTransitions: {[number]: StateTransition},
    AgentBlackboard: Blackboard,
    CurrentState: State,
    EntryActions: {[number]: Action},
    ExitActions: {[number]: Action},
    GlobalActions: {[number]: Action},
    InitialState: State,
    AddAnyTransition: (self: StateMachine, anyTransition: StateTransition) -> nil,
    GetActions: (self: StateMachine) -> {[number]: Action},
    GetName: (self: StateMachine) -> string,
    SetInitialState: (self: StateMachine, initialState: State) -> nil,
    SetBlackboard: (self: StateMachine, agentBlackboard: Blackboard) -> nil
}

--Defines a State instance within an Agent StateMachine.
export type State = {
    _Type: string,
    StateName: string,
    EntryActions: {[number]: Action},
    RegularActions: {[number]: Action},
    ExitActions: {[number]: Action},
    Transitions: {[number]: StateTransition},
    AddTransition: (self: State, newTransition: StateTransition) -> nil,
}

--Defines a StateTransition instance within an Agent StateMachine and attached to a State.
export type StateTransition = {
    _Type: string,
    TransitionActions: {[number]: Action},
    TransitionCondition: Condition,
    TransitionName: string,
    TargetState: State,
    IsTriggered: (self: StateTransition, agentBlackboard: Blackboard) -> boolean,
}

--Defines a sub-type of Condition for Values to be compared.
export type ValueCondition = Condition & {
    ComparisonOperator: number,
    ExpectedValue: any,
    TestKey: string,
}

return {
    StateMachine = 0,
    State = 1,
    StateTransition = 2,
    Action = 3,
    Condition = 4,
    Blackboard = 5,
}