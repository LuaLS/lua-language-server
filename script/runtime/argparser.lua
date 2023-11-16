---@class ArgParser
local M = {}

---@alias ArgParser.Value string | number | boolean

---@param args string[]?
---@param fomratKey boolean?
---@return table<string, ArgParser.Value>
function M.parse(args, fomratKey)
    local result = {}
    if not args then
        return result
    end
    local i = 1
    while args[i] do
        local argv = args[i]
        local nextArg = args[i + 1]
        local key, value, consumedNextArg = M.parseOne(argv, nextArg)
        if not key then
            break
        end
        if fomratKey then
            key = key:upper():gsub('-', '_')
        end
        result[key] = value
        if consumedNextArg then
            i = i + 2
        else
            i = i + 1
        end
    end
    return result
end

---@param argv string
---@param nextArg string?
---@return string?
---@return ArgParser.Value?
---@return boolean? consumedNextArg
function M.parseOne(argv, nextArg)
    local key, tail = argv:match '^%-%-([%w_]+)(.*)$'
    if not key then
        return nil
    end
    local value = tail:match '=(.+)'
    if value then
        value = M.parseValue(value)
        return key, value, false
    elseif nextArg and nextArg:sub(1, 2) ~= '--' then
        value = M.parseValue(nextArg)
        return key, value, true
    end
    return key, true, false
end

---@param value string
---@return ArgParser.Value
function M.parseValue(value)
    if value == 'true' or value == nil then
        return true
    elseif value == 'false' then
        return false
    elseif tonumber(value) then
        return tonumber(value) --[[@as number]]
    elseif value:sub(1, 1) == '"' and value:sub(-1, -1) == '"' then
        return value:sub(2, -2)
    end
    return value
end

return M
