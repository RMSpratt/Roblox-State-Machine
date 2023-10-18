local SMArgValidationMod = require(script.Parent.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.Parent.SMTypes)

---Condition Type that verifies that all of its child sub-conditions are met.
local OrCondition = {}
OrCondition.__index = OrCondition

---Create and return a new AndCondition.
---@param subconditions table
---@return table
function OrCondition.New(subconditions: {[number]: SMTypesMod.Condition})
    local self = {}

    SMArgValidationMod.CheckArgumentTypes({'table'}, {subconditions}, 'New')
    SMArgValidationMod.CheckTableValuesFixedType(SMTypesMod.Condition, subconditions, 'New', 1)

    self._Type = SMTypesMod.Condition
    self.SubConditions = subconditions
    setmetatable(self, OrCondition)

    return self
end

---Test the Compound Condition and any sub-conditions. Return true if at least one is met.
---@param agentBlackboard table
---@return boolean
function OrCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.CompoundCondition)
    local isMet = false

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.Blackboard}, {agentBlackboard}, 'TestCondition')

    for _, subCondition: SMTypesMod.Condition in self.SubConditions do

        if subCondition:TestCondition() then
            isMet = true
            break
        end
    end

    return isMet
end

return OrCondition