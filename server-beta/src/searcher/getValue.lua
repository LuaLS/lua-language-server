local searcher = require 'searcher.searcher'
local guide    = require 'parser.guide'
local config   = require 'config'

local typeSort = {
    ['boolean']  = 1,
    ['string']   = 2,
    ['integer']  = 3,
    ['number']   = 4,
    ['table']    = 5,
    ['function'] = 6,
    ['nil']      = math.maxinteger,
}

NIL = setmetatable({'<nil>'}, { __tostring = function () return 'nil' end })

local function merge(a, b)
    local t = {}
    for i = 1, #a do
        t[#t+1] = a[i]
    end
    for i = 1, #b do
        t[#t+1] = b[i]
    end
    return t
end

local function checkLiteral(source)
    if source.type == 'string' then
        return {
            type   = 'string',
            value  = source[1],
            source = source,
        }
    elseif source.type == 'nil' then
        return {
            type   = 'nil',
            value  = NIL,
            source = source,
        }
    elseif source.type == 'boolean' then
        return {
            type   = 'boolean',
            value  = source[1],
            source = source,
        }
    elseif source.type == 'number' then
        if math.type(source[1]) == 'integer' then
            return {
                type   = 'integer',
                value  = source[1],
                source = source,
            }
        else
            return {
                type   = 'number',
                value  = source[1],
                source = source,
            }
        end
    elseif source.type == 'table' then
        return {
            type   = 'table',
            source = source,
        }
    elseif source.type == 'function' then
        return {
            type   = 'function',
            source = source,
        }
    end
end

local function checkUnary(source)
    if source.type ~= 'unary' then
        return
    end
    local op = source.op
    if op.type == 'not' then
        local isTrue = searcher.isTrue(source[1])
        local value = nil
        if isTrue == true then
            value = false
        elseif isTrue == false then
            value = true
        end
        return {
            type   = 'boolean',
            value  = value,
            source = source,
        }
    elseif op.type == '#' then
        return {
            type   = 'integer',
            source = source,
        }
    elseif op.type == '~' then
        local l = searcher.getLiteral(source[1], 'integer')
        return {
            type   = 'integer',
            value  = l and ~l or nil,
            source = source,
        }
    elseif op.type == '-' then
        local v = searcher.getLiteral(source[1], 'integer')
        if v then
            return {
                type   = 'integer',
                value  = - v,
                source = source,
            }
        end
        v = searcher.getLiteral(source[1], 'number')
        return {
            type   = 'number',
            value  = v and -v or nil,
            source = source,
        }
    end
end

local function checkBinary(source)
    if source.type ~= 'binary' then
        return
    end
    local op = source.op
    if op.type == 'and' then
        local isTrue = searcher.checkTrue(source[1])
        if isTrue == true then
            return searcher.getValue(source[2])
        elseif isTrue == false then
            return searcher.getValue(source[1])
        else
            return merge(
                searcher.getValue(source[1]),
                searcher.getValue(source[2])
            )
        end
    elseif op.type == 'or' then
        local isTrue = searcher.checkTrue(source[1])
        if isTrue == true then
            return searcher.getValue(source[1])
        elseif isTrue == false then
            return searcher.getValue(source[2])
        else
            return merge(
                searcher.getValue(source[1]),
                searcher.getValue(source[2])
            )
        end
    elseif op.type == '==' then
        local value = searcher.isSameValue(source[1], source[2])
        if value ~= nil then
            return {
                type   = 'boolean',
                value  = value,
                source = source,
            }
        end
        local isSame = searcher.isSameRef(source[1], source[2])
        if isSame == true then
            value = true
        else
            value = nil
        end
        return {
            type   = 'boolean',
            value  = value,
            source = source,
        }
    elseif op.type == '~=' then
        local value = searcher.isSameValue(source[1], source[2])
        if value ~= nil then
            return {
                type   = 'boolean',
                value  = not value,
                source = source,
            }
        end
        local isSame = searcher.isSameRef(source[1], source[2])
        if isSame == true then
            value = false
        else
            value = nil
        end
        return {
            type   = 'boolean',
            value  = value,
            source = source,
        }
    elseif op.type == '<=' then
    elseif op.type == '>='
    or op.type == '<'
    or op.type == '>' then
        return 'boolean'
    end
    if op.type == '|'
    or op.type == '~'
    or op.type == '&'
    or op.type == '<<'
    or op.type == '>>' then
        return 'integer'
    end
    if op.type == '..' then
        return 'string'
    end
    if op.type == '^'
    or op.type == '/' then
        return 'number'
    end
    -- 其他数学运算根据2侧的值决定，当2侧的值均为整数时返回整数
    if op.type == '+'
    or op.type == '-'
    or op.type == '*'
    or op.type == '%'
    or op.type == '//' then
        if  hasType('integer', searcher.getValue(source[1]))
        and hasType('integer', searcher.getValue(source[2])) then
            return 'integer'
        else
            return 'number'
        end
    end
end

local function checkValue(source)
    if source.value then
        return searcher.getValue(source.value)
    end
end

local function checkCall(result, source)
    if not source.parent then
        return
    end
    if source.parent.type ~= 'call' then
        return
    end
    if source.parent.node == source then
        merge(result, 'function')
        return
    end
end

local function checkNext(result, source)
    local next = source.next
    if not next then
        return
    end
    if next.type == 'getfield'
    or next.type == 'getindex'
    or next.type == 'getmethod'
    or next.type == 'setfield'
    or next.type == 'setindex'
    or next.type == 'setmethod' then
        merge(result, 'table')
    end
end

local function checkDef(result, source)
    searcher.eachDef(source, function (info)
        local src = info.source
        local tp  = searcher.getValue(src)
        if tp then
            merge(result, tp)
        end
    end)
end

local function typeInference(source)
    local tp = checkLiteral(source)
            or checkValue(source)
            or checkUnary(source)
            or checkBinary(source)
    if tp then
        return tp
    end

    local result = {}

    checkCall(result, source)
    checkNext(result, source)
    checkDef(result, source)

    return dump(result)
end

local function getValue(source)
    local result = checkLiteral(source)
    if result then
        return { result }
    end
    local results = checkValue(source)
                 or checkUnary(source)
                 or checkBinary(source)
    if results then
        return results
    end
end

function searcher.checkTrue(source)
    local values = searcher.getValue(source)
    if not values then
        return
    end
    -- 当前认为的结果
    local current
    for i = 1, #values do
        -- 新的结果
        local new
        local v = values[i]
        if v.type == 'nil' then
            new = false
        elseif v.type == 'boolean' then
            if v.value == true then
                new = true
            elseif v.value == false then
                new = false
            end
        end
        if new ~= nil then
            if current == nil then
                current = new
            else
                -- 如果2个结果完全相反，则返回 nil 表示不确定
                if new ~= current then
                    return nil
                end
            end
        end
    end
    return current
end

--- 拥有某个类型的值
function searcher.eachValueType(source, type, callback)
    local values = searcher.getValue(source)
    if not values then
        return
    end
    for i = 1, #values do
        local v = values[i]
        if v.type == type then
            local res = callback(v)
            if res ~= nil then
                return res
            end
        end
    end
end

--- 获取特定类型的字面量值
function searcher.getLiteral(source, type)
    local values = searcher.getValue(source)
    if not values then
        return nil
    end
    for i = 1, #values do
        local v = values[i]
        if v.type == type and v.value ~= nil then
            return v.value
        end
    end
    return nil
end

function searcher.isSameValue(a, b)
    local valuesA = searcher.getValue(a)
    local valuesB = searcher.getValue(b)
    if valuesA == valuesB and valuesA ~= nil then
        return true
    end
    local values = {}
    for i = 1, #valuesA do
        local value = valuesA[i]
        local literal = value.value
        if literal then
            values[literal] = false
        end
    end
    for i = 1, #valuesB do
        local value = valuesA[i]
        local literal = value.value
        if literal then
            if values[literal] == nil then
                return false
            end
            values[literal] = true
        end
    end
    for k, v in pairs(values) do
        if v == false then
            return false
        end
    end
    return true
end

function searcher.typeInference(source)
    local values = searcher.getValue(source)
    if not values then
        return 'any'
    end
    local types = {}
    for _ = 1, #values do
        local tp = values.type
        if not types[tp] then
            types[tp] = true
            types[#types+1] = tp
        end
    end
    if #types == 0 then
        return 'any'
    end
    if #types == 1 then
        return types[1]
    end
    table.sort(types, function (a, b)
        local sa = typeSort[a]
        local sb = typeSort[b]
        if sa and sb then
            return sa < sb
        end
        if not sa and not sb then
            return a < b
        end
        if sa and not sb then
            return true
        end
        if not sa and sb then
            return false
        end
        return false
    end)
    return table.concat(types, '|')
end

function searcher.getValue(source)
    if not source then
        return
    end
    local cache = searcher.cache.getValue[source]
    if cache ~= nil then
        return cache
    end
    local unlock = searcher.lock('getValue', source)
    if not unlock then
        return
    end
    cache = getValue(source) or false
    searcher.cache.getValue[source] = cache
    unlock()
    return cache
end
