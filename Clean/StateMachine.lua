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

    local self: SMTypesMod.StateMachine = {
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

    for _, anyStateTransition in self.AnyStateTransitions do

        if anyStateTransition:IsTriggered(self.AgentBlackboard) then
            triggerTransition = anyStateTransition
            break
        end
    end

    if not triggerTransition then

        for _, transition in self.CurrentState.Transitions do

            if transition:IsTriggered(self.AgentBlackboard) then
                triggerTransition = transition
                break
            end
        end
    end

    if triggerTransition then

        for _, stateExitAction in self.CurrentState.ExitActions do
            table.insert(agentActions, stateExitAction)
        end

        for _, transitionAction in triggerTransition.TransitionActions do
            table.insert(agentActions, transitionAction)
        end

        if triggerTransition.TargetState ~= nil then

            for _, stateEntryAction in triggerTransition.TargetState.EntryActions do
                table.insert(agentActions, stateEntryAction)
            end

        else

            for _, globalExitAction in self.ExitActions do
                table.insert(agentActions, globalExitAction)
            end
        end

        self.CurrentState = triggerTransition.TargetState

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
    agentSM.InitialState = initialState
end

return StateMachine