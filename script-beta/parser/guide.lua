local util         = require 'utility'
local error        = error
local type         = type
local next         = next
local tostring     = tostring
local print        = print
local ipairs       = ipairs
local tableInsert  = table.insert
local tableUnpack  = table.unpack
local tableRemove  = table.remove
local tableMove    = table.move
local tableSort    = table.sort
local tableConcat  = table.concat
local mathType     = math.type
local pairs        = pairs
local setmetatable = setmetatable
local assert       = assert
local select       = select
local osClock      = os.clock
local DEVELOP      = DEVELOP

local _ENV = nil

local m = {}

local blockTypes = {
    ['while']       = true,
    ['in']          = true,
    ['loop']        = true,
    ['repeat']      = true,
    ['do']          = true,
    ['function']    = true,
    ['ifblock']     = true,
    ['elseblock']   = true,
    ['elseifblock'] = true,
    ['main']        = true,
}

local breakBlockTypes = {
    ['while']       = true,
    ['in']          = true,
    ['loop']        = true,
    ['repeat']      = true,
}

m.childMap = {
    ['main']        = {'#'},
    ['repeat']      = {'#', 'filter'},
    ['while']       = {'filter', '#'},
    ['in']          = {'keys', '#'},
    ['loop']        = {'loc', 'max', 'step', '#'},
    ['if']          = {'#'},
    ['ifblock']     = {'filter', '#'},
    ['elseifblock'] = {'filter', '#'},
    ['elseblock']   = {'#'},
    ['setfield']    = {'node', 'field', 'value'},
    ['setglobal']   = {'value'},
    ['local']       = {'attrs', 'value'},
    ['setlocal']    = {'value'},
    ['return']      = {'#'},
    ['do']          = {'#'},
    ['select']      = {'vararg'},
    ['table']       = {'#'},
    ['tableindex']  = {'index', 'value'},
    ['tablefield']  = {'field', 'value'},
    ['function']    = {'args', '#'},
    ['funcargs']    = {'#'},
    ['setmethod']   = {'node', 'method', 'value'},
    ['getmethod']   = {'node', 'method'},
    ['setindex']    = {'node', 'index', 'value'},
    ['getindex']    = {'node', 'index'},
    ['paren']       = {'exp'},
    ['call']        = {'node', 'args'},
    ['callargs']    = {'#'},
    ['getfield']    = {'node', 'field'},
    ['list']        = {'#'},
    ['binary']      = {1, 2},
    ['unary']       = {1}
}

m.actionMap = {
    ['main']        = {'#'},
    ['repeat']      = {'#'},
    ['while']       = {'#'},
    ['in']          = {'#'},
    ['loop']        = {'#'},
    ['if']          = {'#'},
    ['ifblock']     = {'#'},
    ['elseifblock'] = {'#'},
    ['elseblock']   = {'#'},
    ['do']          = {'#'},
    ['function']    = {'#'},
    ['funcargs']    = {'#'},
}

local TypeSort = {
    ['boolean']  = 1,
    ['string']   = 2,
    ['integer']  = 3,
    ['number']   = 4,
    ['table']    = 5,
    ['function'] = 6,
    ['nil']      = 999,
}

local NIL = setmetatable({'<nil>'}, { __tostring = function () return 'nil' end })

--- 是否是字面量
function m.isLiteral(obj)
    local tp = obj.type
    return tp == 'nil'
        or tp == 'boolean'
        or tp == 'string'
        or tp == 'number'
        or tp == 'table'
end

--- 获取字面量
function m.getLiteral(obj)
    local tp = obj.type
    if     tp == 'boolean' then
        return obj[1]
    elseif tp == 'string' then
        return obj[1]
    elseif tp == 'number' then
        return obj[1]
    end
    return nil
end

--- 寻找父函数
function m.getParentFunction(obj)
    for _ = 1, 1000 do
        obj = obj.parent
        if not obj then
            break
        end
        local tp = obj.type
        if tp == 'function' or tp == 'main' then
            return obj
        end
    end
    return nil
end

--- 寻找所在区块
function m.getBlock(obj)
    for _ = 1, 1000 do
        if not obj then
            return nil
        end
        local tp = obj.type
        if blockTypes[tp] then
            return obj
        end
        obj = obj.parent
    end
    error('guide.getBlock overstack')
end

--- 寻找所在父区块
function m.getParentBlock(obj)
    for _ = 1, 1000 do
        obj = obj.parent
        if not obj then
            return nil
        end
        local tp = obj.type
        if blockTypes[tp] then
            return obj
        end
    end
    error('guide.getParentBlock overstack')
end

--- 寻找所在可break的父区块
function m.getBreakBlock(obj)
    for _ = 1, 1000 do
        obj = obj.parent
        if not obj then
            return nil
        end
        local tp = obj.type
        if breakBlockTypes[tp] then
            return obj
        end
        if tp == 'function' then
            return nil
        end
    end
    error('guide.getBreakBlock overstack')
end

--- 寻找根区块
function m.getRoot(obj)
    for _ = 1, 1000 do
        local parent = obj.parent
        if not parent then
            return obj
        end
        obj = parent
    end
    error('guide.getRoot overstack')
end

--- 寻找函数的不定参数，返回不定参在第几个参数上，以及该参数对象。
--- 如果函数是主函数，则返回`0, nil`。
---@return table
---@return integer
function m.getFunctionVarArgs(func)
    if func.type == 'main' then
        return 0, nil
    end
    if func.type ~= 'function' then
        return nil, nil
    end
    local args = func.args
    if not args then
        return nil, nil
    end
    for i = 1, #args do
        local arg = args[i]
        if arg.type == '...' then
            return i, arg
        end
    end
    return nil, nil
end

--- 获取指定区块中可见的局部变量
---@param block table
---@param name string {comment = '变量名'}
---@param pos integer {comment = '可见位置'}
function m.getLocal(block, name, pos)
    block = m.getBlock(block)
    for _ = 1, 1000 do
        if not block then
            return nil
        end
        local locals = block.locals
        local res
        if not locals then
            goto CONTINUE
        end
        for i = 1, #locals do
            local loc = locals[i]
            if loc.effect > pos then
                break
            end
            if loc[1] == name then
                if not res or res.effect < loc.effect then
                    res = loc
                end
            end
        end
        if res then
            return res, res
        end
        ::CONTINUE::
        block = m.getParentBlock(block)
    end
    error('guide.getLocal overstack')
end

--- 获取指定区块中所有的可见局部变量名称
function m.getVisibleLocals(block, pos)
    local result = {}
    m.eachSourceContain(m.getRoot(block), pos, function (source)
        local locals = source.locals
        if locals then
            for i = 1, #locals do
                local loc = locals[i]
                local name = loc[1]
                if loc.effect <= pos then
                    result[name] = loc
                end
            end
        end
    end)
    return result
end

--- 获取指定区块中可见的标签
---@param block table
---@param name string {comment = '标签名'}
function m.getLabel(block, name)
    block = m.getBlock(block)
    for _ = 1, 1000 do
        if not block then
            return nil
        end
        local labels = block.labels
        if labels then
            local label = labels[name]
            if label then
                return label
            end
        end
        if block.type == 'function' then
            return nil
        end
        block = m.getParentBlock(block)
    end
    error('guide.getLocal overstack')
end

--- 判断source是否包含offset
function m.isContain(source, offset)
    return source.start <= offset and source.finish >= offset - 1
end

--- 判断offset在source的影响范围内
---
--- 主要针对赋值等语句时，key包含value
function m.isInRange(source, offset)
    return (source.vstart or source.start) <= offset and (source.range or source.finish) >= offset - 1
end

--- 添加child
function m.addChilds(list, obj, map)
    local keys = map[obj.type]
    if keys then
        for i = 1, #keys do
            local key = keys[i]
            if key == '#' then
                for i = 1, #obj do
                    list[#list+1] = obj[i]
                end
            else
                list[#list+1] = obj[key]
            end
        end
    end
end

--- 遍历所有包含offset的source
function m.eachSourceContain(ast, offset, callback)
    local list = { ast }
    local mark = {}
    while true do
        local len = #list
        if len == 0 then
            return
        end
        local obj = list[len]
        list[len] = nil
        if not mark[obj] then
            mark[obj] = true
            if m.isInRange(obj, offset) then
                if m.isContain(obj, offset) then
                    local res = callback(obj)
                    if res ~= nil then
                        return res
                    end
                end
                m.addChilds(list, obj, m.childMap)
            end
        end
    end
end

--- 遍历所有指定类型的source
function m.eachSourceType(ast, type, callback)
    local cache = ast.typeCache
    if not cache then
        cache = {}
        ast.typeCache = cache
        m.eachSource(ast, function (source)
            local tp = source.type
            if not tp then
                return
            end
            local myCache = cache[tp]
            if not myCache then
                myCache = {}
                cache[tp] = myCache
            end
            myCache[#myCache+1] = source
        end)
    end
    local myCache = cache[type]
    if not myCache then
        return
    end
    for i = 1, #myCache do
        callback(myCache[i])
    end
end

--- 遍历所有的source
function m.eachSource(ast, callback)
    local list = { ast }
    local mark = {}
    local index = 1
    while true do
        local obj = list[index]
        if not obj then
            return
        end
        list[index] = false
        index = index + 1
        if not mark[obj] then
            mark[obj] = true
            callback(obj)
            m.addChilds(list, obj, m.childMap)
        end
    end
end

--- 获取指定的 special
function m.eachSpecialOf(ast, name, callback)
    local root = m.getRoot(ast)
    if not root.specials then
        return
    end
    local specials = root.specials[name]
    if not specials then
        return
    end
    for i = 1, #specials do
        callback(specials[i])
    end
end

--- 获取偏移对应的坐标
---@param lines table
---@return integer {name = 'row'}
---@return integer {name = 'col'}
function m.positionOf(lines, offset)
    if offset < 1 then
        return 0, 0
    end
    local lastLine = lines[#lines]
    if offset > lastLine.finish then
        return #lines, lastLine.finish - lastLine.start + 1
    end
    local min = 1
    local max = #lines
    for _ = 1, 100 do
        if max <= min then
            local line = lines[min]
            return min, offset - line.start + 1
        end
        local row = (max - min) // 2 + min
        local line = lines[row]
        if offset < line.start then
            max = row - 1
        elseif offset > line.finish then
            min = row + 1
        else
            return row, offset - line.start + 1
        end
    end
    error('Stack overflow!')
end

--- 获取坐标对应的偏移
---@param lines table
---@param row integer
---@param col integer
---@return integer {name = 'offset'}
function m.offsetOf(lines, row, col)
    if row < 1 then
        return 0
    end
    if row > #lines then
        local lastLine = lines[#lines]
        return lastLine.finish
    end
    local line = lines[row]
    local len = line.finish - line.start + 1
    if col < 0 then
        return line.start
    elseif col > len then
        return line.finish
    else
        return line.start + col - 1
    end
end

function m.lineContent(lines, text, row)
    local line = lines[row]
    if not line then
        return ''
    end
    return text:sub(line.start, line.finish)
end

function m.lineRange(lines, row)
    local line = lines[row]
    if not line then
        return 0, 0
    end
    return line.start, line.finish
end

function m.getNameOfLiteral(obj)
    if not obj then
        return nil
    end
    local tp = obj.type
    if tp == 'string' then
        return obj[1]
    end
    return nil
end

function m.getName(obj)
    local tp = obj.type
    if tp == 'getglobal'
    or tp == 'setglobal' then
        return obj[1]
    elseif tp == 'local'
    or     tp == 'getlocal'
    or     tp == 'setlocal' then
        return obj[1]
    elseif tp == 'getfield'
    or     tp == 'setfield'
    or     tp == 'tablefield' then
        return obj.field[1]
    elseif tp == 'getmethod'
    or     tp == 'setmethod' then
        return obj.method[1]
    elseif tp == 'getindex'
    or     tp == 'setindex'
    or     tp == 'tableindex' then
        return m.getNameOfLiteral(obj.index)
    elseif tp == 'field'
    or     tp == 'method' then
        return obj[1]
    end
    return m.getNameOfLiteral(obj)
end

function m.getKeyNameOfLiteral(obj)
    if not obj then
        return nil
    end
    local tp = obj.type
    if tp == 'field'
    or     tp == 'method' then
        return 's|' .. obj[1]
    elseif tp == 'string' then
        local s = obj[1]
        if s then
            return 's|' .. s
        else
            return s
        end
    elseif tp == 'number' then
        local n = obj[1]
        if n then
            return ('n|%s'):format(util.viewLiteral(obj[1]))
        else
            return 'n'
        end
    elseif tp == 'boolean' then
        local b = obj[1]
        if b then
            return 'b|' .. tostring(b)
        else
            return 'b'
        end
    end
    return nil
end

function m.getKeyName(obj)
    local tp = obj.type
    if tp == 'getglobal'
    or tp == 'setglobal' then
        return 's|' .. obj[1]
    elseif tp == 'local'
    or     tp == 'getlocal'
    or     tp == 'setlocal' then
        return 'l|' .. obj[1]
    elseif tp == 'getfield'
    or     tp == 'setfield'
    or     tp == 'tablefield' then
        if obj.field then
            return 's|' .. obj.field[1]
        end
    elseif tp == 'getmethod'
    or     tp == 'setmethod' then
        if obj.method then
            return 's|' .. obj.method[1]
        end
    elseif tp == 'getindex'
    or     tp == 'setindex'
    or     tp == 'tableindex' then
        return m.getKeyNameOfLiteral(obj.index)
    elseif tp == 'field'
    or     tp == 'method' then
        return 's|' .. obj[1]
    end
    return m.getKeyNameOfLiteral(obj)
end

function m.getSimpleName(obj)
    if obj.type == 'call' then
        local key = obj.args[2]
        return m.getKeyName(key)
    elseif obj.type == 'table' then
        return ('t|%p'):format(obj)
    elseif obj.type == 'select' then
        return ('v|%p'):format(obj)
    end
    return m.getKeyName(obj)
end

function m.getENV(ast)
    if ast.type ~= 'main' then
        return nil
    end
    return ast.locals[1]
end

--- 测试 a 到 b 的路径（不经过函数，不考虑 goto），
--- 每个路径是一个 block 。
---
--- 如果 a 在 b 的前面，返回 `"before"` 加上 2个`list<block>`
---
--- 如果 a 在 b 的后面，返回 `"after"` 加上 2个`list<block>`
---
--- 否则返回 `false`
---
--- 返回的2个 `list` 分别为基准block到达 a 与 b 的路径。
---@param a table
---@param b table
---@return string|boolean mode
---@return table|nil pathA
---@return table|nil pathB
function m.getPath(a, b, sameFunction)
    --- 首先测试双方在同一个函数内
    if not sameFunction and m.getParentFunction(a) ~= m.getParentFunction(b) then
        return false
    end
    local mode
    local objA
    local objB
    if a.finish < b.start then
        mode = 'before'
        objA = a
        objB = b
    elseif a.start > b.finish then
        mode = 'after'
        objA = b
        objB = a
    else
        return 'equal', {}, {}
    end
    local pathA = {}
    local pathB = {}
    for _ = 1, 1000 do
        objA = m.getParentBlock(objA)
        pathA[#pathA+1] = objA
        if (not sameFunction and objA.type == 'function') or objA.type == 'main' then
            break
        end
    end
    for _ = 1, 1000 do
        objB = m.getParentBlock(objB)
        pathB[#pathB+1] = objB
        if (not sameFunction and objA.type == 'function') or objB.type == 'main' then
            break
        end
    end
    -- pathA: {1, 2, 3, 4, 5}
    -- pathB: {5, 6, 2, 3}
    local top = #pathB
    local start
    for i = #pathA, 1, -1 do
        local currentBlock = pathA[i]
        if currentBlock == pathB[top] then
            start = i
            break
        end
    end
    if not start then
        return nil
    end
    -- pathA: {   1, 2, 3}
    -- pathB: {5, 6, 2, 3}
    local extra = 0
    local align = top - start
    for i = start, 1, -1 do
        local currentA = pathA[i]
        local currentB = pathB[i+align]
        if currentA ~= currentB then
            extra = i
            break
        end
    end
    -- pathA: {1}
    local resultA = {}
    for i = extra, 1, -1 do
        resultA[#resultA+1] = pathA[i]
    end
    -- pathB: {5, 6}
    local resultB = {}
    for i = extra + align, 1, -1 do
        resultB[#resultB+1] = pathB[i]
    end
    return mode, resultA, resultB
end

-- 根据语法，单步搜索定义
local function stepRefOfLocal(loc, mode)
    local results = {}
    if loc.start ~= 0 then
        results[#results+1] = loc
    end
    local refs = loc.ref
    if not refs then
        return results
    end
    for i = 1, #refs do
        local ref = refs[i]
        if ref.start == 0 then
            goto CONTINUE
        end
        if mode == 'def' then
            if ref.type == 'local'
            or ref.type == 'setlocal' then
                results[#results+1] = ref
            end
        else
            if ref.type == 'local'
            or ref.type == 'setlocal'
            or ref.type == 'getlocal' then
                results[#results+1] = ref
            end
        end
        ::CONTINUE::
    end
    return results
end

local function stepRefOfLabel(label, mode)
    local results = { label }
    if not label or mode == 'def' then
        return results
    end
    local refs = label.ref
    for i = 1, #refs do
        local ref = refs[i]
        results[#results+1] = ref
    end
    return results
end

local function stepRefOfGlobal(obj, mode)
    local results = {}
    local name = m.getKeyName(obj)
    local refs = obj.node.ref
    for i = 1, #refs do
        local ref = refs[i]
        if m.getKeyName(ref) == name then
            if mode == 'def' then
                if obj == 'setglobal' then
                    results[#results+1] = ref
                end
            else
                results[#results+1] = ref
            end
        end
    end
    return results
end

function m.getStepRef(obj, mode)
    if obj.type == 'getlocal'
    or obj.type == 'setlocal' then
        return stepRefOfLocal(obj.node, mode)
    end
    if obj.type == 'local' then
        return stepRefOfLocal(obj, mode)
    end
    if obj.type == 'label' then
        return stepRefOfLabel(obj, mode)
    end
    if obj.type == 'goto' then
        return stepRefOfLabel(obj.node, mode)
    end
    if obj.type == 'getglobal'
    or obj.type == 'setglobal' then
        return stepRefOfGlobal(obj, mode)
    end
    return nil
end

-- 根据语法，单步搜索field
local function stepFieldOfLocal(loc)
    local results = {}
    local refs = loc.ref
    for i = 1, #refs do
        local ref = refs[i]
        if ref.type == 'setglobal'
        or ref.type == 'getglobal' then
            results[#results+1] = ref
        elseif ref.type == 'getlocal' then
            local nxt = ref.next
            if nxt then
                if nxt.type == 'setfield'
                or nxt.type == 'getfield'
                or nxt.type == 'setmethod'
                or nxt.type == 'getmethod'
                or nxt.type == 'setindex'
                or nxt.type == 'getindex' then
                    results[#results+1] = nxt
                end
            end
        end
    end
    return results
end
local function stepFieldOfTable(tbl)
    local result = {}
    for i = 1, #tbl do
        result[i] = tbl[i]
    end
    return result
end
function m.getStepField(obj)
    if obj.type == 'getlocal'
    or obj.type == 'setlocal' then
        return stepFieldOfLocal(obj.node)
    end
    if obj.type == 'local' then
        return stepFieldOfLocal(obj)
    end
    if obj.type == 'table' then
        return stepFieldOfTable(obj)
    end
end

local function convertSimpleList(list)
    local simple = {}
    for i = #list, 1, -1 do
        local c = list[i]
        if c.special == '_G' then
            simple.global = true
        else
            simple[#simple+1] = m.getSimpleName(c)
        end
        if c.type == 'getglobal'
        or c.type == 'setglobal' then
            simple.global = true
        end
        if #simple <= 1 then
            if simple.global then
                simple.first = m.getLocal(c, '_ENV', c.start)
            elseif c.type == 'setlocal'
            or     c.type == 'getlocal' then
                simple.first = c.node
            else
                simple.first = c
            end
        end
    end
    return simple
end

-- 搜索 `a.b.c` 的等价表达式
local function buildSimpleList(obj, max)
    local list = {}
    local cur = obj
    local limit = max and (max + 1) or 11
    for i = 1, max or limit do
        if i == limit then
            return nil
        end
        if cur.type == 'setfield'
        or cur.type == 'getfield'
        or cur.type == 'setmethod'
        or cur.type == 'getmethod'
        or cur.type == 'setindex'
        or cur.type == 'getindex' then
            list[i] = cur
            cur = cur.node
        elseif cur.type == 'tablefield'
        or     cur.type == 'tableindex' then
            list[i] = cur
            cur = cur.parent.parent
            if cur.type == 'return' then
                list[i+1] = list[i].parent
                break
            end
        elseif cur.type == 'getlocal'
        or     cur.type == 'setlocal'
        or     cur.type == 'local' then
            list[i] = cur
            break
        elseif cur.type == 'setglobal'
        or     cur.type == 'getglobal' then
            list[i] = cur
            break
        elseif cur.type == 'select' then
            list[i] = cur
            break
        elseif cur.type == 'function'
        or     cur.type == 'main' then
            break
        else
            return nil
        end
    end
    return convertSimpleList(list)
end

function m.getSimple(obj, max)
    local simpleList
    if obj.type == 'getfield'
    or obj.type == 'setfield'
    or obj.type == 'getmethod'
    or obj.type == 'setmethod'
    or obj.type == 'getindex'
    or obj.type == 'setindex'
    or obj.type == 'local'
    or obj.type == 'getlocal'
    or obj.type == 'setlocal'
    or obj.type == 'setglobal'
    or obj.type == 'getglobal'
    or obj.type == 'tableindex'
    or obj.type == 'select' then
        simpleList = buildSimpleList(obj, max)
    elseif obj.type == 'field'
    or     obj.type == 'method' then
        simpleList = buildSimpleList(obj.parent, max)
    end
    return simpleList
end

m.Version = 53

function m.status(parentStatus, interface)
    local status = {
        cache     = parentStatus and parentStatus.cache       or {
            count = 0,
        },
        depth     = parentStatus and parentStatus.depth       or 0,
        interface = parentStatus and parentStatus.interface   or {},
        locks     = parentStatus and parentStatus.locks       or {},
        index     = parentStatus and (parentStatus.index + 1) or 1,
        results   = {},
    }
    status.lock = status.locks[status.index] or {}
    status.locks[status.index] = status.lock
    if interface then
        for k, v in pairs(interface) do
            status.interface[k] = v
        end
    end
    return status
end

function m.copyStatusResults(a, b)
    local ra = a.results
    local rb = b.results
    for i = 1, #rb do
        ra[#ra+1] = rb[i]
    end
end

--- 根据函数的调用参数，获取：调用，参数索引
function m.getCallAndArgIndex(callarg)
    local callargs = callarg.parent
    if not callargs or callargs.type ~= 'callargs' then
        return nil
    end
    local index
    for i = 1, #callargs do
        if callargs[i] == callarg then
            index = i
            break
        end
    end
    local call = callargs.parent
    return call, index
end

--- 根据函数调用的返回值，获取：调用的函数，参数列表，自己是第几个返回值
function m.getCallValue(source)
    local value = m.getObjectValue(source) or source
    if not value then
        return
    end
    local call, index
    if value.type == 'call' then
        call  = value
        index = 1
    elseif value.type == 'select' then
        call  = value.vararg
        index = value.index
        if call.type ~= 'call' then
            return
        end
    else
        return
    end
    return call.node, call.args, index
end

function m.getNextRef(ref)
    local nextRef = ref.next
    if nextRef then
        if nextRef.type == 'setfield'
        or nextRef.type == 'getfield'
        or nextRef.type == 'setmethod'
        or nextRef.type == 'getmethod'
        or nextRef.type == 'setindex'
        or nextRef.type == 'getindex' then
            return nextRef
        end
    else
        -- 穿透 rawget 与 rawset
        local call, index = m.getCallAndArgIndex(ref)
        if call then
            if call.node.special == 'rawset' and index == 1 then
                return call
            end
            if call.node.special == 'rawget' and index == 1 then
                return call
            end
        end
    end

    return nil
end

function m.checkSameSimpleInValueOfTable(status, value, start, queue)
    if value.type ~= 'table' then
        return
    end
    for i = 1, #value do
        local field = value[i]
        queue[#queue+1] = {
            obj   = field,
            start = start + 1,
        }
    end
end

function m.searchFields(status, obj, key, interface)
    if obj.type == 'table' then
        local keyName = key and ('s|' .. key)
        local results = {}
        for i = 1, #obj do
            local field = obj[i]
            if not keyName or keyName == m.getSimpleName(field) then
                results[#results+1] = field
            end
        end
        return results
    else
        local newStatus = m.status(status, interface)
        local simple = m.getSimple(obj, 1)
        if not simple then
            return {}
        end
        simple[#simple+1] = key and ('s|' .. key) or '*'
        m.searchSameFields(newStatus, simple, 'field')
        local results = newStatus.results
        m.cleanResults(results)
        return results
    end
end

function m.getObjectValue(obj)
    while obj.type == 'paren' do
        obj = obj.exp
    end
    if obj.value then
        return obj.value
    end
    if obj.type == 'field'
    or obj.type == 'method' then
        return obj.parent.value
    end
    if obj.type == 'call' then
        if obj.node.special == 'rawset' then
            return obj.args[3]
        end
    end
    if obj.type == 'select' then
        return obj
    end
    return nil
end

function m.checkSameSimpleInValueInMetaTable(status, mt, start, queue)
    local indexes = m.searchFields(status, mt, '__index')
    if not indexes then
        return
    end
    local refsStatus = m.status(status)
    for i = 1, #indexes do
        local indexValue = m.getObjectValue(indexes[i])
        if indexValue then
            m.searchRefs(refsStatus, indexValue, 'ref')
        end
    end
    for i = 1, #refsStatus.results do
        local obj = refsStatus.results[i]
        queue[#queue+1] = {
            obj   = obj,
            start = start,
            force = true,
        }
    end
end
function m.checkSameSimpleInValueOfSetMetaTable(status, func, start, queue)
    if not func or func.special ~= 'setmetatable' then
        return
    end
    local call = func.parent
    local args = call.args
    local obj = args[1]
    local mt = args[2]
    if obj then
        queue[#queue+1] = {
            obj   = obj,
            start = start,
            force = true,
        }
    end
    if mt then
        m.checkSameSimpleInValueInMetaTable(status, mt, start, queue)
    end
end

function m.checkSameSimpleInValueOfCallMetaTable(status, call, start, queue)
    if call.type == 'call' then
        m.checkSameSimpleInValueOfSetMetaTable(status, call.node, start, queue)
    end
end

function m.checkSameSimpleInArg1OfSetMetaTable(status, obj, start, queue)
    local args = obj.parent
    if not args or args.type ~= 'callargs' then
        return
    end
    if args[1] ~= obj then
        return
    end
    local mt = args[2]
    if mt then
        if m.checkValueMark(status, obj, mt) then
            return
        end
        m.checkSameSimpleInValueInMetaTable(status, mt, start, queue)
    end
end

function m.searchSameMethodCrossSelf(ref, mark)
    local selfNode
    if ref.tag == 'self' then
        selfNode = ref
    else
        if ref.type == 'getlocal'
        or ref.type == 'setlocal' then
            local node = ref.node
            if node.tag == 'self' then
                selfNode = node
            end
        end
    end
    if selfNode then
        if mark[selfNode] then
            return nil
        end
        mark[selfNode] = true
        return selfNode.method.node
    end
end

function m.searchSameMethod(ref, mark)
    if mark['method'] then
        return nil
    end
    local nxt = ref.next
    if not nxt then
        return nil
    end
    if nxt.type == 'setmethod' then
        mark['method'] = true
        return ref
    end
    return nil
end

function m.searchSameFieldsCrossMethod(status, ref, start, queue)
    local mark = status.cache.crossMethodMark
    if not mark then
        mark = {}
        status.cache.crossMethodMark = mark
    end
    local method = m.searchSameMethod(ref, mark)
                or m.searchSameMethodCrossSelf(ref, mark)
    if not method then
        return
    end
    local methodStatus = m.status(status)
    m.searchRefs(methodStatus, method, 'ref')
    for _, md in ipairs(methodStatus.results) do
        queue[#queue+1] = {
            obj   = md,
            start = start,
            force = true,
        }
        local nxt = md.next
        if not nxt then
            goto CONTINUE
        end
        if nxt.type == 'setmethod' then
            local func = nxt.value
            if not func then
                goto CONTINUE
            end
            local selfNode = func.locals and func.locals[1]
            if not selfNode or not selfNode.ref then
                goto CONTINUE
            end
            if mark[selfNode] then
                goto CONTINUE
            end
            mark[selfNode] = true
            for _, selfRef in ipairs(selfNode.ref) do
                queue[#queue+1] = {
                    obj   = selfRef,
                    start = start,
                    force = true,
                }
            end
        end
        ::CONTINUE::
    end
end

function m.checkSameSimpleInCallInSameFile(status, func, args, index)
    local newStatus = m.status(status)
    m.searchRefs(newStatus, func, 'def')
    local results = {}
    for _, def in ipairs(newStatus.results) do
        local value = m.getObjectValue(def) or def
        if value.type == 'function' then
            local returns = value.returns
            if returns then
                for _, ret in ipairs(returns) do
                    local exp = ret[index]
                    if exp then
                        results[#results+1] = exp
                    end
                end
            end
        end
    end
    return results
end

function m.checkSameSimpleInCall(status, ref, start, queue, mode)
    local func, args, index = m.getCallValue(ref)
    if not func then
        return
    end
    if m.checkCallMark(status, func.parent, true) then
        return
    end
    -- 检查赋值是 semetatable() 的情况
    m.checkSameSimpleInValueOfSetMetaTable(status, func, start, queue)
    -- 检查赋值是 func() 的情况
    local objs = m.checkSameSimpleInCallInSameFile(status, func, args, index)
    if status.interface.call then
        local cobjs = status.interface.call(func, args, index)
        if cobjs then
            for _, obj in ipairs(cobjs) do
                if not m.checkReturnMark(status, obj) then
                    objs[#objs+1] = obj
                end
            end
        end
    end
    local newStatus = m.status(status)
    for _, obj in ipairs(objs) do
        m.searchRefs(newStatus, obj, mode)
        queue[#queue+1] = {
            obj   = obj,
            start = start,
            force = true,
        }
    end
    for _, obj in ipairs(newStatus.results) do
        queue[#queue+1] = {
            obj   = obj,
            start = start,
            force = true,
        }
    end
end

function m.checkSameSimpleInGlobal(status, name, start, queue)
    if not name then
        return
    end
    if not status.interface.global then
        return
    end
    --if not status.cache.globalMark then
    --    status.cache.globalMark = {}
    --end
    --if status.cache.globalMark[name] then
    --    return
    --end
    --status.cache.globalMark[name] = true
    local objs = status.interface.global(name)
    if objs then
        for _, obj in ipairs(objs) do
            queue[#queue+1] = {
                obj   = obj,
                start = start,
                force = true,
            }
        end
    end
end

function m.checkValueMark(status, a, b)
    if not status.cache.valueMark then
        status.cache.valueMark = {}
    end
    if status.cache.valueMark[a]
    or status.cache.valueMark[b] then
        return true
    end
    status.cache.valueMark[a] = true
    status.cache.valueMark[b] = true
    return false
end

function m.checkCallMark(status, a, mark)
    if not status.cache.callMark then
        status.cache.callMark = {}
    end
    if mark then
        status.cache.callMark[a] = mark
    else
        return status.cache.callMark[a]
    end
    return false
end

function m.checkReturnMark(status, a, mark)
    if not status.cache.returnMark then
        status.cache.returnMark = {}
    end
    if mark then
        status.cache.returnMark[a] = mark
    else
        return status.cache.returnMark[a]
    end
    return false
end

function m.searchSameFieldsInValue(status, ref, start, queue, mode)
    local value = m.getObjectValue(ref)
    if not value then
        return
    end
    if m.checkValueMark(status, ref, value) then
        return
    end
    local newStatus = m.status(status)
    m.searchRefs(newStatus, value, mode)
    for _, res in ipairs(newStatus.results) do
        queue[#queue+1] = {
            obj   = res,
            start = start,
            force = true,
        }
    end
    queue[#queue+1] = {
        obj   = value,
        start = start,
        force = true,
    }
    -- 检查形如 a = f() 的分支情况
    m.checkSameSimpleInCall(status, value, start, queue, mode)
    -- 检查自己是字面量表的情况
    --m.checkSameSimpleInValueOfTable(status, value, start, queue)
end

function m.checkSameSimpleAsTableField(status, ref, start, queue)
    local parent = ref.parent
    if parent.type ~= 'tablefield' then
        return
    end
    if m.checkValueMark(status, parent, ref) then
        return
    end
    local newStatus = m.status(status)
    m.searchRefs(newStatus, parent.field, 'ref')
    for _, res in ipairs(newStatus.results) do
        queue[#queue+1] = {
            obj   = res,
            start = start,
            force = true,
        }
    end
end

function m.checkSearchLevel(status)
    -- TODO 限制向前搜索的次数
    do return false end
    status.cache.back = status.cache.back or 0
    if status.cache.back >= (status.interface.searchLevel or 0) then
        return true
    end
    status.cache.back = status.cache.back + 1
    return false
end

function m.checkSameSimpleAsReturn(status, ref, start, queue)
    if ref.parent.type ~= 'return' then
        return
    end
    if ref.parent.parent.type ~= 'main' then
        return
    end
    if m.checkSearchLevel(status) then
        return
    end
    local newStatus = m.status(status)
    m.searchRefsAsFunctionReturn(newStatus, ref, 'ref')
    for _, res in ipairs(newStatus.results) do
        if not m.checkCallMark(status, res) then
            queue[#queue+1] = {
                obj   = res,
                start = start,
                force = true,
            }
        end
    end
end

function m.checkSameSimpleAsSetValue(status, ref, start, queue)
    if ref.type == 'select' then
        return
    end
    local parent = ref.parent
    if m.getObjectValue(parent) ~= ref then
        return
    end
    if m.checkValueMark(status, ref, parent) then
        return
    end
    if m.checkSearchLevel(status) then
        return
    end
    local obj
    if     parent.type == 'local'
    or     parent.type == 'setglobal'
    or     parent.type == 'setlocal' then
        obj = parent
    elseif parent.type == 'setfield' then
        obj = parent.field
    elseif parent.type == 'setmethod' then
        obj = parent.method
    end
    if not obj then
        return
    end
    local newStatus = m.status(status)
    m.searchRefs(newStatus, obj, 'ref')
    for _, res in ipairs(newStatus.results) do
        queue[#queue+1] = {
            obj   = res,
            start = start,
            force = true,
        }
    end
end

function m.pushResult(status, mode, ref, simple)
    local results = status.results
    if mode == 'def' then
        if ref.type == 'setglobal'
        or ref.type == 'setlocal'
        or ref.type == 'local' then
            results[#results+1] = ref
        elseif ref.type == 'setfield'
        or     ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset' then
                results[#results+1] = ref
            end
        elseif ref.type == 'table' then
            results[#results+1] = ref
        end
        if ref.parent.type == 'return' then
            if m.getParentFunction(ref) ~= m.getParentFunction(simple.first) then
                results[#results+1] = ref
            end
        end
    elseif mode == 'ref' then
        if ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod'
        or     ref.type == 'getmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'getindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'setglobal'
        or     ref.type == 'getglobal'
        or     ref.type == 'local'
        or     ref.type == 'setlocal'
        or     ref.type == 'getlocal' then
            results[#results+1] = ref
        elseif ref.type == 'function' then
            results[#results+1] = ref
        elseif ref.type == 'table' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset'
            or ref.node.special == 'rawget' then
                results[#results+1] = ref
            end
        end
        if ref.parent.type == 'return' then
            results[#results+1] = ref
        end
    elseif mode == 'field' then
        if ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'tablefield' then
            results[#results+1] = ref
        elseif ref.type == 'setmethod'
        or     ref.type == 'getmethod' then
            results[#results+1] = ref
        elseif ref.type == 'setindex'
        or     ref.type == 'getindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref
        elseif ref.type == 'setglobal'
        or     ref.type == 'getglobal'
        or     ref.type == 'local'
        or     ref.type == 'setlocal'
        or     ref.type == 'getlocal' then
            results[#results+1] = ref
        elseif ref.type == 'table' then
            results[#results+1] = ref
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset'
            or ref.node.special == 'rawget' then
                results[#results+1] = ref
            end
        end
    end
end

function m.checkSameSimple(status, simple, data, mode, results, queue)
    local ref    = data.obj
    local start  = data.start
    local force  = data.force
    if start > #simple then
        return
    end
    for i = start, #simple do
        local sm = simple[i]
        if sm ~= '*' and not force and m.getSimpleName(ref) ~= sm then
            return
        end
        force = false
        local cmode = mode
        if i < #simple then
            cmode = 'ref'
        end
        -- 穿透 self:func 与 mt:func
        m.searchSameFieldsCrossMethod(status, ref, i, queue)
        -- 穿透赋值
        m.searchSameFieldsInValue(status, ref, i, queue, cmode)
        -- 检查自己是字面量表的情况
        m.checkSameSimpleInValueOfTable(status, ref, i, queue)
        -- 检查自己作为 setmetatable 第一个参数的情况
        m.checkSameSimpleInArg1OfSetMetaTable(status, ref, i, queue)
        -- 检查自己作为 setmetatable 调用的情况
        m.checkSameSimpleInValueOfCallMetaTable(status, ref, i, queue)
        if cmode ~= 'def' then
            -- 检查形如 { a = f } 的情况
            m.checkSameSimpleAsTableField(status, ref, i, queue)
            -- 检查形如 return m 的情况
            m.checkSameSimpleAsReturn(status, ref, i, queue)
            -- 检查形如 a = f 的情况
            m.checkSameSimpleAsSetValue(status, ref, i, queue)
        end
        if i == #simple then
            break
        end
        ref = m.getNextRef(ref)
        if not ref then
            return
        end
    end
    m.pushResult(status, mode, ref, simple)
end

function m.searchSameFields(status, simple, mode)
    local first = simple.first
    local fref = first and first.ref
    local queue = {}
    if fref then
        for i = 1, #fref do
            local ref = fref[i]
            queue[i] = {
                obj   = ref,
                start = 1,
            }
        end
    end
    -- 对初始对象进行预处理
    if simple.global then
        for i = 1, #queue do
            local data = queue[i]
            local obj  = data.obj
            local nxt  = m.getNextRef(obj)
            if nxt and obj.special == '_G' then
                data.obj = nxt
            end
        end
        if first then
            if first.tag == '_ENV' then
                -- 检查全局变量的分支情况，需要业务层传入 interface.global
                m.checkSameSimpleInGlobal(status, simple[1], 1, queue)
            else
                simple.global = nil
                tableInsert(simple, 1, 'l|_ENV')
                queue[#queue+1] = {
                    obj   = first,
                    start = 1,
                }
            end
        end
    else
        queue[#queue+1] = {
            obj   = first,
            start = 1,
        }
    end
    for i = 1, 999 do
        local data = queue[i]
        if not data then
            return
        end
        if not status.lock[data.obj] then
            status.lock[data.obj] = true
            status.cache.count = status.cache.count + 1
            m.checkSameSimple(status, simple, data, mode, status.results, queue)
        end
    end
end

function m.getCallerInSameFile(status, func)
    -- 搜索所有所在函数的调用者
    local funcRefs = m.status(status)
    m.searchRefOfValue(funcRefs, func)

    local calls = {}
    if #funcRefs.results == 0 then
        return calls
    end
    for _, res in ipairs(funcRefs.results) do
        local call = res.parent
        if call.type == 'call' then
            calls[#calls+1] = call
        end
    end
    return calls
end

function m.getCallerCrossFiles(status, main)
    if status.interface.link then
        return status.interface.link(main.uri)
    end
    return {}
end

function m.searchRefsAsFunctionReturn(status, obj, mode)
    if mode == 'def' then
        return
    end
    if m.checkReturnMark(status, obj, true) then
        return
    end
    status.results[#status.results+1] = obj
    -- 搜索所在函数
    local currentFunc = m.getParentFunction(obj)
    local rtn = obj.parent
    if rtn.type ~= 'return' then
        return
    end
    -- 看看他是第几个返回值
    local index
    for i = 1, #rtn do
        if obj == rtn[i] then
            index = i
            break
        end
    end
    if not index then
        return
    end
    local calls
    if currentFunc.type == 'main' then
        calls = m.getCallerCrossFiles(status, currentFunc)
    else
        calls = m.getCallerInSameFile(status, currentFunc)
    end
    -- 搜索调用者的返回值
    if #calls == 0 then
        return
    end
    local selects = {}
    for i = 1, #calls do
        local parent = calls[i].parent
        if parent.type == 'select' and parent.index == index then
            selects[#selects+1] = parent.parent
        end
        local extParent = calls[i].extParent
        if extParent then
            for j = 1, #extParent do
                local ext = extParent[j]
                if ext.type == 'select' and ext.index == index then
                    selects[#selects+1] = ext.parent
                end
            end
        end
    end
    -- 搜索调用者的引用
    for i = 1, #selects do
        m.searchRefs(status, selects[i], 'ref')
    end
end

function m.searchRefsAsFunctionSet(status, obj, mode)
    local parent = obj.parent
    if not parent then
        return
    end
    if parent.type == 'local'
    or parent.type == 'setlocal'
    or parent.type == 'setglobal'
    or parent.type == 'setfield'
    or parent.type == 'setmethod'
    or parent.type == 'setindex'
    or parent.type == 'tableindex'
    or parent.type == 'tablefield' then
        m.searchRefs(status, parent, mode)
    end
end

function m.searchRefsAsFunction(status, obj, mode)
    if obj.type ~= 'function' then
        return
    end
    m.searchRefsAsFunctionSet(status, obj, mode)
    -- 检查自己作为返回函数时的引用
    m.searchRefsAsFunctionReturn(status, obj, mode)
end

function m.cleanResults(results)
    local mark = {}
    for i = #results, 1, -1 do
        local res = results[i]
        if res.tag == 'self'
        or mark[res] then
            results[i] = results[#results]
            results[#results] = nil
        else
            mark[res] = true
        end
    end
end

function m.getRefCache(status, obj, mode)
    if not status.interface.cache then
        return
    end
    if obj.type == 'getglobal'
    or obj.type == 'setglobal' then
        local name = m.getKeyName(obj)
        return status.interface.cache(name, mode)
    else
        return status.interface.cache(obj, mode)
    end
end

function m.searchRefs(status, obj, mode)
    status.depth = status.depth + 1

    local cache, makeCache = m.getRefCache(status, obj, mode)
    if cache then
        for i = 1, #cache do
            status.results[#status.results+1] = cache[i]
        end
        return
    end

    -- 检查单步引用
    local res = m.getStepRef(obj, mode)
    if res then
        for i = 1, #res do
            status.results[#status.results+1] = res[i]
        end
    end
    -- 检查simple
    if status.depth <= 10 then
        local simple = m.getSimple(obj)
        if simple then
            m.searchSameFields(status, simple, mode)
        end
    elseif m.debugMode then
        error('stack overflow')
    end

    status.depth = status.depth - 1

    m.cleanResults(status.results)

    if makeCache then
        makeCache(status.results)
    end
end

function m.searchRefOfValue(status, obj)
    local var = obj.parent
    if var.type == 'local'
    or var.type == 'set' then
        return m.searchRefs(status, var, 'ref')
    end
end

function m.allocInfer(o)
    if type(o.type) == 'table' then
        local infers = {}
        for i = 1, #o.type do
            infers[i] = {
                type   = o.type[i],
                value  = o.value,
                source = o.source,
            }
        end
        return infers
    else
        return {
            [1] = o,
        }
    end
end

function m.mergeTypes(types)
    local results = {}
    local mark = {}
    for i = 1, #types do
        local tp = types[i]
        if not mark[tp] and tp ~= 'any' then
            mark[tp] = true
            results[#results+1] = tp
        end
    end
    if #results == 0 then
        return 'any'
    end
    if #results == 1 then
        return results[1]
    end
    tableSort(results, function (a, b)
        local sa = TypeSort[a]
        local sb = TypeSort[b]
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
    return tableConcat(results, '|')
end

function m.viewInferType(infers)
    if not infers then
        return 'any'
    end
    local mark = {}
    local types = {}
    for i = 1, #infers do
        local tp = infers[i].type
        if not mark[tp] and tp ~= 'any' then
            types[#types+1] = tp
        end
        mark[tp] = true
    end
    return m.mergeTypes(types)
end

function m.checkTrue(status, source)
    local newStatus = m.status(status)
    m.searchInfer(newStatus, source)
    -- 当前认为的结果
    local current
    for _, infer in ipairs(newStatus.results) do
        -- 新的结果
        local new
        if infer.type == 'nil' then
            new = false
        elseif infer.type == 'boolean' then
            if infer.value == true then
                new = true
            elseif infer.value == false then
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
function m.getInferLiteral(status, source, type)
    local newStatus = m.status(status)
    m.searchInfer(newStatus, source)
    for _, infer in ipairs(newStatus.results) do
        if infer.value ~= nil then
            if type == nil or infer.type == type then
                return infer.value
            end
        end
    end
    return nil
end

--- 是否包含某种类型
function m.hasType(status, source, type)
    m.searchInfer(status, source)
    for _, infer in ipairs(status.results) do
        if infer.type == type then
            return true
        end
    end
    return false
end

function m.isSameValue(status, a, b)
    local statusA = m.status(status)
    m.searchInfer(statusA, a)
    local statusB = m.status(status)
    m.searchInfer(statusB, b)
    local infers = {}
    for _, infer in ipairs(statusA.results) do
        local literal = infer.value
        if literal then
            infers[literal] = false
        end
    end
    for _, infer in ipairs(statusB.results) do
        local literal = infer.value
        if literal then
            if infers[literal] == nil then
                return false
            end
            infers[literal] = true
        end
    end
    for k, v in pairs(infers) do
        if v == false then
            return false
        end
    end
    return true
end

function m.inferCheckLiteral(status, source)
    if source.type == 'string' then
        status.results = m.allocInfer {
            type   = 'string',
            value  = source[1],
            source = source,
        }
        return true
    elseif source.type == 'nil' then
        status.results = m.allocInfer {
            type   = 'nil',
            value  = NIL,
            source = source,
        }
        return true
    elseif source.type == 'boolean' then
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = source[1],
            source = source,
        }
        return true
    elseif source.type == 'number' then
        if mathType(source[1]) == 'integer' then
            status.results = m.allocInfer {
                type   = 'integer',
                value  = source[1],
                source = source,
            }
            return true
        else
            status.results = m.allocInfer {
                type   = 'number',
                value  = source[1],
                source = source,
            }
            return true
        end
    elseif source.type == 'integer' then
        status.results = m.allocInfer {
            type   = 'integer',
            source = source,
        }
        return true
    elseif source.type == 'table' then
        status.results = m.allocInfer {
            type   = 'table',
            source = source,
        }
        return true
    elseif source.type == 'function' then
        status.results = m.allocInfer {
            type   = 'function',
            source = source,
        }
        return true
    elseif source.type == '...' then
        status.results = m.allocInfer {
            type   = '...',
            source = source,
        }
        return true
    end
end

function m.inferCheckUnary(status, source)
    if source.type ~= 'unary' then
        return
    end
    local op = source.op
    if op.type == 'not' then
        local checkTrue = m.checkTrue(status, source[1])
        local value = nil
        if checkTrue == true then
            value = false
        elseif checkTrue == false then
            value = true
        end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = value,
            source = source,
        }
        return true
    elseif op.type == '#' then
        status.results = m.allocInfer {
            type   = 'integer',
            source = source,
        }
        return true
    elseif op.type == '~' then
        local l = m.getInferLiteral(status, source[1], 'integer')
        status.results = m.allocInfer {
            type   = 'integer',
            value  = l and ~l or nil,
            source = source,
        }
        return true
    elseif op.type == '-' then
        local v = m.getInferLiteral(status, source[1], 'integer')
        if v then
            status.results = m.allocInfer {
                type   = 'integer',
                value  = - v,
                source = source,
            }
            return true
        end
        v = m.getInferLiteral(status, source[1], 'number')
        status.results = m.allocInfer {
            type   = 'number',
            value  = v and -v or nil,
            source = source,
        }
        return true
    end
end

local function mathCheck(status, a, b)
    local v1 = m.getInferLiteral(status, a, 'integer')
            or m.getInferLiteral(status, a, 'number')
    local v2 = m.getInferLiteral(status, b, 'integer')
            or m.getInferLiteral(status, a, 'number')
    local int = m.hasType(status, a, 'integer')
            and m.hasType(status, b, 'integer')
            and not m.hasType(status, a, 'number')
            and not m.hasType(status, b, 'number')
    return int and 'integer' or 'number', v1, v2
end

function m.inferCheckBinary(status, source)
    if source.type ~= 'binary' then
        return
    end
    local op = source.op
    if op.type == 'and' then
        local isTrue = m.checkTrue(status, source[1])
        if isTrue == true then
            m.searchInfer(status, source[2])
            return true
        elseif isTrue == false then
            m.searchInfer(status, source[1])
            return true
        else
            m.searchInfer(status, source[1])
            m.searchInfer(status, source[2])
            return true
        end
    elseif op.type == 'or' then
        local isTrue = m.checkTrue(status, source[1])
        if isTrue == true then
            m.searchInfer(status, source[1])
            return true
        elseif isTrue == false then
            m.searchInfer(status, source[2])
            return true
        else
            m.searchInfer(status, source[1])
            m.searchInfer(status, source[2])
            return true
        end
    elseif op.type == '==' then
        local value = m.isSameValue(status, source[1], source[2])
        if value ~= nil then
            status.results = m.allocInfer {
                type   = 'boolean',
                value  = value,
                source = source,
            }
            return true
        end
        --local isSame = m.isSameDef(status, source[1], source[2])
        --if isSame == true then
        --    value = true
        --else
        --    value = nil
        --end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = value,
            source = source,
        }
        return true
    elseif op.type == '~=' then
        local value = m.isSameValue(status, source[1], source[2])
        if value ~= nil then
            status.results = m.allocInfer {
                type   = 'boolean',
                value  = not value,
                source = source,
            }
            return true
        end
        --local isSame = m.isSameDef(status, source[1], source[2])
        --if isSame == true then
        --    value = false
        --else
        --    value = nil
        --end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = value,
            source = source,
        }
        return true
    elseif op.type == '<=' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
                or m.getInferLiteral(status, source[1], 'number')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
                or m.getInferLiteral(source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 <= v2
        end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '>=' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
                or m.getInferLiteral(status, source[1], 'number')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
                or m.getInferLiteral(status, source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 >= v2
        end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '<' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
                or m.getInferLiteral(status, source[1], 'number')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
                or m.getInferLiteral(status, source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 < v2
        end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '>' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
                or m.getInferLiteral(status, source[1], 'number')
        local v2 = m.getInferLiteral(source[2], 'integer')
                or m.getInferLiteral(status, source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 > v2
        end
        status.results = m.allocInfer {
            type   = 'boolean',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '|' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 | v2
        end
        status.results = m.allocInfer {
            type   = 'integer',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '~' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 ~ v2
        end
        status.results = m.allocInfer {
            type   = 'integer',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '&' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 & v2
        end
        status.results = m.allocInfer {
            type   = 'integer',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '<<' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 << v2
        end
        status.results = m.allocInfer {
            type   = 'integer',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '>>' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
        local v
        if v1 and v2 then
            v = v1 >> v2
        end
        status.results = m.allocInfer {
            type   = 'integer',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '..' then
        local v1 = m.getInferLiteral(status, source[1], 'string')
        local v2 = m.getInferLiteral(status, source[2], 'string')
        local v
        if v1 and v2 then
            v = v1 .. v2
        end
        status.results = m.allocInfer {
            type   = 'string',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '^' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
                or m.getInferLiteral(status, source[1], 'number')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
                or m.getInferLiteral(status, source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 ^ v2
        end
        status.results = m.allocInfer {
            type   = 'number',
            value  = v,
            source = source,
        }
        return true
    elseif op.type == '/' then
        local v1 = m.getInferLiteral(status, source[1], 'integer')
                or m.getInferLiteral(status, source[1], 'number')
        local v2 = m.getInferLiteral(status, source[2], 'integer')
                or m.getInferLiteral(status, source[2], 'number')
        local v
        if v1 and v2 then
            v = v1 > v2
        end
        status.results = m.allocInfer {
            type   = 'number',
            value  = v,
            source = source,
        }
        return true
    -- 其他数学运算根据2侧的值决定，当2侧的值均为整数时返回整数
    elseif op.type == '+' then
        local int, v1, v2 = mathCheck(status, source[1], source[2])
        status.results = m.allocInfer{
            type   = int,
            value  = (v1 and v2) and (v1 + v2) or nil,
            source = source,
        }
        return true
    elseif op.type == '-' then
        local int, v1, v2 = mathCheck(status, source[1], source[2])
        status.results = m.allocInfer{
            type   = int,
            value  = (v1 and v2) and (v1 - v2) or nil,
            source = source,
        }
        return true
    elseif op.type == '*' then
        local int, v1, v2 = mathCheck(status, source[1], source[2])
        status.results = m.allocInfer {
            type   = int,
            value  = (v1 and v2) and (v1 * v2) or nil,
            source = source,
        }
        return true
    elseif op.type == '%' then
        local int, v1, v2 = mathCheck(status, source[1], source[2])
        status.results = m.allocInfer {
            type   = int,
            value  = (v1 and v2) and (v1 % v2) or nil,
            source = source,
        }
        return true
    elseif op.type == '//' then
        local int, v1, v2 = mathCheck(status, source[1], source[2])
        status.results = m.allocInfer {
            type   = int,
            value  = (v1 and v2) and (v1 // v2) or nil,
            source = source,
        }
        return true
    end
end

function m.inferCheckLibraryTypes(status, source)
    if type(source.type) ~= 'table' then
        return false
    end
    for i = 1, #source.type do
        status.results[#status.results+1] = {
            type = source.type[i],
            source = source,
        }
    end
    return true
end

function m.inferCheckLibrary(status, source)
    local lib = status.interface.library and status.interface.library(source)
    if not lib then
        return false
    end
    status.results = m.allocInfer {
        type   = lib.type,
        value  = lib.value,
        source = lib,
    }
    return true
end

function m.inferCheckLibraryReturn(status, source)
    if source.type ~= 'select' then
        return nil
    end
    local index = source.index
    local call = source.vararg
    if call.type ~= 'call' then
        return nil
    end
    local func = call.node
    local lib = status.interface.library and status.interface.library(func)
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
    status.results = m.allocInfer {
        type   = rtn.type,
        value  = rtn.value,
        source = rtn,
    }
    return true
end

function m.inferByLibraryArg(status, source)
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
    local lib = status.interface.library and status.interface.library(func)
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
    status.results[#status.results+1] = {
        type   = arg.type,
        value  = arg.value,
        source = arg,
    }
end

function m.inferByDef(status, obj)
    if status.index > 1 then
        return
    end
    local newStatus = m.status(nil, status.interface)
    m.searchRefs(newStatus, obj, 'def')
    for _, src in ipairs(newStatus.results) do
        local inferStatus = m.status(status)
        m.searchInfer(inferStatus, src)
        for _, infer in ipairs(inferStatus.results) do
            status.results[#status.results+1] = infer
        end
    end
end

local function inferBySetOfLocal(status, source)
    if status.cache[source] then
        return
    end
    status.cache[source] = true
    if source.ref then
        local newStatus = m.status(status)
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                break
            end
            m.searchInfer(newStatus, ref)
        end
        for _, infer in ipairs(newStatus.results) do
            status.results[#status.results+1] = infer
        end
    end
end

function m.inferBySet(status, source)
    if #status.results ~= 0 then
        return
    end
    if source.type == 'local' then
        inferBySetOfLocal(status, source)
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        inferBySetOfLocal(status, source.node)
    end
end

function m.inferByCall(status, source)
    if #status.results ~= 0 then
        return
    end
    if not source.parent then
        return
    end
    if source.parent.type ~= 'call' then
        return
    end
    if source.parent.node == source then
        status.results[#status.results+1] = {
            type   = 'function',
            source = source,
        }
        return
    end
end

function m.inferByGetTable(status, source)
    if #status.results ~= 0 then
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
        status.results[#status.results+1] = {
            type   = 'table',
            source = source,
        }
    end
end

function m.inferByUnary(status, source)
    if #status.results ~= 0 then
        return
    end
    local parent = source.parent
    if not parent or parent.type ~= 'unary' then
        return
    end
    local op = parent.op
    if op.type == '#' then
        status.results[#status.results+1] = {
            type   = 'string',
            source = source
        }
        status.results[#status.results+1] = {
            type   = 'table',
            source = source
        }
    elseif op.type == '~' then
        status.results[#status.results+1] = {
            type   = 'integer',
            source = source
        }
    elseif op.type == '-' then
        status.results[#status.results+1] = {
            type   = 'number',
            source = source
        }
    end
end

function m.inferByBinary(status, source)
    if #status.results ~= 0 then
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
        status.results[#status.results+1] = {
            type   = 'number',
            source = source,
        }
    elseif op.type == '|'
    or     op.type == '~'
    or     op.type == '&'
    or     op.type == '<<'
    or     op.type == '>>'
    -- 整数的可能性比较高
    or     op.type == '//' then
        status.results[#status.results+1] = {
            type   = 'integer',
            source = source,
        }
    elseif op.type == '..' then
        status.results[#status.results+1] = {
            type   = 'string',
            source = source,
        }
    end
end

local function mergeFunctionReturns(status, source, index)
    local returns = source.returns
    if not returns then
        return
    end
    for i = 1, #returns do
        local rtn = returns[i]
        if rtn[index] then
            local newStatus = m.status(status)
            m.searchInfer(newStatus, rtn[index])
            for _, infer in ipairs(newStatus.results) do
                status.results[#status.results+1] = infer
            end
        end
    end
end

function m.inferByCallReturn(status, source)
    if source.type ~= 'select' then
        return
    end
    if not source.vararg or source.vararg.type ~= 'call' then
        return
    end
    local node = source.vararg.node
    local newStatus = m.status(nil, status.interface)
    m.searchRefs(newStatus, node, 'def')
    local index = source.index
    for _, src in ipairs(newStatus.results) do
        if src.value and src.value.type == 'function' then
            mergeFunctionReturns(status, src.value, index)
        end
    end
end

function m.inferByPCallReturn(status, source)
    if source.type ~= 'select' then
        return
    end
    local call = source.vararg
    if not call or call.type ~= 'call' then
        return
    end
    local node = call.node
    local specialName = node.special
    local func, index
    if specialName == 'pcall' then
        func = call.args[1]
        index = source.index - 1
    elseif specialName == 'xpcall' then
        func = call.args[1]
        index = source.index - 2
    else
        return
    end
    local newStatus = m.status(nil, status.interface)
    m.searchRefs(newStatus, func, 'def')
    for _, src in ipairs(newStatus.results) do
        if src.value and src.value.type == 'function' then
            mergeFunctionReturns(status, src.value, index)
        end
    end
end

function m.cleanInfers(infers)
    local mark = {}
    for i = 1, #infers do
        local infer = infers[i]
        if not infer then
            return
        end
        local key = ('%s|%p'):format(infer.type, infer.source)
        if mark[key] then
            infers[i] = infers[#infers]
            infers[#infers] = nil
        else
            mark[key] = true
        end
    end
end

function m.searchInfer(status, obj)
    while obj.type == 'paren' do
        obj = obj.exp
    end
    obj = m.getObjectValue(obj) or obj

    local cache, makeCache
    if status.interface.cache then
        cache, makeCache = status.interface.cache(obj, 'infer')
    end
    if cache then
        for i = 1, #cache do
            status.results[#status.results+1] = cache[i]
        end
        return
    end

    if DEVELOP then
        status.cache.clock = status.cache.clock or osClock()
    end

    local checked = m.inferCheckLiteral(status, obj)
                 or m.inferCheckUnary(status, obj)
                 or m.inferCheckBinary(status, obj)
                 or m.inferCheckLibraryTypes(status, obj)
                 or m.inferCheckLibrary(status, obj)
                 or m.inferCheckLibraryReturn(status, obj)
    if checked then
        m.cleanInfers(status.results)
        if makeCache then
            makeCache(status.results)
        end
        return
    end

    m.inferByLibraryArg(status, obj)
    m.inferByDef(status, obj)
    m.inferBySet(status, obj)
    m.inferByCall(status, obj)
    m.inferByGetTable(status, obj)
    m.inferByUnary(status, obj)
    m.inferByBinary(status, obj)
    m.inferByCallReturn(status, obj)
    m.inferByPCallReturn(status, obj)
    m.cleanInfers(status.results)
    if makeCache then
        makeCache(status.results)
    end
end

--- 请求对象的引用，包括 `a.b.c` 形式
--- 与 `return function` 形式。
--- 不穿透 `setmetatable` ，考虑由
--- 业务层进行反向 def 搜索。
function m.requestReference(obj, interface)
    local status = m.status(nil, interface)
    -- 根据 field 搜索引用
    m.searchRefs(status, obj, 'ref')

    m.searchRefsAsFunction(status, obj, 'ref')

    if m.debugMode then
        print('count:', status.cache.count)
    end

    return status.results, status.cache.count
end

--- 请求对象的定义，包括 `a.b.c` 形式
--- 与 `return function` 形式。
--- 穿透 `setmetatable` 。
function m.requestDefinition(obj, interface)
    local status = m.status(nil, interface)
    -- 根据 field 搜索定义
    m.searchRefs(status, obj, 'def')

    return status.results, status.cache.count
end

--- 请求对象的域
function m.requestFields(obj, interface)
    return m.searchFields(nil, obj, nil, interface)
end

--- 请求对象的类型推测
function m.requestInfer(obj, interface)
    local status = m.status(nil, interface)
    m.searchInfer(status, obj)

    return status.results, status.cache.count
end

return m
