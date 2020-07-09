local findLib    = require 'core.find_lib'
local getFunctionHover = require 'core.hover.function'
local getFunctionHoverAsLib = require 'core.hover.lib_function'
local getFunctionHoverAsEmmy = require 'core.hover.emmy_function'
local buildValueName = require 'core.hover.name'
local lang = require 'language'
local config = require 'config'
local uric = require 'uri'

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

local function longString(str)
    for i = 0, 10 do
        local finish = ']' .. ('='):rep(i) .. ']'
        if not str:find(finish, 1, true) then
            return ('[%s[\n%s%s'):format(('='):rep(i), str, finish)
        end
    end
    return ('%q'):format(str)
end

local function formatString(str)
    if #str > 1000 then
        str = str:sub(1000)
    end
    if str:find('[\r\n]') then
        str = str:gsub('[\000-\008\011-\012\014-\031\127]', '')
        return longString(str)
    else
        str = str:gsub('[\000-\008\011-\012\014-\031\127]', function (char)
            return ('\\%03d'):format(char:byte())
        end)
        local single = str:find("'", 1, true)
        local double = str:find('"', 1, true)
        if single and double then
            return longString(str)
        elseif double then
            return ("'%s'"):format(str)
        else
            return ('"%s"'):format(str)
        end
    end
end

local function formatLiteral(v)
    if math.type(v) == 'float' then
        return ('%.10f'):format(v):gsub('[0]*$', ''):gsub('%.$', '.0')
    elseif type(v) == 'string' then
        return formatString(v)
    else
        return ('%q'):format(v)
    end
end

local function findClass(value)
    -- 检查是否有emmy
    local emmy = value:getEmmy()
    if emmy then
        return emmy:getType()
    end
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

local function formatKey(key)
    local kType = type(key)
    if kType == 'table' then
        key = ('[*%s]'):format(key:getType())
    elseif math.type(key) == 'integer' then
        key = ('[%03d]'):format(key)
    elseif kType == 'string' then
        if key:find '^%d' or key:find '[^%w_]' then
            key = ('[%s]'):format(formatString(key))
        end
    elseif key == '' then
        key = '[*any]'
    else
        key = ('[%s]'):format(key)
    end
    return key
end

local function unpackTable(value)
    local lines = {}
    value:eachChild(function (key, child)
        key = formatKey(key)

        local vType = type(child:getLiteral())
        if     vType == 'boolean'
            or vType == 'integer'
            or vType == 'number'
            or vType == 'string'
        then
            lines[#lines+1] = ('%s: %s = %s'):format(key, child:getType(), formatLiteral(child:getLiteral()))
        else
            lines[#lines+1] = ('%s: %s'):format(key, child:getType())
        end
    end)
    local emmy = value:getEmmy()
    if emmy then
        if emmy.type == 'emmy.arrayType' then
            lines[#lines+1] = ('[*integer]: %s'):format(emmy:getName())
        elseif emmy.type == 'emmy.tableType' then
            lines[#lines+1] = ('[*%s]: %s'):format(emmy:getKeyType():getType(), emmy:getValueType():getType())
        end
    end
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
    local class = findClass(value)

    if class then
        valueType = class
        lib = nil
    end

    if not OriginTypes[valueType] then
        valueType = '*' .. valueType
    end

    local tips = {}
    local literal
    if lib then
        literal = lib.code or (lib.value and formatLiteral(lib.value))
        tips[#tips+1] = lib.description
    else
        literal = value:getLiteral() and formatLiteral(value:getLiteral())
    end

    tips[#tips+1] = value:getComment()

    local tp
    if source:bindLocal() then
        tp = 'local'
        local loc = source:bindLocal()
        if loc.tags then
            local mark = {}
            local tagBufs = {}
            for _, tag in ipairs(loc.tags) do
                local tagName = tag[1]
                if not mark[tagName] then
                    mark[tagName] = true
                    tagBufs[#tagBufs+1] = ('<%s>'):format(tagName)
                end
            end
            name = name .. ' ' .. table.concat(tagBufs, ' ')
        end
        tips[#tips+1] = loc:getComment()
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
            if class and not OriginTypes[class] then
                text = ('%s %s: %s %s'):format(tp, name, valueType, unpackTable(value))
            else
                text = ('%s %s: %s'):format(tp, name, valueType)
            end
        else
            text = ('%s %s: %s = %s'):format(tp, name, valueType, literal)
        end
    end

    local tip
    if #tips > 0 then
        tip = table.concat(tips, '\n\n-------------\n\n')
    end
    return {
        label = text,
        description = tip,
    }
end

local function hoverAsValue(source, lsp, select)
    local lib, fullkey = findLib(source)
    ---@type value
    local value = source:findValue()
    local name = fullkey or buildValueName(source)

    local hover
    if value:getType() == 'function' then
        local object = source:get 'object'
        if lib then
            hover = getFunctionHoverAsLib(name, lib, object, select)
        else
            local emmy = value:getEmmy()
            if emmy and emmy.type == 'emmy.functionType' then
                hover = getFunctionHoverAsEmmy(name, emmy, object, select)
            else
                local func = value:getFunction()
                hover = getFunctionHover(name, func, object, select)
            end
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
    if not lsp then
        return nil
    end
    local ws = lsp:findWorkspaceFor(uri)
    if ws then
        local path = ws:relativePathByUri(uri)
        if not path then
            return nil
        end
        return {
            description = ('[%s](%s)'):format(path:string(), uri),
        }
    else
        return {
            description = ('[%s](%s)'):format(uric.decode(uri):string(), uri),
        }
    end
end

local function hoverAsString(source)
    local str = source[1]
    if type(str) ~= 'string' then
        return nil
    end
    local len = #str
    local charLen = utf8.len(str, 1, -1, true)
    local lines = {}
    if len == charLen then
        lines[#lines+1] = lang.script('HOVER_STRING_BYTES', len)
    else
        lines[#lines+1] = lang.script('HOVER_STRING_CHARACTERS', len, charLen)
    end
    -- 内部包含转义符？
    local rawLen = source.finish - source.start - 2 * #source[2] + 1
    if  config.config.hover.viewString
    and (source[2] == '"' or source[2] == "'")
    and rawLen > #str then
        local view = str
        local max = config.config.hover.viewStringMax
        if #view > max then
            view = view:sub(1, max) .. '...'
        end
        lines[#lines+1] = ([[

------------------
```txt
%s
```]]):format(view)
    end
    return {
        description = table.concat(lines, '\n'),
        range = {
            start = source.start,
            finish = source.finish,
        },
    }
end

local function formatNumber(n)
    local str = ('%.10f'):format(n)
    str = str:gsub('%.?0*$', '')
    return str
end

local function hoverAsNumber(source)
    if not config.config.hover.viewNumber then
        return nil
    end
    local num = source[1]
    if type(num) ~= 'number' then
        return nil
    end
    local raw = source[2]
    if not raw or not raw:find '[^%-%d%.]' then
        return nil
    end
    return {
        description = formatNumber(num),
        range = {
            start = source.start,
            finish = source.finish,
        },
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
    if source.type == 'string' then
        return hoverAsString(source)
    end
    if source.type == 'number' then
        return hoverAsNumber(source)
    end
    return nil
end
