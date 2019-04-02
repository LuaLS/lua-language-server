local findLib    = require 'core.find_lib'
local getFunctionHover = require 'core.hover.function'
local getFunctionHoverAsLib = require 'core.hover.lib_function'
local buildValueName = require 'core.hover.name'

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
        elseif kType == 'string' then
            if key:find '^%d' or key:find '[^%w_]' then
                key = ('[%q]'):format(key)
            end
        elseif key == '' then
            key = '[*any]'
        else
            key = ('[%s]'):format(key)
        end

        local vType = type(child:getLiteral())
        if     vType == 'boolean'
            or vType == 'integer'
            or vType == 'number'
            or vType == 'string'
        then
            lines[#lines+1] = ('%s: %s = %q'):format(key, child:getType(), child:getLiteral())
        else
            lines[#lines+1] = ('%s: %s'):format(key, child:getType())
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
        cleaned[#cleaned+1] = '    ' .. line .. ','
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
        literal = lib.code or (lib.value and ('%q'):format(lib.value))
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

local function hoverAsValue(source, lsp, select)
    local lib, fullkey = findLib(source)
    local value = source:findValue()
    local name = fullkey or buildValueName(source)

    local hover
    if value:getType() == 'function' then
        local object = source:get 'object'
        if lib then
            hover = getFunctionHoverAsLib(name, lib, object, select)
        else
            local func = value:getFunction()
            hover = getFunctionHover(name, func, object, select)
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

local function hoverAsTargetUri(source, lsp)
    local uri = source:get 'target uri'
    if not lsp or not lsp.workspace then
        return nil
    end
    local path = lsp.workspace:relativePathByUri(uri)
    return {
        description = ('[%s](%s)'):format(path:string(), uri),
    }
end

return function (source, lsp, select)
    if not source then
        return nil
    end
    if source:get 'target uri' then
        return hoverAsTargetUri(source, lsp)
    end
    if source.type == 'name' and source:bindValue() then
        return hoverAsValue(source, lsp, select)
    end
    if source.type == 'simple' then
        source = source[#source]
        if source.type == 'name' and source:bindValue() then
            return hoverAsValue(source, lsp, select)
        end
    end
    return nil
end
