local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod =  require(script.Parent.SMTypes)

--Defines a flat StateMachine for an Agent to control its AI behaviour.
local StateMachine = {}
StateMachine.__index = StateMachine

---Create and return a new StateMachine to run Agent behaviour.
---@param states table The set of State objects that exist within the StateMachine.
---@param blackboard table The Blackboard object defining the Agent's knowledge.
---@param stateMachineName string A visual identifier for the Agent StateMachine.
---@param initialState table The entrypoint State for the StateMachine.
---@param entryActions table The set of Action methods to invoke once when entering the StateMachine.
---@param globalActions table The set of Action methods to invoke while present within the StateMachine.
---@param exitActions table The set of Action methods to invoke once when exiting the StateMachine.
---@param anyStateTransitions table The set of StateTransitions checked while in the StateMachine.
---@return table
function StateMachine.New(states: {SMTypesMod.State}, blackboard: SMTypesMod.Blackboard,
    stateMachineName: string, initialState: SMTypesMod.State, entryActions: {SMTypesMod.Action}?,
    globalActions: {SMTypesMod.Action}?,exitActions: {SMTypesMod.Action}?,
    anyStateTransitions: {SMTypesMod.StateTransition}?)

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

    local self: SMTypesMod.StateMachine = {
            _Type = SMTypesMod.StateMachine,
            AgentName = stateMachineName,
            AgentBlackboard = blackboard,
            AnyStateTransitions = anyStateTransitions or {},
            CurrentState = nil,
            InitialState = nil,
            States = states,
            EntryActions = entryActions or {},
            ExitActions = exitActions or {},
            GlobalActions = globalActions or {},
            GetActions = StateMachine.GetActions,
            GetName = StateMachine.GetName
        }

    StateMachine.SetInitialState(self, initialState)

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

---Sets the Blackboard object defining the StateMachine's source of knowledge.
---@param agentSM table The StateMachine to be modified.
---@param agentBlackboard table The Blackboard object defining the Agent's knowledge.
function StateMachine.SetBlackboard(agentSM: SMTypesMod.StateMachine, agentBlackboard: SMTypesMod.Blackboard)
    agentSM.AgentBlackboard = agentBlackboard
end

---Sets the Initial State for the StateMachine.
---@param agentSM table The StateMachine to be modified.
---@param initialState table The State immediately entered for new entry to this StateMachine.
function StateMachine.SetInitialState(agentSM: SMTypesMod.StateMachine, initialState: SMTypesMod.State)

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.State}, {initialState}, 'SetInitialState')

    if not table.find(agentSM.States, initialState) then
        error(`argument #1 for initialState must exist within the StateMachine {agentSM.AgentName}.`)
    end

    agentSM.InitialState = initialState
end

return StateMachine