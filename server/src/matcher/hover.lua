local findResult = require 'matcher.find_result'
local findLib    = require 'matcher.find_lib'

local function buildArgs(lib)
    if not lib.args then
        return ''
    end
    local strs = {}
    for i, rtn in ipairs(lib.args) do
        if rtn.optional then
            strs[#strs+1] = '['
        end
        if i > 1 then
            strs[#strs+1] = ', '
        end
        strs[#strs+1] = ('%s:%s'):format(
            rtn.name or ('arg' .. tostring(i)),
            (rtn.type or 'any')
        )
        if rtn.default then
            strs[#strs+1] = ('(%q)'):format(rtn.default)
        end
        if rtn.optional then
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
            strs[#strs+1] = '['
        end
        if i > 1 then
            strs[#strs+1] = ', '
        end
        strs[#strs+1] = ('%s:%s'):format(
            rtn.name or ('res' .. tostring(i)),
            (rtn.type or 'any')
        )
        if rtn.default then
            strs[#strs+1] = ('(%q)'):format(rtn.default)
        end
        if rtn.optional then
            strs[#strs+1] = ']'
        end
    end
    return '\n-> ' .. table.concat(strs)
end

local function buildFunctionHover(lib, name)
    local title = ('function %s(%s)%s'):format(name, buildArgs(lib), buildReturns(lib))
    local tip = lib.description or ''
    return ('```lua\n%s\n```\n%s'):format(title, tip)
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
