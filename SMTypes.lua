--Defines an Action (method, function) to be carried out for StateMachine Events.
export type Action = {
    _Type: string,
    ActionName: string,
    ActionMethod: (...any) -> nil
}

--Defines an Agent blackboard encompassing all knowledge known to an Agent. Part of a hierarchy.
export type Blackboard = {
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

--Defines a Condition instance within an Agent StateMachine and attached to a StateTransition.
export type Condition = {
    _Type: string,
    Name: string,
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
    SetInitialState: (StateMachine, State) -> nil,
    SetBlackboard: (StateMachine, Blackboard) -> nil
}

--Defines a State instance within an Agent StateMachine.
export type State = {
    _Type: string,
    StateName: string,
    EntryActions: {[number]: Action},
    RegularActions: {[number]: Action},
    ExitActions: {[number]: Action},
    Transitions: {[number]: StateTransition},
}

--Defines a StateTransition instance within an Agent StateMachine and attached to a State.
export type StateTransition = {
    _Type: string,
    TransitionActions: {[number]: Action},
    TransitionCondition: Condition,
    TransitionName: string,
    TargetState: State,
    IsTriggered: (StateTransition, Blackboard) -> boolean,
}

--Defines a sub-type of Condition for Values to be compared.
export type ValueCondition = Condition & {
    ComparisonOperator: number,
    ExpectedValue: any,
    ConditionKey: string,
}

return {
    StateMachine = 0,
    State = 1,
    StateTransition = 2,
    Action = 3,
    Condition = 4,
    Blackboard = 5,
}