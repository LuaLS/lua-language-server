local findResult = require 'matcher.find_result'
local findLib    = require 'matcher.find_lib'

local Cache = {}
local OoCache = {}

local function buildArgs(lib, oo)
    if not lib.args then
        return ''
    end
    local start
    if oo then
        start = 2
    else
        start = 1
    end
    local strs = {}
    for i = start, #lib.args do
        local arg = lib.args[i]
        if arg.optional then
            if i > start then
                strs[#strs+1] = ' ['
            else
                strs[#strs+1] = '['
            end
        end
        if i > start then
            strs[#strs+1] = ', '
        end
        if arg.name then
            strs[#strs+1] = ('%s: '):format(arg.name)
        end
        strs[#strs+1] = arg.type or 'any'
        if arg.default then
            strs[#strs+1] = ('(%q)'):format(arg.default)
        end
        if arg.optional == 'self' then
            strs[#strs+1] = ']'
        end
    end
    for _, arg in ipairs(lib.args) do
        if arg.optional == 'after' then
            strs[#strs+1] = ']'
        end
    end
    return table.concat(strs)
end

local function buildReturns(lib)
    if not lib.returns then
        return ''
    end
    local strs = {}
    for i, rtn in ipairs(lib.returns) do
        if rtn.optional then
            if i > 1 then
                strs[#strs+1] = ' ['
            else
                strs[#strs+1] = '['
            end
        end
        if i > 1 then
            strs[#strs+1] = ', '
        end
        if rtn.name then
            strs[#strs+1] = ('%s: '):format(rtn.name)
        end
        strs[#strs+1] = rtn.type or 'any'
        if rtn.default then
            strs[#strs+1] = ('(%q)'):format(rtn.default)
        end
        if rtn.optional == 'self' then
            strs[#strs+1] = ']'
        end
    end
    for _, rtn in ipairs(lib.returns) do
        if rtn.optional == 'after' then
            strs[#strs+1] = ']'
        end
    end
    return '\n  -> ' .. table.concat(strs)
end

local function buildEnum(lib)
    if not lib.enums then
        return ''
    end
    local container = table.container()
    for _, enum in ipairs(lib.enums) do
        if not enum.name or not enum.enum then
            goto NEXT_ENUM
        end
        if not container[enum.name] then
            container[enum.name] = {}
            if lib.args then
                for _, arg in ipairs(lib.args) do
                    if arg.name == enum.name then
                        container[enum.name].type = arg.type
                        break
                    end
                end
            end
        end
        table.insert(container[enum.name], enum)
        ::NEXT_ENUM::
    end
    local strs = {}
    for name, enums in pairs(container) do
        strs[#strs+1] = ('\n%s: %s'):format(name, enums.type or '')
        for _, enum in ipairs(enums) do
            if enum.default then
                strs[#strs+1] = '\n  -> '
            else
                strs[#strs+1] = '\n   | '
            end
            strs[#strs+1] = ('%q -- %s'):format(enum.enum, enum.description or '')
        end
    end
    return table.concat(strs)
end

local function buildFunctionHover(lib, fullKey, oo)
    local title = ('function %s(%s)%s'):format(fullKey, buildArgs(lib, oo), buildReturns(lib))
    local enum = buildEnum(lib)
    local tip = lib.description or ''
    return ([[
```lua
%s
```
%s
```lua
%s
```
]]):format(title, tip, enum)
end

local function buildField(lib)
    if not lib.fields then
        return ''
    end
    local strs = {}
    for _, field in ipairs(lib.fields) do
        strs[#strs+1] = ('\n%s: %s -- %s'):format(field.field, field.type, field.description or '')
    end
    return table.concat(strs)
end

local function buildTableHover(lib, fullKey)
    local title = ('table %s'):format(fullKey)
    local field = buildField(lib)
    local tip = lib.description or ''
    return ([[
```lua
%s
```
%s
```lua
%s
```
]]):format(title, tip, field)
end

return function (vm, pos)
    local result = findResult(vm.results, pos)
    if not result then
        return nil
    end

    local lib, fullKey, oo = findLib(result.object)
    if not lib then
        return nil
    end

    local cache = oo and OoCache or Cache

    if not cache[lib] then
        if lib.type == 'function' then
            cache[lib] = buildFunctionHover(lib, fullKey, oo) or ''
        elseif lib.type == 'table' then
            cache[lib] = buildTableHover(lib, fullKey) or ''
        elseif lib.type == 'string' then
            cache[lib] = lib.description or ''
        else
            cache[lib] = ''
        end
    end

    return cache[lib]
end
