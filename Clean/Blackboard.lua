local SMTypesMod = require(script.Parent.SMTypes)

--Defines a data structure representing all of the agent's knowledge about the Environment.
local Blackboard = {}
Blackboard.__index = Blackboard

---Create and return a new Blackboard
---@param blackboardName string A visual identifier for the Blackboard object.
---@return table
function Blackboard.New(blackboardName: string)

    --Direct assignment is used to match the type definition and allow type inference on return
    local self: SMTypesMod.Blackboard = {
        Name = blackboardName,
        Entries = {},
        Parent = nil,
        AddEntry = Blackboard.AddEntry,
        Clone = Blackboard.Clone,
        GetName = Blackboard.Clone,
        GetValue = Blackboard.GetValue,
        GetValueLocal = Blackboard.GetValueLocal,
        SetValue = Blackboard.SetValue,
        SetValueLocal = Blackboard.SetValueLocal,
        SetParent = Blackboard.SetParent,
    }

    return self
end

---Add a BlackboardEntry to the Blackboard.
---@param entryName string The key (name) for the BlackboardEntry to be added.
---@param entryValue any The value for the BlackboardEntry to be added.
function Blackboard:AddEntry(entryName: string, entryValue: any)
    self = (self :: SMTypesMod.Blackboard)

    if self.Entries[entryName]  ~= nil then
        error(
            `argument #1 to 'AddEntry' {entryName} already exists in Blackboard`)
        return
    end

    self.Entries[entryName] = entryValue
end

---Create a shallow copy of this Blackboard with all of its entries and the same parent reference.
---@return table
function Blackboard:Clone()
    self = (self :: SMTypesMod.Blackboard)

    local blackboardCopy = {
        Name = self.Name,
        Parent = self.Parent,
        Entries = {}
    }

    for entryKey, entryValue in self.Entries do
        blackboardCopy.Entries[entryKey] = entryValue
    end

    setmetatable(blackboardCopy, Blackboard)

    return blackboardCopy
end

---Return the name of the Blackboard.
---@return string
function Blackboard:GetName()
    self = (self :: SMTypesMod.Blackboard)

    return self.Name
end

---Get and return a value within this Blackboard hierarchy.
---@param entryKey string
function Blackboard:GetValue(entryKey: string)
    self = (self :: SMTypesMod.Blackboard)

    if self.Entries[entryKey] == nil and self.Parent then
        return self.Parent:GetValue(entryKey)
    end

    return self.Entries[entryKey]
end

---Get a value within this Blackboard. Does not search upwards.
---@param entryKey string
function Blackboard:GetValueLocal(entryKey: string)
    self = (self :: SMTypesMod.Blackboard)

    return self.Entries[entryKey]
end

---Set a value within this Blackboard for an existing entry. Does not search upward.
---@param entryKey string
---@param newValue any
function Blackboard:SetValueLocal(entryKey: string, newValue: any)
    self = (self :: SMTypesMod.Blackboard)

    if self.Entries[entryKey] == nil then
        self.Entries[entryKey] = newValue
        return true
    end

    return false
end

---Set the parent Blackboard object to be referenced for BlackboardEntry lookup.
---@param parent table
function Blackboard:SetParent(parent: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.Blackboard)

    self.Parent = parent
end

---Set a value within the Blackboard hierarchy for an existing entry.
---@param entryKey string The key (name) of the BlackboardEntry to modify or create.
---@param newValue any The new value for the BlackboardEntry specified.
function Blackboard:SetValue(entryKey: string, newValue: any)
    self = (self :: SMTypesMod.Blackboard)

    if self.Entries[entryKey] ~= nil then
        self.Entries[entryKey] = newValue
        return true
    end

    if self.Parent then
        return self.Parent:SetValue(entryKey, newValue)
    end

    return false
end

return Blackboard