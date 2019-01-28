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

local function buildLibArgs(lib, oo, select)
    if not lib.args then
        return ''
    end
    local start
    if oo then
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

local function getFunctionHoverAsLib(name, lib, oo, select)
    local args, argLabel = buildLibArgs(lib, oo, select)
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

local function findClass(result)
    -- 查找meta表的 __name 字段
    local name = result.value:getMeta('__name', result.source)
    -- 值必须是字符串
    if name and name.value and type(name.value:getValue()) == 'string' then
        return name.value:getValue()
    end
    -- 查找meta表 __index 里的字段
    local index = result.value:getMeta('__index', result.source)
    if index and index.value then
        return index.value:eachField(function (key, field)
            -- 键值类型必须均为字符串
            if type(key) ~= 'string' then
                goto CONTINUE
            end
            if not field.value or type(field.value:getValue()) ~= 'string' then
                goto CONTINUE
            end
            local lKey = key:lower()
            if lKey == 'type' or lKey == 'name' or lKey == 'class' then
                -- 必须只有过一次赋值
                local hasSet = false
                for _, info in ipairs(field) do
                    if info.type == 'set' then
                        if hasSet then
                            goto CONTINUE
                        end
                        hasSet = true
                    end
                end
                return field.value:getValue()
            end
            ::CONTINUE::
        end)
    end
    return nil
end

local function unpackTable(result)
    local lines = {}
    result.value:eachField(function (key, field)
        local kType = type(key)
        if kType == 'table' then
            key = ('[*%s]'):format(key:getType())
        elseif math.type(key) == 'integer' then
            key = ('[%03d]'):format(key)
        elseif kType ~= 'string' then
            key = ('[%s]'):format(key)
        end

        local value = field.value
        if not value then
            local str = ('    %s: %s,'):format(key, 'any')
            lines[#lines+1] = str
            goto CONTINUE
        end

        local vType = type(value:getValue())
        if vType == 'boolean' or vType == 'integer' or vType == 'number' or vType == 'string' then
            local str = ('    %s: %s = %q,'):format(key, value:getType(), value:getValue())
            lines[#lines+1] = str
        else
            local str = ('    %s: %s,'):format(key, value:getType())
            lines[#lines+1] = str
        end
        ::CONTINUE::
    end)
    if #lines == 0 then
        return '{}'
    end
    table.sort(lines)
    table.insert(lines, 1, '{')
    lines[#lines+1] = '}'
    return table.concat(lines, '\r\n')
end

local function getValueHover(name, valueType, result, lib)
    if not lib then
        local class = findClass(result)
        if class then
            valueType = class
        end
    end

    if type(valueType) == 'table' then
        valueType = valueType[1]
    end

    if not OriginTypes[valueType] then
        valueType = '*' .. valueType
    end

    local value
    local tip
    if lib then
        value = lib.code or (lib.value and ('%q'):format(lib.value))
        tip = lib.description
    else
        value = result.value:getValue() and ('%q'):format(result.value:getValue())
    end

    local tp = result.type
    if tp == 'field' then
        if result.parent and result.parent.value and result.parent.value.GLOBAL then
            tp = 'global'
        end
    end

    local text
    if valueType == 'table' then
        text = ('%s %s: %s'):format(tp, name, unpackTable(result))
    else
        if value == nil then
            text = ('%s %s: %s'):format(tp, name, valueType)
        else
            text = ('%s %s: %s = %s'):format(tp, name, valueType, value)
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

local function hoverAsValue(result, source, lsp, select)
    if result:getType() == 'string' then
        return getStringHover(result, lsp)
    end
end

local function hoverAsVar(result, source, lsp, select)
    if not result.value then
        return
    end

    if result.key == '' then
        return
    end


    if result.type ~= 'local' and result.type ~= 'field' then
        return
    end

    local lib, fullKey, oo = findLib(result)
    local valueType = lib and lib.type
    if valueType then
        if type(valueType) == 'table' then
            valueType = valueType[1]
        end
    else
        valueType = result.value:getType() or 'nil'
    end
    local name = fullKey or buildValueName(result, source)
    local hover
    if valueType == 'function' then
        if lib then
            hover = getFunctionHoverAsLib(name, lib, oo, select)
        else
            hover = getFunctionHover(name, result.value, source.object, select)
        end
    else
        hover = getValueHover(name, valueType, result, lib)
    end
    if not hover then
        return
    end
    hover.name = name
    return hover
end

return function (result, source, lsp, select)
    if result.type == 'value' then
        return hoverAsValue(result, source, lsp, select)
    else
        return hoverAsVar(result, source, lsp, select)
    end
end
