--[M]odules
local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.SMTypes)

--Defines a transition from a source State to a destination State when a Condition is met.
local StateTransition = {}
StateTransition.__index = StateTransition

---Create and return a new StateTransition instance
---@param targetState table The destination State when this StateTransition is triggered
---@param transitionCondition table The Condition that must be met for the transition to fire
---@param transitionActions table The list of Actions that are executed when the Transition's Condition is Met
---@param transitionName string An identifier for the transition's purpose
---@return table
function StateTransition.New(targetState: SMTypesMod.State, transitionCondition: SMTypesMod.Condition, transitionActions: {SMTypesMod.Action}?, transitionName: string?)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.State, SMTypesMod.Condition, SMTypesMod.Action, 'string'},
        {targetState, transitionCondition, transitionActions, transitionName}, 'New', 3)

    self._Type = SMTypesMod.StateTransition
    self.TransitionActions = {}
    self.TransitionCondition = transitionCondition
    self.TransitionName = transitionName or `to_{targetState.StateName}`
    self.TargetState = targetState
    setmetatable(self, StateTransition)

    return self
end

---Check this state's transition and see if its condition has been met.
---@return boolean
function StateTransition:IsTriggered(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.StateTransition)

    return self.TransitionCondition:TestCondition(agentBlackboard)
end

return StateTransition