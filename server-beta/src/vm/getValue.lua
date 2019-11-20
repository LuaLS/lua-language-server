local vm = require 'vm.vm'

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
    return {
        [1] = o,
        [o] = true,
    }
end

local function insert(t, o)
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
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        if v1 and v2 then
            return alloc {
                type   = 'integer',
                value  = v1 + v2,
                source = source,
            }
        end
        v1 = v1 or vm.getLiteral(source[1], 'number')
        v2 = v2 or vm.getLiteral(source[1], 'number')
        return alloc {
            type   = 'number',
            value  = (v1 and v2) and (v1 + v2) or nil,
            source = source,
        }
    elseif op.type == '-' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        if v1 and v2 then
            return alloc {
                type   = 'integer',
                value  = v1 - v2,
                source = source,
            }
        end
        v1 = v1 or vm.getLiteral(source[1], 'number')
        v2 = v2 or vm.getLiteral(source[1], 'number')
        return alloc {
            type   = 'number',
            value  = (v1 and v2) and (v1 - v2) or nil,
            source = source,
        }
    elseif op.type == '*' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        if v1 and v2 then
            return alloc {
                type   = 'integer',
                value  = v1 * v2,
                source = source,
            }
        end
        v1 = v1 or vm.getLiteral(source[1], 'number')
        v2 = v2 or vm.getLiteral(source[1], 'number')
        return alloc {
            type   = 'number',
            value  = (v1 and v2) and (v1 * v2) or nil,
            source = source,
        }
    elseif op.type == '%' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        if v1 and v2 then
            return alloc {
                type   = 'integer',
                value  = v1 % v2,
                source = source,
            }
        end
        v1 = v1 or vm.getLiteral(source[1], 'number')
        v2 = v2 or vm.getLiteral(source[1], 'number')
        return alloc {
            type   = 'number',
            value  = (v1 and v2) and (v1 % v2) or nil,
            source = source,
        }
    elseif op.type == '//' then
        local v1 = vm.getLiteral(source[1], 'integer')
        local v2 = vm.getLiteral(source[2], 'integer')
        if v1 and v2 then
            return alloc {
                type   = 'integer',
                value  = v1 // v2,
                source = source,
            }
        end
        v1 = v1 or vm.getLiteral(source[1], 'number')
        v2 = v2 or vm.getLiteral(source[1], 'number')
        return alloc {
            type   = 'number',
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
end

local function inferByCall(results, source)
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

local function checkDef(results, source)
    vm.eachDef(source, function (info)
        local src = info.source
        local tp  = vm.getValue(src)
        if tp then
            merge(results, tp)
        end
    end)
end

local function checkLibrary(source)
    local lib = vm.getLibrary(source)
    if not lib then
        return nil
    end
    return alloc {
        type   = lib.type,
        value  = lib.value,
        source = vm.librarySource(lib),
    }
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
    return alloc {
        type   = rtn.type,
        value  = rtn.value,
        source = vm.librarySource(rtn),
    }
end

local function getValue(source)
    local results = checkLiteral(source)
                 or checkValue(source)
                 or checkUnary(source)
                 or checkBinary(source)
                 or checkLibrary(source)
                 or checkLibraryReturn(source)
    if results then
        return results
    end

    results = {}
    checkDef(results, source)
    inferByCall(results, source)
    inferByGetTable(results, source)

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
        if v.type == type and v.value ~= nil then
            return v.value
        end
    end
    return nil
end

function vm.isSameValue(a, b)
    local valuesA = vm.getValue(a)
    local valuesB = vm.getValue(b)
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

function vm.getType(source)
    local values = vm.getValue(source)
    if not values then
        return 'any'
    end
    local types = {}
    for i = 1, #values do
        local tp = values[i].type
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
