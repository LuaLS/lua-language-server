local findLib    = require 'core.find_lib'
local getFunctionHover = require 'core.hover_function'
local buildValueName = require 'core.hover_name'

local OriginTypes = {
    ['any']      = true,
    ['nil']      = true,
    ['integer']  = true,
    ['number']   = true,
    ['boolean']  = true,
    ['string']   = true,
    ['thread']   = true,
    ['userdata'] = true,
    ['table']    = true,
    ['function'] = true,
}

local function buildLibArgs(lib, object, select)
    if not lib.args then
        return ''
    end
    local start
    if object then
        start = 2
        if select then
            select = select + 1
        end
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

local function getFunctionHoverAsLib(name, lib, object, select)
    local args, argLabel = buildLibArgs(lib, object, select)
    local returns = buildLibReturns(lib)
    local enum = buildEnum(lib)
    local tip = lib.description
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
    }
end

local function findClass(value)
    -- 检查对象元表
    local metaValue = value:getMetaTable()
    if not metaValue then
        return nil
    end
    -- 检查元表中的 __name
    local metaName = metaValue:rawGet('__name')
    if metaName and type(metaName:getLiteral()) == 'string' then
        return metaName:getLiteral()
    end
    -- 检查元表的 __index
    local indexValue = metaValue:rawGet('__index')
    if not indexValue then
        return nil
    end
    -- 查找index方法中的以下字段: type name class
    -- 允许多重继承
    return indexValue:eachChild(function (k, v)
        -- 键值类型必须均为字符串
        if type(k) ~= 'string' then
            return
        end
        if type(v:getLiteral()) ~= 'string' then
            return
        end
        local lKey = k:lower()
        if     lKey == 'type'
            or lKey == 'name'
            or lKey == 'class'
        then
            -- 必须只有过一次赋值
            local hasSet = false
            local ok = v:eachInfo(function (info)
                if info.type == 'set' then
                    if hasSet then
                        return false
                    else
                        hasSet = true
                    end
                end
            end)
            if ok == false then
                return false
            end
            return v:getLiteral()
        end
    end)
end

local function unpackTable(value)
    local lines = {}
    value:eachChild(function (key, child)
        local kType = type(key)
        if kType == 'table' then
            key = ('[*%s]'):format(key:getType())
        elseif math.type(key) == 'integer' then
            key = ('[%03d]'):format(key)
        elseif kType ~= 'string' then
            key = ('[%s]'):format(key)
        end

        local vType = type(child:getLiteral())
        if     vType == 'boolean'
            or vType == 'integer'
            or vType == 'number'
            or vType == 'string'
        then
            lines[#lines+1] = ('%s: %s = %q,'):format(key, child:getType(), child:getLiteral())
        else
            lines[#lines+1] = ('%s: %s,'):format(key, child:getType())
        end
    end)
    if #lines == 0 then
        return '{}'
    end

    -- 整理一下表
    local cleaned = {}
    local used = {}
    for _, line in ipairs(lines) do
        if used[line] then
            goto CONTINUE
        end
        used[line] = true
        if line == '[*any]: any' then
            goto CONTINUE
        end
        cleaned[#cleaned+1] = '    ' .. line
        :: CONTINUE ::
    end

    table.sort(cleaned)
    table.insert(cleaned, 1, '{')
    cleaned[#cleaned+1] = '}'
    return table.concat(cleaned, '\r\n')
end

local function getValueHover(source, name, value, lib)
    local valueType = value:getType()

    if not lib then
        local class = findClass(value)
        if class then
            valueType = class
        end
    end

    if not OriginTypes[valueType] then
        valueType = '*' .. valueType
    end

    local tip
    local literal
    if lib then
        value = lib.code or (lib.value and ('%q'):format(lib.value))
        tip = lib.description
    else
        literal = value:getLiteral() and ('%q'):format(value:getLiteral())
    end

    local tp
    if source:bindLocal() then
        tp = 'local'
    elseif source:get 'global' then
        tp = 'global'
    elseif source:get 'simple' then
        local simple = source:get 'simple'
        if simple[1]:get 'global' then
            tp = 'global'
        else
            tp = 'field'
        end
    else
        tp = 'field'
    end

    local text
    if valueType == 'table' then
        text = ('%s %s: %s'):format(tp, name, unpackTable(value))
    else
        if literal == nil then
            text = ('%s %s: %s'):format(tp, name, valueType)
        else
            text = ('%s %s: %s = %s'):format(tp, name, valueType, literal)
        end
    end
    return {
        label = text,
        description = tip,
    }
end

local function getStringHover(result, lsp)
    if not result.uri then
        return nil
    end
    if not lsp or not lsp.workspace then
        return nil
    end
    local path = lsp.workspace:relativePathByUri(result.uri)
    return {
        description = ('[%s](%s)'):format(path:string(), result.uri),
    }
end

local function hoverAsValue(source, lsp, select)
    local lib, fullkey = findLib(source)
    local value = source:bindValue()
    local name = fullkey or buildValueName(source)

    local hover
    if value:getType() == 'function' then
        local object = source:get 'object'
        if lib then
            hover = getFunctionHoverAsLib(name, lib, object, select)
        else
            hover = getFunctionHover(name, value:getFunction(), object, select)
        end
    else
        hover = getValueHover(source, name, value, lib)
    end

    if not hover then
        return nil
    end
    hover.name = name
    return hover
end

return function (source, lsp, select)
    if not source then
        return nil
    end
    if source.type ~= 'name' then
        return
    end
    if source:bindValue() then
        return hoverAsValue(source, lsp, select)
    end
end
