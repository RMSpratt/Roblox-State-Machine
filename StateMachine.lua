--[M]odules
local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod =  require(script.Parent.SMTypes)

--Defines a flat StateMachine for an Agent to control its AI behaviour.
local StateMachine = {}
StateMachine.__index = StateMachine

---Create and return a new StateMachine to run Agent behaviour.
---@param stateMachineName string
---@param states table
---@param entryActions table
---@param globalActions table
---@param exitActions table
---@return table
function StateMachine.New(stateMachineName: string, states: {SMTypesMod.State},
    blackboard: SMTypesMod.Blackboard, entryActions: {SMTypesMod.Action}?,
    globalActions: {SMTypesMod.Action}?, exitActions: {SMTypesMod.Action}?,
    anyStateTransitions: {SMTypesMod.StateTransition}?)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes(
        {'string', SMTypesMod.Blackboard, 'table', 'table', 'table', 'table', 'table'},
        {stateMachineName, blackboard, states, entryActions,
        globalActions, exitActions, anyStateTransitions},
        'New', 2)

    SMArgValidationMod.CheckTableValuesFixedType(SMTypesMod.State, states, 'New', 2)

    if entryActions then
        SMArgValidationMod.CheckTableValuesFixedType(SMTypesMod.Action, entryActions, 'New', 3)
    end

    if globalActions then
        SMArgValidationMod.CheckTableValuesFixedType(SMTypesMod.Action, globalActions, 'New', 4)
    end

    if exitActions then
        SMArgValidationMod.CheckTableValuesFixedType(SMTypesMod.Action, exitActions, 'New', 5)
    end

    if anyStateTransitions then
        SMArgValidationMod.CheckTableValuesFixedType(
            SMTypesMod.StateTransition, anyStateTransitions, 'New', 6)

        for transitionIdx, transition in ipairs(anyStateTransitions) do
            if not table.find(states, transition.TargetState) then
                error(
                    `invalid value for key 'TargetState' index #{transitionIdx}` ..
                    ` in argument #6 to 'New'. State must be present in StateMachine.`)
            end
        end
    end

    self._Type = SMTypesMod.StateMachine
    self.AgentName = stateMachineName
    self.AgentBlackboard = blackboard
    self.AnyStateTransitions = {}
    self.States = states
    self.EntryActions = entryActions or {}
    self.ExitActions = exitActions or {}
    self.GlobalActions = globalActions or {}
    self.AnyStateTransitions = anyStateTransitions or {}
    setmetatable(self, StateMachine)

    return self
end

---Get Agent behaviour actions for the current State.
function StateMachine:GetActions()
    self = (self :: SMTypesMod.StateMachine)

    local agentActions = {}
    local triggerTransition: SMTypesMod.StateTransition = nil

    --Entering the StateMachine
    if not self.CurrentState then
        self.CurrentState = self.InitialState

        for _, action in self.EntryActions do
            table.insert(agentActions, action)
        end

        for _, action in self.InitialState.EntryActions do
            table.insert(agentActions, action)
        end

        return agentActions
    end

    --Check for AnyState Transitions
    for _, anyStateTransition in self.AnyStateTransitions do

        if anyStateTransition:IsTriggered(self.AgentBlackboard) then
            triggerTransition = anyStateTransition
            break
        end
    end

    --Check for Transitions from the Current State to a new State
    if not triggerTransition then

        for _, transition in self.CurrentState.Transitions do

            if transition:IsTriggered(self.AgentBlackboard) then
                triggerTransition = transition
                break
            end
        end
    end

    --Get all Actions according to the triggered StateTransition
    if triggerTransition then

        for _, stateExitAction in self.CurrentState.ExitActions do
            table.insert(agentActions, stateExitAction)
        end

        for _, transitionAction in triggerTransition.TransitionActions do
            table.insert(agentActions, transitionAction)
        end

        --Transitioning to a new State
        if triggerTransition.TargetState ~= nil then

            for _, stateEntryAction in triggerTransition.TargetState.EntryActions do
                table.insert(agentActions, stateEntryAction)
            end

        --Exiting the StateMachine
        else

            for _, globalExitAction in self.ExitActions do
                table.insert(agentActions, globalExitAction)
            end
        end

        self.CurrentState = triggerTransition.TargetState

    --No new Transitions, return current State behaviour
    else

        for _, stateAction in self.CurrentState.RegularActions do
            table.insert(agentActions, stateAction)
        end
    end

    return agentActions
end

---Return the name of the agent associated with this StateMachine.
function StateMachine:GetName()
    self = (self :: SMTypesMod.StateMachine)

    return self.AgentName
end

---Set the Blackboard to be used by the StateMachine for checking Conditions.
---@param agentBlackboard table
function StateMachine:SetBlackboard(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.StateMachine)
    self.AgentBlackboard = agentBlackboard
end

---Set the initial state or entry state for this StateMachine.
---@param initialState table
function StateMachine:SetInitialState(initialState: SMTypesMod.State)
    self = (self :: SMTypesMod.StateMachine)

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.State}, {initialState}, 'SetInitialState')

    if not table.find(self.States, initialState) then
        error(`argument #1 for initialState must exist within the StateMachine {self.AgentName}.`)
    end

    self.InitialState = initialState
end

return StateMachine