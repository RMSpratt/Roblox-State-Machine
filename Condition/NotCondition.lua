local SMArgValidationMod = require(script.Parent.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that all of its child sub-conditions are met.
local NotCondition = {}
NotCondition.__index = NotCondition

---Create and return a new NotCondition.
---@param subcondition table The Condition object to be satisifed.
---@param conditionName string
---@return table
function NotCondition.New(subcondition: SMTypesMod.Condition, conditionName: string?)
    SMArgValidationMod.CheckArgumentTypes({SMTypesMod.Condition}, {subcondition}, 'New')

    --Direct assignment is used to match the type definition and allow type inference on return
    local self: SMTypesMod.CompoundCondition = {
        _Type = SMTypesMod.Condition,
        Name = conditionName,
        SubConditions = {subcondition},
        TestCondition = NotCondition.TestCondition
    }

    return self
end

---Test the condition's sub-condition and return the opposite of the sub-condition's isMet value.
---@param agentBlackboard table
---@return boolean
function NotCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.CompoundCondition)

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.Blackboard}, {agentBlackboard}, 'TestCondition')

    return not self.SubConditions[1]:TestCondition(agentBlackboard)
end

return NotCondition