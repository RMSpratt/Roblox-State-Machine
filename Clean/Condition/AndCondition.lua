local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that all of its child sub-conditions are met.
local AndCondition = {}
AndCondition.__index = AndCondition

---Create and return a new AndCondition.
---@param subconditions table The set of individual Condition objects to be satisifed.
---@param conditionName string A visual identifier for this Condition.
---@return table
function AndCondition.New(subconditions: {[number]: SMTypesMod.Condition}, conditionName: string?)

    local self: SMTypesMod.CompoundCondition = {
        Name = conditionName,
        SubConditions = subconditions,
        TestCondition = AndCondition.TestCondition
    }

    return self
end

---Test the Compound Condition and any sub-conditions. Return true if all are met.
---@param agentBlackboard table The Blackboard object defining the Agent's knowledge.
---@return boolean
function AndCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.CompoundCondition)

    local isConditionMet = true

    for _, subCondition: SMTypesMod.Condition in self.SubConditions do

        if not subCondition:TestCondition(agentBlackboard) then
            isConditionMet = false
            break
        end
    end

    return isConditionMet
end

return AndCondition