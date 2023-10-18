local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.SMTypes)

--Defines an Action (method, function) to be carried out as part of State behaviour or Transitions.
local Action = {}

---Create and return a new Action instance.
---@param actionName string
---@param actionMethod function
---@return table
function Action.New(actionName: string, actionMethod: (...any) -> nil)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes({'string', 'function'}, {actionName, actionMethod}, 'New')

    self._Type = SMTypesMod.Action
    self.ActionName = actionName
    self.ActionMethod = actionMethod

    return self
end

return Action