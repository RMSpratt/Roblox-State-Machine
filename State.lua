local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.SMTypes)

---Represents a State within the StateMachine. Encompasses some stable behaviour for the Agent.
local State = {}
State.__index = State

---Create and return a new State.
---@param stateName string A visual identifier for the State object.
---@param entryActions table The set of Action methods to invoke once when entering the State.
---@param regActions table The set of Action methods to invoke while present within the State.
---@param exitActions table The set of Action methods to invoke once when exiting the State.
---@return table
function State.New(stateName: string, entryActions: {[number]: SMTypesMod.Action}?,
    regActions: {[number]: SMTypesMod.Action}?, exitActions: {[number]: SMTypesMod.Action}?)

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

    local self: SMTypesMod.State = {
        _Type = SMTypesMod.State,
        StateName = stateName,
        EntryActions = entryActions or {},
        RegularActions = regActions or {},
        ExitActions = exitActions or {},
        Transitions = {},
    }

    return self
end

---Add a new StateTransition that leads out of the passed State.
---@param exitTransition table The exiting StatTransition.
function State.AddStateTransition(state: SMTypesMod.State, exitTransition: SMTypesMod.StateTransition)

    SMArgValidationMod.CheckArgumentTypes(
        {SMTypesMod.StateTransition}, {exitTransition}, 'AddStateTransition')

    table.insert(state.Transitions, exitTransition)
end

return State