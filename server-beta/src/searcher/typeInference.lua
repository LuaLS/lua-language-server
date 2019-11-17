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
    ['nil']     = math.maxinteger,
}

local function merge(result, tp)
    if result[tp] then
        return
    end
    if tp:find('|', 1, true) then
        for sub in tp:gmatch '[^|]+' do
            if not result[sub] then
                result[sub] = true
                result[#result+1] = sub
            end
        end
    else
        result[tp] = true
        result[#result+1] = tp
    end
end

local function hasType(tp, target)
    if not target then
        return false
    end
    for sub in target:gmatch '[^|]+' do
        if sub == tp then
            return true
        end
    end
    return false
end

local function dump(result)
    if #result <= 1 then
        return result[1]
    end
    table.sort(result, function (a, b)
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
    return table.concat(result, '|')
end

local function checkLiteral(source)
    if source.type == 'string' then
        return 'string'
    elseif source.type == 'nil' then
        return 'nil'
    elseif source.type == 'boolean' then
        return 'boolean'
    elseif source.type == 'number' then
        if math.type(source[1]) == 'integer' then
            return 'integer'
        else
            return 'number'
        end
    elseif source.type == 'table' then
        return 'table'
    elseif source.type == 'function' then
        return 'function'
    end
end

local function checkUnary(source)
    if source.type ~= 'unary' then
        return
    end
    local op = source.op
    if op.type == 'not' then
        return 'boolean'
    elseif op.type == '#'
    or     op.type == '~' then
        return 'integer'
    elseif op.type == '-' then
        if hasType('integer', searcher.typeInference(source[1])) then
            return 'integer'
        else
            return 'number'
        end
    end
end

local function checkBinary(source)
    if source.type ~= 'binary' then
        return
    end
    local op = source.op
    if op.type == 'and' then
        local isTrue = searcher.isTrue(source[1])
        if isTrue == 'true' then
            return searcher.typeInference(source[2])
        elseif isTrue == 'false' then
            return searcher.typeInference(source[1])
        else
            local result = {}
            merge(result, searcher.typeInference(source[1]))
            merge(result, searcher.typeInference(source[2]))
            return dump(result)
        end
    end
    if op.type == 'or' then
        local isTrue = searcher.isTrue(source[1])
        if isTrue == 'true' then
            return searcher.typeInference(source[1])
        elseif isTrue == 'false' then
            return searcher.typeInference(source[2])
        else
            local result = {}
            merge(result, searcher.typeInference(source[1]))
            merge(result, searcher.typeInference(source[2]))
            return dump(result)
        end
    end
    if op.type == '=='
    or op.type == '~='
    or op.type == '<='
    or op.type == '>='
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
        if  hasType('integer', searcher.typeInference(source[1]))
        and hasType('integer', searcher.typeInference(source[2])) then
            return 'integer'
        else
            return 'number'
        end
    end
end

local function checkValue(source)
    if source.value then
        return searcher.typeInference(source.value)
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
        local tp  = searcher.typeInference(src)
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

function searcher.typeInference(source)
    if not source then
        return
    end
    local cache = searcher.cache.typeInfer[source]
    if cache ~= nil then
        return cache
    end
    local unlock = searcher.lock('typeInfer', source)
    if not unlock then
        return
    end
    cache = typeInference(source) or false
    searcher.cache.typeInfer[source] = cache
    unlock()
    return cache
end
