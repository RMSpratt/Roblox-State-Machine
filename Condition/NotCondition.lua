local SMArgValidationMod = require(script.Parent.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that all of its child sub-conditions are met.
local NotCondition = {}
NotCondition.__index = NotCondition

---Create and return a new NotCondition.
---@param subcondition table
---@return table
function NotCondition.New(subcondition: SMTypesMod.Condition)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes({SMTypesMod.Condition}, {subcondition}, 'New')
    self._Type = SMTypesMod.Condition
    setmetatable(self, NotCondition)

    table.insert(self.SubConditions, subcondition)

    return self
end

---Test the condition's sub-condition and return the opposite of the sub-condition's isMet value.
---@param agentBlackboard table
---@return boolean
function NotCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.CompoundCondition)

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.Blackboard}, {agentBlackboard}, 'TestCondition')

    return not self.SubConditions[1]:TestCondition()
end

return NotCondition