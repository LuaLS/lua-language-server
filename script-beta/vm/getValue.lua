local vm      = require 'vm.vm'
local util    = require 'utility'
local guide   = require 'parser.guide'
local library = require 'library'
local select  = select

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

local function merge(t, b)
    if not t then
        t = {}
    end
    if not b then
        return t
    end
    for i = 1, #b do
        local o = b[i]
        if not t[o] then
            t[o] = true
            t[#t+1] = o
        end
    end
    return t
end

local function alloc(o)
    -- TODO
    assert(o.type)
    if type(o.type) == 'table' then
        local values = {}
        for i = 1, #o.type do
            local sub = {
                type   = o.type[i],
                value  = o.value,
                source = o.source,
            }
            values[i] = sub
            values[sub] = true
        end
        return values
    else
        return {
            [1] = o,
            [o] = true,
        }
    end
end

local function insert(t, o)
    if not o then
        return
    end
    if not t[o] then
        t[o] = true
        t[#t+1] = o
    end
    return t
end

local function checkLiteral(source)
    if source.type == 'string' then
        return alloc {
            type   = 'string',
            value  = source[1],
            source = source,
        }
    elseif source.type == 'nil' then
        return alloc {
            type   = 'nil',
            value  = NIL,
            source = source,
        }
    elseif source.type == 'boolean' then
        return alloc {
            type   = 'boolean',
            value  = source[1],
            source = source,
        }
    elseif source.type == 'number' then
        if math.type(source[1]) == 'integer' then
            return alloc {
                type   = 'integer',
                value  = source[1],
                source = source,
            }
        else
            return alloc {
                type   = 'number',
                value  = source[1],
                source = source,
            }
        end
    elseif source.type == 'integer' then
        return alloc {
            type   = 'integer',
            source = source,
        }
    elseif source.type == 'table' then
        return alloc {
            type   = 'table',
            source = source,
        }
    elseif source.type == 'function' then
        return alloc {
            type   = 'function',
            source = source,
        }
    elseif source.type == '...' then
        return alloc {
            type   = '...',
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
        local checkTrue = vm.checkTrue(source[1])
        local value = nil
        if checkTrue == true then
            value = false
        elseif checkTrue == false then
            value = true
        end
        return alloc {
            type   = 'boolean',
            value  = value,
            source = source,
        }
    elseif op.type == '#' then
        return alloc {
            type   = 'integer',
            source = source,
        }
    elseif op.type == '~' then
        local l = vm.getLiteral(source[1], 'integer')
        return alloc {
            type   = 'integer',
            value  = l and ~l or nil,
            source = source,
        }
    elseif op.type == '-' then
        local v = vm.getLiteral(source[1], 'integer')
        if v then
            return alloc {
                type   = 'integer',
                value  = - v,
                source = source,
            }
        end
        v = vm.getLiteral(source[1], 'number')
        return alloc {
            type   = 'number',
            value  = v and -v or nil,
            source = source,
        }
    end
end

local function mathCheck(a, b)
    local v1  = vm.getLiteral(a, 'integer') or vm.getLiteral(a, 'number')
    local v2  = vm.getLiteral(b, 'integer') or vm.getLiteral(a, 'number')
    local int = vm.hasType(a, 'integer')
            and vm.hasType(b, 'integer')
            and not vm.hasType(a, 'number')
            and not vm.hasType(b, 'number')
    return int and 'integer' or 'number', v1, v2
end

local function checkBinary(source)
    if source.type ~= 'binary' then
        return
    end
    local op = source.op
    if op.type == 'and' then
        local isTrue = vm.checkTrue(source[1])
        if isTrue == true then
            return vm.getValue(source[2])
        elseif isTrue == false then
            return vm.getValue(source[1])
        else
            return merge(
                vm.getValue(source[1]),
                vm.getValue(source[2])
            )
        end
    elseif op.type == 'or' then
        local isTrue = vm.checkTrue(source[1])
        if isTrue == true then
            return vm.getValue(source[1])
        elseif isTrue == false then
            return vm.getValue(source[2])
        else
            return merge(
                vm.getValue(source[1]),
                vm.getValue(source[2])
            )
        end
    elseif op.type == '==' then
        local value = vm.isSameValue(source[1], source[2])
        if value ~= nil then
            return alloc {
                type   = 'boolean',
                value  = value,
                source = source,
            }
        end
        local isSame = vm.isSameRef(source[1], source[2])
        if isSame == true then
            value = true
        else
            value = nil
        end
        return alloc {
            type   = 'boolean',
            value  = value,
            source = source,
        }
    elseif op.type == '~=' then
        local value = vm.isSameValue(source[1], source[2])
        if value ~= nil then
            return alloc {
                type   = 'boolean',
                value  = not value,
                source = source,
            }
        end
        local isSame = vm.isSameRef(source[1], source[2])
        if isSame == true then
            value = false
        else
            value = nil
        end
        return alloc {
            type   = 'boolean',
            value  = value,
            source = source,
        }
    elseif op.type == '<=' then
        local v1 = vm.getLiteral(source[1], 'integer') or vm.getLiteral(source[1], 'number')
        local v2 = vm.getLiteral(source[2], 'integer') or vm.getLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 <= v2
        end
        return alloc {
            type   = 'boolean',
            value  = v,
            source = source,
        }
    elseif op.type == '>=' then
        local v1 = vm.getLiteral(source[1], 'integer') or vm.getLiteral(source[1], 'number')
        local v2 = vm.getLiteral(source[2], 'integer') or vm.getLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 >= v2
        end
        return alloc {
            type   = 'boolean',
            value  = v,
            source = source,
        }
    elseif op.type == '<' then
        local v1 = vm.getLiteral(source[1], 'integer') or vm.getLiteral(source[1], 'number')
        local v2 = vm.getLiteral(source[2], 'integer') or vm.getLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 < v2
        end
        return alloc {
            type   = 'boolean',
            value  = v,
            source = source,
        }
    elseif op.type == '>' then
        local v1 = vm.getLiteral(source[1], 'integer') or vm.getLiteral(source[1], 'number')
        local v2 = vm.getLiteral(source[2], 'integer') or vm.getLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 > v2
        end
        return alloc {
            type   = 'boolean',
            value  = v,
            source = source,
        }
    elseif op.type == '|' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 | v2
        end
        return alloc {
            type   = 'integer',
            value  = v,
            source = source,
        }
    elseif op.type == '~' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 ~ v2
        end
        return alloc {
            type   = 'integer',
            value  = v,
            source = source,
        }
    elseif op.type == '&' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 & v2
        end
        return alloc {
            type   = 'integer',
            value  = v,
            source = source,
        }
    elseif op.type == '<<' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 << v2
        end
        return alloc {
            type   = 'integer',
            value  = v,
            source = source,
        }
    elseif op.type == '>>' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 >> v2
        end
        return alloc {
            type   = 'integer',
            value  = v,
            source = source,
        }
    elseif op.type == '..' then
        local v1 = vm.getLiteral(source[1], 'string')
        local v2 = vm.getLiteral(source[2], 'string')
        local v
        if v1 and v2 then
            v = v1 .. v2
        end
        return alloc {
            type   = 'string',
            value  = v,
            source = source,
        }
    elseif op.type == '^' then
        local v1 = vm.getLiteral(source[1], 'integer') or vm.getLiteral(source[1], 'number')
        local v2 = vm.getLiteral(source[2], 'integer') or vm.getLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 ^ v2
        end
        return alloc {
            type   = 'number',
            value  = v,
            source = source,
        }
    elseif op.type == '/' then
        local v1 = vm.getLiteral(source[1], 'integer') or vm.getLiteral(source[1], 'number')
        local v2 = vm.getLiteral(source[2], 'integer') or vm.getLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 > v2
        end
        return alloc {
            type   = 'number',
            value  = v,
            source = source,
        }
    -- 其他数学运算根据2侧的值决定，当2侧的值均为整数时返回整数
    elseif op.type == '+' then
        local int, v1, v2 = mathCheck(source[1], source[2])
        return alloc {
            type   = int,
            value  = (v1 and v2) and (v1 + v2) or nil,
            source = source,
        }
    elseif op.type == '-' then
        local int, v1, v2 = mathCheck(source[1], source[2])
        return alloc {
            type   = int,
            value  = (v1 and v2) and (v1 - v2) or nil,
            source = source,
        }
    elseif op.type == '*' then
        local int, v1, v2 = mathCheck(source[1], source[2])
        return alloc {
            type   = int,
            value  = (v1 and v2) and (v1 * v2) or nil,
            source = source,
        }
    elseif op.type == '%' then
        local int, v1, v2 = mathCheck(source[1], source[2])
        return alloc {
            type   = int,
            value  = (v1 and v2) and (v1 % v2) or nil,
            source = source,
        }
    elseif op.type == '//' then
        local int, v1, v2 = mathCheck(source[1], source[2])
        return alloc {
            type   = int,
            value  = (v1 and v2) and (v1 // v2) or nil,
            source = source,
        }
    end
end

local function checkValue(source)
    if source.value then
        return vm.getValue(source.value)
    end
    if source.type == 'paren' then
        return vm.getValue(source.exp)
    end
    if source.type == 'field'
    or source.type == 'method' then
        return vm.getValue(source.parent)
    end
end

local function inferByCall(results, source)
    if #results ~= 0 then
        return
    end
    if not source.parent then
        return
    end
    if source.parent.type ~= 'call' then
        return
    end
    if source.parent.node == source then
        insert(results, {
            type   = 'function',
            source = source,
        })
        return
    end
end

local function inferByGetTable(results, source)
    if #results ~= 0 then
        return
    end
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
        insert(results, {
            type   = 'table',
            source = source,
        })
    end
end

local function inferByDef(results, source)
    local defs = guide.requestDefinition(source)
    for _, src in ipairs(defs) do
        local tp  = vm.getValue(src)
        if tp then
            merge(results, tp)
        end
    end
end

local function checkLibraryTypes(source)
    if type(source.type) ~= 'table' then
        return nil
    end
    local results = {}
    for i = 1, #source.type do
        insert(results, {
            type = source.type[i],
            source = source,
        })
    end
    return results
end

local function checkLibrary(source)
    local lib = vm.getLibrary(source)
    if not lib then
        return nil
    end
    return alloc {
        type   = lib.type,
        value  = lib.value,
        source = lib,
    }
end

local function checkSpecialReturn(source)
    if source.type ~= 'select' then
        return nil
    end
    local index = source.index
    local call = source.vararg
    if call.type ~= 'call' then
        return nil
    end
    local func = call.node
    local lib = vm.getLibrary(func)
    if not lib then
        return nil
    end
    if lib.special == 'require' then
        local modName = call.args[1]
        if modName and modName.type == 'string' then
            lib = library.library[modName[1]]
            if lib then
                return alloc {
                    type   = lib.type,
                    value  = lib.value,
                    source = lib,
                }
            end
        end
    end
    return nil
end

local function checkLibraryReturn(source)
    if source.type ~= 'select' then
        return nil
    end
    local index = source.index
    local call = source.vararg
    if call.type ~= 'call' then
        return nil
    end
    local func = call.node
    local lib = vm.getLibrary(func)
    if not lib then
        return nil
    end
    if lib.type ~= 'function' then
        return nil
    end
    if not lib.returns then
        return nil
    end
    local rtn = lib.returns[index]
    if not rtn then
        return nil
    end
    if not rtn.type then
        return nil
    end
    if rtn.type == '...' or rtn.type == 'any' then
        return
    end
    return alloc {
        type   = rtn.type,
        value  = rtn.value,
        source = rtn,
    }
end

local function inferByLibraryArg(results, source)
    local args = source.parent
    if not args then
        return
    end
    if args.type ~= 'callargs' then
        return
    end
    local call = args.parent
    if not call then
        return
    end
    local func = call.node
    local index
    for i = 1, #args do
        if args[i] == source then
            index = i
            break
        end
    end
    if not index then
        return
    end
    local lib = vm.getLibrary(func)
    local arg = lib and lib.args and lib.args[index]
    if not arg then
        return
    end
    if not arg.type then
        return
    end
    if arg.type == '...' or arg.type == 'any' then
        return
    end
    return insert(results, {
        type   = arg.type,
        value  = arg.value,
        source = arg,
    })
end

local function hasTypeInResults(results, type)
    for i = 1, #results do
        if results[i].type == 'type' then
            return true
        end
    end
    return false
end

local function inferByUnary(results, source)
    if #results ~= 0 then
        return
    end
    local parent = source.parent
    if not parent or parent.type ~= 'unary' then
        return
    end
    local op = parent.op
    if op.type == '#' then
        -- 会受顺序影响，不检查了
        --if hasTypeInResults(results, 'string')
        --or hasTypeInResults(results, 'integer') then
        --    return
        --end
        insert(results, {
            type   = 'string',
            source = source
        })
        insert(results, {
            type   = 'table',
            source = source
        })
    elseif op.type == '~' then
        insert(results, {
            type   = 'integer',
            source = source
        })
    elseif op.type == '-' then
        insert(results, {
            type   = 'number',
            source = source
        })
    end
end

local function inferByBinary(results, source)
    if #results ~= 0 then
        return
    end
    local parent = source.parent
    if not parent or parent.type ~= 'binary' then
        return
    end
    local op = parent.op
    if op.type == '<='
    or op.type == '>='
    or op.type == '<'
    or op.type == '>'
    or op.type == '^'
    or op.type == '/'
    or op.type == '+'
    or op.type == '-'
    or op.type == '*'
    or op.type == '%' then
        insert(results, {
            type   = 'number',
            source = source
        })
    elseif op.type == '|'
    or     op.type == '~'
    or     op.type == '&'
    or     op.type == '<<'
    or     op.type == '>>'
    -- 整数的可能性比较高
    or     op.type == '//' then
        insert(results, {
            type   = 'integer',
            source = source
        })
    elseif op.type == '..' then
        insert(results, {
            type   = 'string',
            source = source
        })
    end
end

local function inferBySetOfLocal(results, source)
    if source.ref then
        for i = 1, math.min(#source.ref, 100) do
            local ref = source.ref[i]
            if ref.type == 'setlocal' then
                break
            end
            merge(results, vm.getValue(ref))
        end
    end
end

local function inferBySet(results, source)
    if #results ~= 0 then
        return
    end
    if source.type == 'local' then
        inferBySetOfLocal(results, source)
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        merge(results, vm.getValue(source.node))
    end
end

local function mergeFunctionReturns(results, source, index)
    local returns = source.returns
    if not returns then
        return
    end
    for i = 1, #returns do
        local rtn = returns[i]
        if rtn[index] then
            merge(results, vm.getValue(rtn[index]))
        end
    end
end

local function inferByCallReturn(results, source)
    if source.type ~= 'select' then
        return
    end
    if not source.vararg or source.vararg.type ~= 'call' then
        return
    end
    local node = source.vararg.node
    local nodeValues = vm.getValue(node)
    if not nodeValues then
        return
    end
    local index = source.index
    for i = 1, #nodeValues do
        local value = nodeValues[i]
        local src = value.source
        if src.type == 'function' then
            mergeFunctionReturns(results, src, index)
        end
    end
end

local function inferByPCallReturn(results, source)
    if source.type ~= 'select' then
        return
    end
    local call = source.vararg
    if not call or call.type ~= 'call' then
        return
    end
    local node = call.node
    local lib = vm.getLibrary(node)
    if not lib then
        return
    end
    local func, index
    if lib.name == 'pcall' then
        func = call.args[1]
        index = source.index - 1
    elseif lib.name == 'xpcall' then
        func = call.args[1]
        index = source.index - 2
    else
        return
    end
    local funcValues = vm.getValue(func)
    if not funcValues then
        return
    end
    for i = 1, #funcValues do
        local value = funcValues[i]
        local src = value.source
        if src.type == 'function' then
            mergeFunctionReturns(results, src, index)
        end
    end
end

local function getValue(source)
    local results = checkLiteral(source)
                 or checkValue(source)
                 or checkUnary(source)
                 or checkBinary(source)
                 or checkLibraryTypes(source)
                 or checkLibrary(source)
                 or checkSpecialReturn(source)
                 or checkLibraryReturn(source)
    if results then
        return results
    end

    results = {}
    inferByLibraryArg(results, source)
    inferByDef(results, source)
    inferBySet(results, source)
    inferByCall(results, source)
    inferByGetTable(results, source)
    inferByUnary(results, source)
    inferByBinary(results, source)
    inferByCallReturn(results, source)
    inferByPCallReturn(results, source)

    if #results == 0 then
        return nil
    end

    return results
end

function vm.checkTrue(source)
    local values = vm.getValue(source)
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

--- 获取特定类型的字面量值
function vm.getLiteral(source, type)
    local values = vm.getValue(source)
    if not values then
        return nil
    end
    for i = 1, #values do
        local v = values[i]
        if v.value ~= nil then
            if type == nil or v.type == type then
                return v.value
            end
        end
    end
    return nil
end

function vm.isSameValue(a, b)
    local valuesA = vm.getValue(a)
    local valuesB = vm.getValue(b)
    if not valuesA or not valuesB then
        return false
    end
    if valuesA == valuesB then
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

--- 是否包含某种类型
function vm.hasType(source, type)
    local values = vm.getValue(source)
    if not values then
        return false
    end
    for i = 1, #values do
        local value = values[i]
        if value.type == type then
            return true
        end
    end
    return false
end

local function mergeViews(types)
    if #types == 0 then
        return nil
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

function vm.viewType(values)
    if not values then
        return 'any'
    end
    if type(values) ~= 'table' then
        return values or 'any'
    end
    local types = {}
    for i = 1, #values do
        local tp = values[i].type
        if tp and not types[tp] and tp ~= 'any' then
            types[tp] = true
            types[#types+1] = tp
        end
    end
    return mergeViews(types) or 'any'
end

function vm.mergeViews(...)
    local max = select('#', ...)
    local views = {}
    for i = 1, max do
        local view = select(i, ...)
        if view then
            for tp in view:gmatch '[^|]+' do
                if not views[tp] and tp ~= 'any' then
                    views[tp] = true
                    views[#views+1] = tp
                end
            end
        end
    end
    return mergeViews(views)
end

function vm.getType(source)
    local values = vm.getValue(source)
    return vm.viewType(values)
end

--- 获取对象的值
--- 会尝试穿透函数调用
function vm.getValue(source)
    if not source then
        return
    end
    local cache = vm.cache.getValue[source]
    if cache ~= nil then
        return cache
    end
    local unlock = vm.lock('getValue', source)
    if not unlock then
        return
    end
    cache = getValue(source) or false
    vm.cache.getValue[source] = cache
    unlock()
    return cache
end
