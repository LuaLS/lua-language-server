---@class vm
local vm     = require 'vm.vm'
local util   = require 'utility'
local guide  = require 'parser.guide'
local config = require 'config'

vm.UNARY_OP  = {
    'unm',
    'bnot',
    'len',
}
vm.BINARY_OP = {
    'add',
    'sub',
    'mul',
    'div',
    'mod',
    'pow',
    'idiv',
    'band',
    'bor',
    'bxor',
    'shl',
    'shr',
    'concat',
}
vm.OTHER_OP = {
    'call',
}

local unaryMap = {
    ['-'] = 'unm',
    ['~'] = 'bnot',
    ['#'] = 'len',
}

local binaryMap = {
    ['+']  = 'add',
    ['-']  = 'sub',
    ['*']  = 'mul',
    ['/']  = 'div',
    ['%']  = 'mod',
    ['^']  = 'pow',
    ['//'] = 'idiv',
    ['&']  = 'band',
    ['|']  = 'bor',
    ['~']  = 'bxor',
    ['<<'] = 'shl',
    ['>>'] = 'shr',
    ['..'] = 'concat',
}

local otherMap = {
    ['()'] = 'call',
}

vm.OP_UNARY_MAP  = util.revertMap(unaryMap)
vm.OP_BINARY_MAP = util.revertMap(binaryMap)
vm.OP_OTHER_MAP  = util.revertMap(otherMap)

---@param operators parser.object[]
---@param op string
---@param value? parser.object
---@param result? vm.node
---@return vm.node?
local function checkOperators(operators, op, value, result)
    for _, operator in ipairs(operators) do
        if operator.op[1] ~= op
        or not operator.extends then
            goto CONTINUE
        end
        if value and operator.exp then
            local valueNode = vm.compileNode(value)
            local expNode   = vm.compileNode(operator.exp)
            local uri       = guide.getUri(operator)
            for vo in valueNode:eachObject() do
                if vm.isSubType(uri, vo, expNode) then
                    if not result then
                        result = vm.createNode()
                    end
                    result:merge(vm.compileNode(operator.extends))
                    return result
                end
            end
        else
            if not result then
                result = vm.createNode()
            end
            result:merge(vm.compileNode(operator.extends))
            return result
        end
        ::CONTINUE::
    end
    return result
end

---@param op string
---@param exp parser.object
---@param value? parser.object
---@return vm.node?
function vm.runOperator(op, exp, value)
    local uri = guide.getUri(exp)
    local node = vm.compileNode(exp)
    local result
    for c in node:eachObject() do
        if c.type == 'string'
        or c.type == 'doc.type.string' then
            c = vm.declareGlobal('type', 'string')
        end
        if c.type == 'global' and c.cate == 'type' then
            ---@cast c vm.global
            for _, set in ipairs(c:getSets(uri)) do
                if set.operators and #set.operators > 0 then
                    result = checkOperators(set.operators, op, value, result)
                end
            end
        end
    end
    return result
end

vm.unarySwich = util.switch()
    : case 'not'
    : call(function (source)
        local result = vm.testCondition(source[1])
        if result == nil then
            vm.setNode(source, vm.declareGlobal('type', 'boolean'))
        else
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'boolean',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = not result,
            })
        end
    end)
    : case '#'
    : call(function (source)
        local node = vm.runOperator('len', source[1])
        vm.setNode(source, node or vm.declareGlobal('type', 'integer'))
    end)
    : case '-'
    : call(function (source)
        local v = vm.getNumber(source[1])
        if v == nil then
            local uri = guide.getUri(source)
            local infer = vm.getInfer(source[1])
            if infer:hasType(uri, 'integer') then
                vm.setNode(source, vm.declareGlobal('type', 'integer'))
            elseif infer:hasType(uri, 'number') then
                vm.setNode(source, vm.declareGlobal('type', 'number'))
            else
                local node = vm.runOperator('unm', source[1])
                vm.setNode(source, node or vm.declareGlobal('type', 'number'))
            end
        else
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'number',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = -v,
            })
        end
    end)
    : case '~'
    : call(function (source)
        local v = vm.getInteger(source[1])
        if v == nil then
            local node = vm.runOperator('bnot', source[1])
            vm.setNode(source, node or vm.declareGlobal('type', 'integer'))
        else
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'integer',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = ~v,
            })
        end
    end)

vm.binarySwitch = util.switch()
    : case 'and'
    : call(function (source)
        local node1 = vm.compileNode(source[1])
        local node2 = vm.compileNode(source[2])
        local r1    = vm.testCondition(source[1])
        if r1 == true then
            vm.setNode(source, node2)
        elseif r1 == false then
            vm.setNode(source, node1)
        else
            local node = node1:copy():setFalsy():merge(node2)
            vm.setNode(source, node)
        end
    end)
    : case 'or'
    : call(function (source)
        local node1 = vm.compileNode(source[1])
        local node2 = vm.compileNode(source[2])
        local r1 = vm.testCondition(source[1])
        if r1 == true then
            vm.setNode(source, node1)
        elseif r1 == false then
            vm.setNode(source, node2)
        else
            local node = node1:copy():setTruthy()
            if not source[2].hasExit then
                node:merge(node2)
            end
            vm.setNode(source, node)
        end
    end)
    : case '=='
    : case '~='
    : call(function (source)
        local result = vm.equal(source[1], source[2])
        if result == nil then
            vm.setNode(source, vm.declareGlobal('type', 'boolean'))
        else
            if source.op.type == '~=' then
                result = not result
            end
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'boolean',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = result,
            })
        end
    end)
    : case '<<'
    : case '>>'
    : case '&'
    : case '|'
    : case '~'
    : call(function (source)
        local a = vm.getInteger(source[1])
        local b = vm.getInteger(source[2])
        local op = source.op.type
        if a and b then
            local result = op == '<<' and a << b
                        or op == '>>' and a >> b
                        or op == '&'  and a &  b
                        or op == '|'  and a |  b
                        or op == '~'  and a ~  b
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'integer',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = result,
            })
        else
            local node = vm.runOperator(binaryMap[op], source[1], source[2])
            if node then
                vm.setNode(source, node)
            end
        end
    end)
    : case '+'
    : case '-'
    : case '*'
    : case '/'
    : case '%'
    : case '//'
    : case '^'
    : call(function (source)
        local a = vm.getNumber(source[1])
        local b = vm.getNumber(source[2])
        local op = source.op.type
        local zero = b == 0
                and (  op == '%'
                    or op == '/'
                    or op == '//'
                )
        if a and b and not zero then
            local result = op == '+'  and a +  b
                        or op == '-'  and a -  b
                        or op == '*'  and a *  b
                        or op == '/'  and a /  b
                        or op == '%'  and a %  b
                        or op == '//' and a // b
                        or op == '^'  and a ^  b
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = (op == '//' or math.type(result) == 'integer') and 'integer' or 'number',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = result,
            })
        else
            local node = vm.runOperator(binaryMap[op], source[1], source[2])
            if node then
                vm.setNode(source, node)
                return
            end
            if op == '+'
            or op == '-'
            or op == '*'
            or op == '%' then
                local uri = guide.getUri(source)
                local infer1 = vm.getInfer(source[1])
                local infer2 = vm.getInfer(source[2])
                if  infer1:hasType(uri, 'integer')
                and infer2:hasType(uri, 'integer') then
                    vm.setNode(source, vm.declareGlobal('type', 'integer'))
                    return
                end
                if  (infer1:hasType(uri, 'number') or infer1:hasType(uri, 'integer'))
                and (infer2:hasType(uri, 'number') or infer2:hasType(uri, 'integer')) then
                    vm.setNode(source, vm.declareGlobal('type', 'number'))
                    return
                end
            end
            if op == '/'
            or op == '^' then
                local uri = guide.getUri(source)
                local infer1 = vm.getInfer(source[1])
                local infer2 = vm.getInfer(source[2])
                if  (infer1:hasType(uri, 'integer') or infer1:hasType(uri, 'number'))
                and (infer2:hasType(uri, 'integer') or infer2:hasType(uri, 'number')) then
                    vm.setNode(source, vm.declareGlobal('type', 'number'))
                    return
                end
            end
            if op == '//' then
                local uri = guide.getUri(source)
                local infer1 = vm.getInfer(source[1])
                local infer2 = vm.getInfer(source[2])
                if  (infer1:hasType(uri, 'integer') or infer1:hasType(uri, 'number'))
                and (infer2:hasType(uri, 'integer') or infer2:hasType(uri, 'number')) then
                    vm.setNode(source, vm.declareGlobal('type', 'integer'))
                    return
                end
            end
        end
    end)
    : case '..'
    : call(function (source)
        local a =  vm.getString(source[1])
                or vm.getNumber(source[1])
        local b =  vm.getString(source[2])
                or vm.getNumber(source[2])
        if a and b then
            if type(a) == 'number' or type(b) == 'number' then
                local uri     = guide.getUri(source)
                local version = config.get(uri, 'Lua.runtime.version')
                if math.tointeger(a) and math.type(a) == 'float' then
                    if version == 'Lua 5.3' or version == 'Lua 5.4' then
                        a = ('%.1f'):format(a)
                    else
                        a = ('%.0f'):format(a)
                    end
                end
                if math.tointeger(b) and math.type(b) == 'float' then
                    if version == 'Lua 5.3' or version == 'Lua 5.4' then
                        b = ('%.1f'):format(b)
                    else
                        b = ('%.0f'):format(b)
                    end
                end
            end
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'string',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = a .. b,
            })
        else
            local uri = guide.getUri(source)
            local infer1 = vm.getInfer(source[1])
            local infer2 = vm.getInfer(source[2])
            if  (
                infer1:hasType(uri, 'integer')
            or  infer1:hasType(uri, 'number')
            or  infer1:hasType(uri, 'string')
            )
            and (
                infer2:hasType(uri, 'integer')
            or  infer2:hasType(uri, 'number')
            or  infer2:hasType(uri, 'string')
            ) then
                vm.setNode(source, vm.declareGlobal('type', 'string'))
                return
            end
            local node = vm.runOperator(binaryMap[source.op.type], source[1], source[2])
            if node then
                vm.setNode(source, node)
            end
        end
    end)
    : case '>'
    : case '<'
    : case '>='
    : case '<='
    : call(function (source)
        local a = vm.getNumber(source[1])
        local b = vm.getNumber(source[2])
        if a and b then
            local op = source.op.type
            local result = op == '>'  and a >  b
                        or op == '<'  and a <  b
                        or op == '>=' and a >= b
                        or op == '<=' and a <= b
            ---@diagnostic disable-next-line: missing-fields
            vm.setNode(source, {
                type   = 'boolean',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    =result,
            })
        else
            vm.setNode(source, vm.declareGlobal('type', 'boolean'))
        end
    end)
