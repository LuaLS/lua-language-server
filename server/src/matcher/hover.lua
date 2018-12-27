local findLib    = require 'matcher.find_lib'

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
    local argLabel
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

        for _, str in ipairs(argStr) do
            strs[#strs+1] = str
        end
        if arg.optional == 'self' then
            strs[#strs+1] = ']'
        end
        if i == select then
            argLabel = table.concat(argStr)
        end
    end
    for _, arg in ipairs(lib.args) do
        if arg.optional == 'after' then
            strs[#strs+1] = ']'
        end
    end
    return table.concat(strs), argLabel
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

local function buildValueName(result, source)
    local func = result.value
    local declarat = func.declarat or source
    if declarat then
        local key
        if declarat.type == 'name' then
            key = declarat[1]
        elseif declarat.type == 'string' then
            key = ('%q'):format(declarat[1])
        elseif declarat.type == 'number' or declarat.type == 'boolean' then
            key = tostring(declarat[1])
        elseif func.type == 'function' then
            key = ''
        elseif type(result.key) == 'string' then
            key = result.key
        else
            key = ''
        end

        local parentName = declarat.parentName

        if not parentName then
            return key or ''
        end

        if parentName == '?' then
            local parentType = result.parentValue and result.parentValue.type
            if parentType == 'table' then
            else
                parentName = '*' .. parentType
            end
        end
        if source.object then
            return parentName .. ':' .. key
        else
            if parentName then
                if declarat.index then
                    return parentName .. '[' .. key .. ']'
                else
                    return parentName .. '.' .. key
                end
            else
                return key
            end
        end
    end
    return result.key or ''
end

local function buildValueArgs(result, source, select)
    local func = result.value
    local names = {}
    local values = {}
    if func.args then
        for i, arg in ipairs(func.args) do
            names[i] = arg.key
        end
    end
    if func.argValues then
        for i, value in ipairs(func.argValues) do
            values[i] = value.type
        end
    end
    local strs = {}
    local argLabel
    local start = 1
    if source.object then
        start = 2
        if select then
            select = select + 1
        end
    end
    local max
    if func.built then
        max = #names
    else
        max = math.max(#names, #values)
    end
    for i = start, max do
        local name = names[i]
        local value = values[i] or 'any'
        if name then
            strs[#strs+1] = name .. ': ' .. value
        else
            strs[#strs+1] = value
        end
        if i == select then
            argLabel = strs[#strs]
        end
    end
    if func.hasDots then
        strs[#strs+1] = '...'
    end
    return table.concat(strs, ', '), argLabel
end

local function buildValueReturns(result)
    local func = result.value
    if not func.hasReturn then
        return ''
    end
    local strs = {}
    if func.returns then
        for i, rtn in ipairs(func.returns) do
            strs[i] = rtn.type
        end
    end
    if #strs == 0 then
        strs[1] = 'any'
    end
    return '\n  -> ' .. table.concat(strs, ', ')
end

local function getFunctionHover(name, result, source, lib, oo, select)
    local args = ''
    local returns
    local enum
    local tip
    local argLabel
    if lib then
        args, argLabel = buildLibArgs(lib, oo, select)
        returns = buildLibReturns(lib)
        enum = buildEnum(lib)
        tip = lib.description
    else
        args, argLabel = buildValueArgs(result, source, select)
        returns = buildValueReturns(result)
    end
    local title = ('function %s(%s)%s'):format(name, args, returns)
    return {
        label = title,
        description = tip,
        enum = enum,
        argLabel = argLabel,
    }
end

local function findClass(result)
    -- 根据部分字段尝试找出自定义类型
    local metatable = result.value.metatable
    if not metatable or not metatable.child then
        return nil
    end
    -- 查找meta表的 __name 字段
    local name = metatable.child['__name']
    -- 值必须是字符串
    if name and name.value and type(name.value.value) == 'string' then
        return name.value.value
    end
    -- 查找meta表 __index 里的字段
    local index = metatable.child['__index']
    if index and index.value and index.value.child then
        for key, field in pairs(index.value.child) do
            -- 键值类型必须均为字符串
            if type(key) ~= 'string' then
                goto CONTINUE
            end
            if not field.value or type(field.value.value) ~= 'string' then
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
                return field.value.value
            end
            ::CONTINUE::
        end
    end
    return nil
end

local function unpackTable(result)
    local child = result.value and result.value.child
    if not child then
        return '{}'
    end
    local lines = {'{'}
    for key, field in pairs(child) do
        local kType = type(key)
        if kType == 'table' then
            key = ('[*%s]'):format(key.type)
        else
            if kType ~= 'string' then
                key = ('[%s]'):format(key)
            end
        end

        local value = field.value
        if not value then
            lines[#lines+1] = ('    %s: %s,'):format(key, 'any')
            goto CONTINUE
        end

        local vType = type(value.value)
        if vType == 'boolean' or vType == 'integer' or vType == 'number' or vType == 'string' then
            lines[#lines+1] = ('    %s: %s = %q,'):format(key, value.type, value.value)
        else
            lines[#lines+1] = ('    %s: %s,'):format(key, value.type)
        end
        ::CONTINUE::
    end
    lines[#lines+1] = '}'
    return table.concat(lines, '\r\n')
end

local function getValueHover(name, valueType, result, source, lib)
    if not lib then
        local class = findClass(result)
        if class then
            valueType = class
        end
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
        value = result.value.value and ('%q'):format(result.value.value)
    end

    local tp = result.type
    if tp == 'field' then
        if result.parent and result.parent.value and result.parent.value.ENV then
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

return function (result, source, lsp, select)
    if not result.value then
        return
    end

    if result.key == '' then
        return
    end

    if result.type == 'string' then
        return getStringHover(result, lsp)
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
        valueType = result.value.type or 'nil'
    end
    local name = fullKey or buildValueName(result, source)
    if valueType == 'function' then
        return getFunctionHover(name, result, source, lib, oo, select)
    else
        return getValueHover(name, valueType, result, source, lib)
    end
end
