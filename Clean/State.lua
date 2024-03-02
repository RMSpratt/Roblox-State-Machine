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

    local self: SMTypesMod.State = {
        StateName = stateName,
        EntryActions = entryActions or {},
        RegularActions = regActions or {},
        ExitActions = exitActions or {},
        Transitions = {},
    }

    return self
end

---Add a new StateTransition that leads out of the passed State.
---@param state The State to modify.
---@param exitTransition table The exiting StateTransition.
function State.AddStateTransition(state: SMTypesMod.State, exitTransition: SMTypesMod.StateTransition)
    table.insert(state.Transitions, exitTransition)
end

return State