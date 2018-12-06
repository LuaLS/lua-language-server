local findResult = require 'matcher.find_result'
local findLib    = require 'matcher.find_lib'

local function buildArgs(lib)
    if not lib.args then
        return ''
    end
    local strs = {}
    for i, arg in ipairs(lib.args) do
        if arg.optional then
            if i > 1 then
                strs[#strs+1] = ' ['
            else
                strs[#strs+1] = '['
            end
        end
        if i > 1 then
            strs[#strs+1] = ', '
        end
        if arg.name then
            strs[#strs+1] = ('%s:'):format(arg.name)
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
            strs[#strs+1] = ('%s:'):format(rtn.name)
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
        strs[#strs+1] = ('\n%s:%s'):format(name, enums.type or '')
        for _, enum in ipairs(enums) do
            strs[#strs+1] = '\n  | '
            strs[#strs+1] = ('%q: %s'):format(enum.enum, enum.description or '')
        end
    end
    return table.concat(strs)
end

local function buildFunctionHover(lib, name)
    local title = ('function %s(%s)%s'):format(name, buildArgs(lib), buildReturns(lib))
    local enum = buildEnum(lib)
    local tip = lib.description or ''
    return ('```lua\n%s%s\n```\n%s'):format(title, enum, tip)
end

return function (results, pos)
    local result = findResult(results, pos)
    if not result then
        return nil
    end

    if result.type ~= 'var' then
        return nil
    end
    local var = result.var
    local lib, name = findLib(var)
    if not lib then
        return nil
    end

    if lib.type == 'function' then
        return buildFunctionHover(lib, name)
    elseif lib.type == 'table' then
        local tip = lib.description or ''
        return ('%s'):format(tip)
    elseif lib.type == 'string' then
        return lib.description
    end
end
