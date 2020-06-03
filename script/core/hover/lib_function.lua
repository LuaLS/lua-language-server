local lang = require 'language'
local config = require 'config'
local client = require 'client'

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
    local args = {}
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
        local name = ''
        if arg.name then
            name = ('%s: '):format(arg.name)
        end
        if type(arg.type) == 'table' then
            name = name .. table.concat(arg.type, '/')
        else
            name = name .. (arg.type or 'any')
        end
        argStr[#argStr+1] = name
        args[#args+1] = name
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
    return text, argLabel, args
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
            strs[#strs+1] = ('\n% 3d. '):format(i)
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
    local raw = {}
    for name, enums in pairs(container) do
        local tp
        if type(enums.type) == 'table' then
            tp = table.concat(enums.type, '/')
        else
            tp = enums.type
        end
        strs[#strs+1] = ('\n%s: %s'):format(name, tp or 'any')
        raw[name] = {}
        for _, enum in ipairs(enums) do
            if enum.default then
                strs[#strs+1] = '\n  -> '
            else
                strs[#strs+1] = '\n   | '
            end
            if enum.code then
                strs[#strs+1] = tostring(enum.code)
            else
                strs[#strs+1] = tostring(enum.enum)
            end
            raw[name][#raw[name]+1] = strs[#strs]
            if enum.description then
                strs[#strs+1] = ' -- ' .. enum.description
            end
        end
    end
    return table.concat(strs), raw
end

local function getDocFormater()
    local version = config.config.runtime.version
    if client.client() == 'vscode' then
        if version == 'Lua 5.1' then
            return 'HOVER_NATIVE_DOCUMENT_LUA51'
        elseif version == 'Lua 5.2' then
            return 'HOVER_NATIVE_DOCUMENT_LUA52'
        elseif version == 'Lua 5.3' then
            return 'HOVER_NATIVE_DOCUMENT_LUA53'
        elseif version == 'Lua 5.4' then
            return 'HOVER_NATIVE_DOCUMENT_LUA54'
        elseif version == 'LuaJIT' then
            return 'HOVER_NATIVE_DOCUMENT_LUAJIT'
        end
    else
        if version == 'Lua 5.1' then
            return 'HOVER_DOCUMENT_LUA51'
        elseif version == 'Lua 5.2' then
            return 'HOVER_DOCUMENT_LUA52'
        elseif version == 'Lua 5.3' then
            return 'HOVER_DOCUMENT_LUA53'
        elseif version == 'Lua 5.4' then
            return 'HOVER_DOCUMENT_LUA54'
        elseif version == 'LuaJIT' then
            return 'HOVER_DOCUMENT_LUAJIT'
        end
    end
end

local function buildDescription(lib)
    local desc = lib.description
    if not desc then
        return
    end
    return desc:gsub('%(doc%:(.-)%)', function (tag)
        local fmt = getDocFormater()
        if fmt then
            return '(' .. lang.script(fmt, tag) .. ')'
        end
    end)
end

local function buildDoc(lib)
    local doc = lib.doc
    if not doc then
        return
    end
    if lib.web then
        return lang.script(lib.web, doc)
    end
    local fmt = getDocFormater()
    if fmt then
        return ('[%s](%s)'):format(lang.script.HOVER_VIEW_DOCUMENTS, lang.script(fmt, 'pdf-' .. doc))
    end
end

return function (name, lib, object, select)
    local argStr, argLabel, args = buildLibArgs(lib, object, select)
    local returns = buildLibReturns(lib)
    local enum, rawEnum = buildEnum(lib)
    local tip = buildDescription(lib)
    local doc = buildDoc(lib)
    return {
        label = ('function %s(%s)%s'):format(name, argStr, returns),
        name = name,
        argStr = argStr,
        returns = returns,
        description = tip,
        enum = enum,
        rawEnum = rawEnum,
        argLabel = argLabel,
        doc = doc,
        args = args,
    }
end
