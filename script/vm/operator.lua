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

vm.unarySwich = util.switch()
    : case 'not'
    : call(function (source)
        local result = vm.testCondition(source[1])
        if result == nil then
            vm.setNode(source, vm.declareGlobal('type', 'boolean'))
        else
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
        vm.setNode(source, vm.declareGlobal('type', 'integer'))
    end)
    : case '-'
    : call(function (source)
        local v = vm.getNumber(source[1])
        if v == nil then
            local infer = vm.getInfer(source[1])
            if infer:hasType(guide.getUri(source), 'integer') then
                vm.setNode(source, vm.declareGlobal('type', 'integer'))
            else
                vm.setNode(source, vm.declareGlobal('type', 'number'))
            end
        else
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
            vm.setNode(source, vm.declareGlobal('type', 'integer'))
        else
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
            local node = node1:copy():setTruthy():merge(node2)
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
        if a and b then
            local op = source.op.type
            local result = op.type == '<<' and a << b
                        or op.type == '>>' and a >> b
                        or op.type == '&'  and a &  b
                        or op.type == '|'  and a |  b
                        or op.type == '~'  and a ~  b
            vm.setNode(source, {
                type   = 'integer',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = result,
            })
        else
            vm.setNode(source, vm.declareGlobal('type', 'integer'))
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
            vm.setNode(source, {
                type   = math.type(result) == 'integer' and 'integer' or 'number',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = result,
            })
        else
            if op == '+'
            or op == '-'
            or op == '*'
            or op == '//'
            or op == '%' then
                local uri = guide.getUri(source)
                local infer1 = vm.getInfer(source[1])
                local infer2 = vm.getInfer(source[2])
                if infer1:hasType(uri, 'integer')
                or infer2:hasType(uri, 'integer') then
                    if  not infer1:hasType(uri, 'number')
                    and not infer2:hasType(uri, 'number') then
                        vm.setNode(source, vm.declareGlobal('type', 'integer'))
                        return
                    end
                end
            end
            vm.setNode(source, vm.declareGlobal('type', 'number'))
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
            vm.setNode(source, {
                type   = 'string',
                start  = source.start,
                finish = source.finish,
                parent = source,
                [1]    = a .. b,
            })
        else
            vm.setNode(source, vm.declareGlobal('type', 'string'))
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
            local result = op.type == '>'  and a >  b
                        or op.type == '<'  and a <  b
                        or op.type == '>=' and a >= b
                        or op.type == '<=' and a <= b
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
