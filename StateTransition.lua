local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.SMTypes)

--Defines a transition from a source State to a destination State when a Condition is met.
local StateTransition = {}
StateTransition.__index = StateTransition

---Create and return a new StateTransition instance
---@param targetState table The destination State for this StateTransition.
---@param transitionCondition table The Condition that must be satisfied for the Transition to Activate.
---@param transitionActions table The Action methods to execute when the Transition is Activated.
---@param transitionName string A visual identifier for the StateTransition object.
---@return table
function StateTransition.New(targetState: SMTypesMod.State, transitionCondition: SMTypesMod.Condition, transitionActions: {SMTypesMod.Action}?, transitionName: string?)
    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.State, SMTypesMod.Condition, 'table', 'string'},
        {targetState, transitionCondition, transitionActions, transitionName}, 'New')

    --Direct assignment is used to match the type definition and allow type inference on return
    local self: SMTypesMod.StateTransition = {
        _Type = SMTypesMod.StateTransition,
        TransitionActions = transitionActions,
        TransitionCondition = transitionCondition,
        TransitionName =  transitionName,
        TargetState = targetState,
        IsTriggered = StateTransition.IsTriggered
    }

    return self
end

---Evaluate the Condition tied to this StateTransition and return its satisfied truth value.
---@return boolean
function StateTransition:IsTriggered(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.StateTransition)

    return self.TransitionCondition:TestCondition(agentBlackboard)
end

return StateTransition