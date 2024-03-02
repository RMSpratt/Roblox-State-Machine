local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that at least one of its child sub-conditions are met.
local OrCondition = {}
OrCondition.__index = OrCondition

---Create and return a new AndCondition.
---@param subconditions table The set of individual Condition objects to be satisifed.
---@param conditionName string A visual identifier for this Condition.
---@return table
function OrCondition.New(subconditions: {[number]: SMTypesMod.Condition}, conditionName: string?)

    local self: SMTypesMod.CompoundCondition = {
        Name = conditionName,
        SubConditions = subconditions,
        TestCondition = OrCondition.TestCondition
    }

    return self
end

---Test the Compound Condition and any sub-conditions. Return true if at least one is met.
---@param agentBlackboard table The Blackboard object defining the Agent's knowledge.
---@return boolean
function OrCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.CompoundCondition)

    local isConditionMet = false

    for _, subCondition: SMTypesMod.Condition in self.SubConditions do

        if subCondition:TestCondition(agentBlackboard) then
            isConditionMet = true
            break
        end
    end

    return isConditionMet
end

return OrCondition