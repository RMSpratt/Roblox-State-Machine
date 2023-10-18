--Utility functions used for type checking arguments provided for StateMachine elements.
local SMArgValidation = {}

---Check a set of expected argument types against those received.
---Modified to work with SMType type definitions.
---@param expectedArgs table
---@param funcArgs table
---@param funcName string
---@param optionalIdx number
function SMArgValidation.CheckArgumentTypes(expectedArgs: {[number]: string},
    funcArgs: {[number]: any}, funcName: string, optionalIdx: number?)

    optionalIdx = optionalIdx or #expectedArgs + 1

    if #funcArgs > #expectedArgs then
        error(`wrong number of arguments to '{funcName}'`, 2)
    end

    for varIdx, expectedType in ipairs(expectedArgs) do
        local actualType = type(funcArgs[varIdx]) == 'table' and funcArgs[varIdx]._Type
            or type(funcArgs[varIdx])

        if varIdx < optionalIdx and not funcArgs[varIdx] then
            error(`missing argument #{varIdx} to '{funcName}' ({expectedType} expected)`, 2)
        end

        if funcArgs[varIdx] ~= nil and expectedType ~= "any" and actualType ~= expectedType then
            error(`invalid argument #{varIdx} to '{funcName}' ({expectedArgs[varIdx]} expected, got {actualType})`, 2)
        end
    end
end

---Check the type of a set of key-value pairs in a table as an argument passed to a function.
---Keys not specified in expectedTypePairs are not checked.
---@param expectedTypePairs table An array of {[any]: string} pairs for desired table value types.
---@param argTable table The actual table argument received to funcName.
---@param funcName string The name of the function that received the argument table.
---@param argumentIdx number The index of the argument as passed.
function SMArgValidation.CheckTableKeyValueTypes(expectedTypePairs: {[any]: string},
    argTable: {[any]: any}, funcName: string, argumentIdx: number)

    for expectedKey, expectedType in expectedTypePairs do
        local actualType = type(argTable[expectedKey]) == 'table' and argTable[expectedKey]._Type
            or type(argTable[expectedKey])

        if argTable[expectedKey] == nil then
            error(`missing key '{expectedKey}' in argument #{argumentIdx}` ..
                ` to '{funcName}' ({expectedType} expected)`)
        end

        if expectedType ~= "any" and expectedType ~= actualType then
            error(`invalid value for key '{expectedKey}' in argument #{argumentIdx}` ..
                ` to '{funcName}' ({expectedType} expected, got {actualType})`)
        end
    end
end

---Check the type of each value in the passed array table according to the expected type specified.
---@param expectedType string The expected type for all table values.
---@param argTable table The actual table argument received to funcName.
---@param funcName string The name of the function that received the argument table.
---@param argumentIdx number The index of the argument as passed.
---@param desiredSize number? The number of values expected for the array table.
function SMArgValidation.CheckTableValuesFixedType(expectedType: string,
    argTable: {[any]: any}, funcName: string, argumentIdx: number, desiredSize: number?)

    --Not likely, but here if desired
    if desiredSize and #argTable ~= desiredSize then
        error(`wrong number of values to argument #{argumentIdx} in '{funcName}'`, 2)
    end

    for argIdx, argValue in pairs(argTable) do
        local actualType = type(argValue) == 'table' and argValue._Type
            or type(argValue)

        if actualType ~= expectedType then
            error(`invalid value for key '{argIdx}' in argument #{argumentIdx}` ..
                ` to '{funcName}' ({expectedType} expected, got {actualType})`)
        end
    end
end

return SMArgValidation