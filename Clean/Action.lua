local SMTypesMod = require(script.Parent.SMTypes)

--Defines an Action (method, function) to be carried out as part of State behaviour or Transitions.
local Action = {}

---Create and return a new Action instance.
---@param actionName string A visual identifier for the Action's functional behaviour.
---@param actionMethod function
---@return table
function Action.New(actionName: string, actionMethod: (...any) -> nil)

    local self: SMTypesMod.Action = {
        ActionName = actionName,
        ActionMethod = actionMethod
    }

    return self
end

return Action