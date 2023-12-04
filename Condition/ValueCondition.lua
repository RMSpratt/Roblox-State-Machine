--[M]odules
local SMArgValidationMod = require(script.Parent.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.Parent.SMTypes)

--[G]lobals

--Define the set of comparison operators used for ValueCondition instances.
local COMPARISON_OPERATORS = {
    EQ = 1,
    NEQ = 2,
    LT = 3,
    LTE = 4,
    GT = 5,
    GTE = 6
}

--Defines a Condition that is "met" according to the comparison of an expected and actual value.
local ValueCondition = {}
ValueCondition.__index = ValueCondition

---Create and return a new ValueCondition.
---@param testKey string
---@param expectedValue any The value expected for the condition to be satisfied
---@param comparisonOperator number One of a set of comparison operators (EQ=1, NEQ=2, ...)
---@param conditionName string
---@return any
function ValueCondition.New(testKey: string, expectedValue: any, comparisonOperator: number, conditionName: string?)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes(
        {'string', 'any', 'number', 'string'},
        {testKey, expectedValue, comparisonOperator, conditionName}, 'New', 4)

    self._Type = SMTypesMod.Condition
    self.TestKey = testKey
    self.ExpectedValue = expectedValue
    self.ComparisonOperator = comparisonOperator
    self.Name = conditionName or `{testKey}_Condition`
    setmetatable(self, ValueCondition)

    return self
end

---Compare the Condition's expected value against the Blackboard value for the Condition's TestKey.
---@param agentBlackboard table
---@return boolean
function ValueCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.ValueCondition)

    --print("Check ValueCondition for key " .. self.TestKey .. " " .. tostring(agentBlackboard:GetValue(self.TestKey)))
    local isMet = false

    local actualValue = agentBlackboard:GetValue(self.TestKey)

    if actualValue ~= nil then

        SMArgValidationMod.CheckArgumentTypes(
            {SMTypesMod.Blackboard}, {agentBlackboard}, 'TestCondition')

        if self.ComparisonOperator == COMPARISON_OPERATORS.EQ then
            isMet = (actualValue == self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.NEQ then
            isMet = (actualValue ~= self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.LT then
            isMet = (actualValue < self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.LTE then
            isMet = (actualValue <= self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.GT then
            isMet = (actualValue > self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.GTE then
            isMet = (actualValue >= self.ExpectedValue)
        end
    else
        warn(`Requested key {self.TestKey} is not defined in Blackboard {agentBlackboard.Name}.`)
    end

    return isMet
end

--Module table to facilitate creation of ValueCondition instances.
local ValueConditionAccess = {
    ComparisonOperators = COMPARISON_OPERATORS,
    New = ValueCondition.New
}

return ValueConditionAccess