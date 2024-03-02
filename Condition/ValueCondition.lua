local SMArgValidationMod = require(script.Parent.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.Parent.SMTypes)

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
---@param conditionKey string The unique identifier for the Blackboard key-value to be checked.
---@param expectedValue any The value expected for the condition to be satisfied.
---@param comparisonOperator number One of a set of COMPARISON_OPERATORS.
---@param conditionName string A visual identifier for this Condition.
---@return table
function ValueCondition.New(conditionKey: string, expectedValue: any, comparisonOperator: number, conditionName: string?)
    SMArgValidationMod.CheckArgumentTypes(
        {'string', 'any', 'number', 'string'},
        {conditionKey, expectedValue, comparisonOperator, conditionName}, 'New', 4)

    --Direct assignment is used to match the type definition and allow type inference on return
    local self: SMTypesMod.ValueCondition = {
        _Type = SMTypesMod.Condition,
        ConditionKey = conditionKey,
        ExpectedValue = expectedValue,
        ComparisonOperator = comparisonOperator,
        Name = conditionName,
        TestCondition = ValueCondition.TestCondition
    }

    return self
end

---Compare the Condition's expected value against the Blackboard value for the Condition's TestKey.
---@param agentBlackboard table The Blackboard object defining the Agent's knowledge.
---@return boolean
function ValueCondition:TestCondition(agentBlackboard: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.ValueCondition)

    SMArgValidationMod.CheckArgumentTypes(
            {SMTypesMod.Blackboard}, {agentBlackboard}, 'TestCondition')

    local isConditionMet = false
    local actualValue = agentBlackboard:GetValue(self.ConditionKey)

    if actualValue ~= nil then

        if self.ComparisonOperator == COMPARISON_OPERATORS.EQ then
            isConditionMet = (actualValue == self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.NEQ then
            isConditionMet = (actualValue ~= self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.LT then
            isConditionMet = (actualValue < self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.LTE then
            isConditionMet = (actualValue <= self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.GT then
            isConditionMet = (actualValue > self.ExpectedValue)

        elseif self.ComparisonOperator == COMPARISON_OPERATORS.GTE then
            isConditionMet = (actualValue >= self.ExpectedValue)
        end
    else
        warn(`Requested key {self.ConditionKey} is not defined in Blackboard {agentBlackboard.Name}.`)
    end

    return isConditionMet
end

--Module table to facilitate creation of ValueCondition instances.
local ValueConditionAccess = {
    ComparisonOperators = COMPARISON_OPERATORS,
    New = ValueCondition.New
}

return ValueConditionAccess