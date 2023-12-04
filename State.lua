--[M]odules
local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.SMTypes)

---Represents a State within the StateMachine. This is a stable behaviour for the Agent.
local State = {}
State.__index = State

---Create and return a new State.
---@param stateName string
---@param entryActions table
---@param regActions table
---@param exitActions table
---@return table
function State.New(stateName: string, entryActions: {[number]: SMTypesMod.Action}?,
    regActions: {[number]: SMTypesMod.Action}?, exitActions: {[number]: SMTypesMod.Action}?)

    local self = {}

    SMArgValidationMod.CheckArgumentTypes(
        {'string', 'table', 'table', 'table'},
        {stateName, entryActions, regActions, exitActions},
        'New', 1)

    if entryActions then
        SMArgValidationMod.CheckTableValuesFixedType(
            SMTypesMod.Action, entryActions, 'New', 2)
    end

    if regActions then
        SMArgValidationMod.CheckTableValuesFixedType(
            SMTypesMod.Action, regActions, 'New', 3)
    end

    if exitActions then
        SMArgValidationMod.CheckTableValuesFixedType(
            SMTypesMod.Action, exitActions, 'New', 4)
    end

    self._Type = SMTypesMod.State
    self.StateName = stateName
    self.EntryActions = entryActions or {}
    self.RegularActions = regActions or {}
    self.ExitActions = exitActions or {}
    self.Transitions = {}
    setmetatable(self, State)

    return self
end

---Add a new StateTransition to the State.
---@param newTransition table
function State:AddStateTransition(newTransition: SMTypesMod.StateTransition)
    self = (self :: SMTypesMod.State)

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.StateTransition}, {newTransition}, 'AddStateTransition')

    table.insert(self.Transitions, newTransition)
end

return State