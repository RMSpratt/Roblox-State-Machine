local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that all of its child sub-conditions are met.
local NotCondition = {}
NotCondition.__index = NotCondition

---Create and return a new NotCondition.
---@param subcondition table The Condition object to be satisifed.
---@param conditionName string
---@return table
function NotCondition.New(subcondition: SMTypesMod.Condition, conditionName: string?)

    local self: SMTypesMod.CompoundCondition = {
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

    return not self.SubConditions[1]:TestCondition(agentBlackboard)
end

return NotCondition