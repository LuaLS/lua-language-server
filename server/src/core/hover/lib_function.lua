local lang = require 'language'
local config = require 'config'
local function buildLibArgs(lib, object, select)
    if not lib.args then
        return ''
    end
    local start
    if object then
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

        local argStr = {}
        if i == select then
            argStr[#argStr+1] = '@ARG'
        end
        if arg.name then
            argStr[#argStr+1] = ('%s: '):format(arg.name)
        end
        if type(arg.type) == 'table' then
            argStr[#argStr+1] = table.concat(arg.type, '/')
        else
            argStr[#argStr+1] = arg.type or 'any'
        end
        if arg.default then
            argStr[#argStr+1] = ('(%q)'):format(arg.default)
        end
        if i == select then
            argStr[#argStr+1] = '@ARG'
        end

        for _, str in ipairs(argStr) do
            strs[#strs+1] = str
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
    local text = table.concat(strs)
    local argLabel = {}
    for i = 1, 2 do
        local pos = text:find('@ARG', 1, true)
        if pos then
            if i == 1 then
                argLabel[i] = pos
            else
                argLabel[i] = pos - 1
            end
            text = text:sub(1, pos-1) .. text:sub(pos+4)
        end
    end
    if #argLabel == 0 then
        argLabel = nil
    end
    return text, argLabel
end

local function buildLibReturns(lib)
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
        if type(rtn.type) == 'table' then
            strs[#strs+1] = table.concat(rtn.type, '/')
        else
            strs[#strs+1] = rtn.type or 'any'
        end
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
        if not enum.name or (not enum.enum and not enum.code) then
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
            if lib.returns then
                for _, rtn in ipairs(lib.returns) do
                    if rtn.name == enum.name then
                        container[enum.name].type = rtn.type
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
        local tp
        if type(enums.type) == 'table' then
            tp = table.concat(enums.type, '/')
        else
            tp = enums.type
        end
        strs[#strs+1] = ('\n%s: %s'):format(name, tp or 'any')
        for _, enum in ipairs(enums) do
            if enum.default then
                strs[#strs+1] = '\n  -> '
            else
                strs[#strs+1] = '\n   | '
            end
            if enum.code then
                strs[#strs+1] = tostring(enum.code)
            else
                strs[#strs+1] = ('%q'):format(enum.enum)
            end
            if enum.description then
                strs[#strs+1] = ' -- ' .. enum.description
            end
        end
    end
    return table.concat(strs)
end

local function buildDoc(lib)
    local doc = lib.doc
    if not doc then
        return
    end
    local version = config.config.runtime.version
    if version == 'Lua 5.1' then
        return lang.script('HOVER_DOCUMENT_LUA51', doc)
    elseif version == 'Lua 5.2' then
        return lang.script('HOVER_DOCUMENT_LUA52', doc)
    elseif version == 'Lua 5.3' then
        return lang.script('HOVER_DOCUMENT_LUA53', doc)
    elseif version == 'Lua 5.4' then
        return lang.script('HOVER_DOCUMENT_LUA54', doc)
    elseif version == 'LuaJIT' then
        return lang.script('HOVER_DOCUMENT_LUAJIT', doc)
    end
end

return function (name, lib, object, select)
    local args, argLabel = buildLibArgs(lib, object, select)
    local returns = buildLibReturns(lib)
    local enum = buildEnum(lib)
    local tip = lib.description
    local doc = buildDoc(lib)
    local headLen = #('function %s('):format(name)
    local title = ('function %s(%s)%s'):format(name, args, returns)
    if argLabel then
        argLabel[1] = argLabel[1] + headLen
        argLabel[2] = argLabel[2] + headLen
    end
    return {
        label = title,
        description = tip,
        enum = enum,
        argLabel = argLabel,
        doc = doc,
    }
end
