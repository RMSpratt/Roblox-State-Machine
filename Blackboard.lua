local SMArgValidationMod = require(script.Parent.SMArgValidation)
local SMTypesMod = require(script.Parent.SMTypes)

--Defines a data structure representing all of the agent's knowledge about the Environment.
local Blackboard = {}
Blackboard.__index = Blackboard

---Create and return a new Blackboard
---@param blackboardName string
---@return table
function Blackboard.New(blackboardName: string)
    local self = {}

    SMArgValidationMod.CheckArgumentTypes({'string'}, {blackboardName}, 'New')

    self._Type = SMTypesMod.Blackboard
    self.Name = blackboardName
    self.Entries = {}
    setmetatable(self, Blackboard)

    return self
end

---Add a BlackboardEntry to the Blackboard.
---@param entryName string
---@param entryValue any
function Blackboard:AddEntry(entryName: string, entryValue: any)
    self = (self :: SMTypesMod.Blackboard)

    SMArgValidationMod.CheckArgumentTypes({'string', 'any'}, {entryName, entryValue}, 'AddEntry')

    if self.Entries[entryName] then
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
    local blackboardCopy = {}

    blackboardCopy.Name = self.Name
    blackboardCopy.Parent = self.Parent
    blackboardCopy.Entries = {}

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

    SMArgValidationMod.CheckArgumentTypes({'string'}, {entryKey}, 'GetValue')

    if not self.Entries[entryKey] and self.Parent then
        return self.Parent:GetValue(entryKey)
    end

    return self.Entries[entryKey]
end

---Get a value within this Blackboard. Does not search upwards.
---Not recommended but can be used for debugging.
---@param entryKey string
function Blackboard:GetValueLocal(entryKey: string)
    self = (self :: SMTypesMod.Blackboard)

    SMArgValidationMod.CheckArgumentTypes({'string'}, {entryKey}, 'GetValueLocal')
    return self.Entries[entryKey]
end

---Set a value within this Blackboard for an existing entry. Does not search upward.
---Not recommended but can be used for debugging.
---@param entryKey string
---@param newValue any
function Blackboard:SetValueLocal(entryKey: string, newValue: any)
    self = (self :: SMTypesMod.Blackboard)
    SMArgValidationMod.CheckArgumentTypes({'string', 'any'}, {entryKey, newValue}, 'SetValueLocal')

    if self.Entries[entryKey] then
        self.Entries[entryKey] = newValue
        return true
    end

    return false
end

---Set the Blackboard's parent to allow inheriting keys.
---@param parent table
function Blackboard:SetParent(parent: SMTypesMod.Blackboard)
    self = (self :: SMTypesMod.Blackboard)
    SMArgValidationMod.CheckArgumentTypes({SMTypesMod.Blackboard}, {parent}, 'SetParent')
    self.Parent = parent
end

---Set a value within the Blackboard hierarchy for an existing entry.
---@param entryKey string
---@param newValue any
function Blackboard:SetValue(entryKey: string, newValue: any)
    self = (self :: SMTypesMod.Blackboard)

    SMArgValidationMod.CheckArgumentTypes({'string', 'any'}, {entryKey, newValue}, 'SetValue')

    if self.Entries[entryKey] then
        self.Entries[entryKey] = newValue
        return true
    end

    if self.Parent then
        return self.Parent:SetValue(entryKey, newValue)
    end

    return false
end

return Blackboard