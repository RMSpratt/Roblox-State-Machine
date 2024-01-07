--[M]odules
local SMArgValidationMod = require(script.Parent.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that all of its child sub-conditions are met.
local AndCondition = {}
AndCondition.__index = AndCondition

---Create and return a new AndCondition.
---@param subconditions table
---@param conditionName string
---@return table
function AndCondition.New(subconditions: {[number]: SMTypesMod.Condition}, conditionName: string?)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes({'table'}, {subconditions}, 'New')
    SMArgValidationMod.CheckTableValuesFixedType(SMTypesMod.Condition, subconditions, 'New', 1)

    self._Type = SMTypesMod.Condition
    self.Name = conditionName
    self.SubConditions = subconditions
    setmetatable(self, AndCondition)

    return self
end

---Test the Compound Condition and any sub-conditions. Return true if all are met.
---@param agentBlackboard table
---@return boolean
function AndCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.CompoundCondition)

    local isMet = true

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.Blackboard}, {agentBlackboard}, 'TestCondition')

    for _, subCondition: SMTypesMod.Condition in self.SubConditions do

        if not subCondition:TestCondition(agentBlackboard) then
            isMet = false
            break
        end
    end

    return isMet
end

return AndCondition