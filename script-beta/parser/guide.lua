local util        = require 'utility'
local error       = error
local type        = type
local next        = next
local tostring    = tostring
local print       = print
local ipairs      = ipairs
local tableInsert = table.insert
local tableUnpack = table.unpack
local tableRemove = table.remove
local tableMove   = table.move

_ENV = nil

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
    while true do
        local len = #list
        if len == 0 then
            return
        end
        local obj = list[len]
        list[len] = nil
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

--- 遍历所有指定类型的source
function m.eachSourceType(ast, type, callback)
    local cache = ast.typeCache
    if not cache then
        local mark = {}
        cache = {}
        ast.typeCache = cache
        m.eachSource(ast, function (source)
            if mark[source] then
                return
            end
            mark[source] = true
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
    local index = 1
    while true do
        local obj = list[index]
        if not obj then
            return
        end
        list[index] = false
        index = index + 1
        callback(obj)
        m.addChilds(list, obj, m.childMap)
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
        elseif cur.type == 'getlocal'
        or     cur.type == 'setlocal'
        or     cur.type == 'local' then
            list[i] = cur
            break
        elseif cur.type == 'setglobal'
        or     cur.type == 'getglobal' then
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
    or obj.type == 'tableindex' then
        simpleList = buildSimpleList(obj, max)
    elseif obj.type == 'field'
    or     obj.type == 'method' then
        simpleList = buildSimpleList(obj.parent, max)
    end
    return simpleList
end

m.SearchFlag = {
    STEP   = 1 << 0,
    SIMPLE = 1 << 1,
    ALL    = 0xffff,
}
m.Version = 53

function m.status(parentStatus)
    local status = {
        cache   = parentStatus and parentStatus.cache or {},
        depth   = parentStatus and parentStatus.depth or 0,
        flag    = m.SearchFlag.ALL,
        results = {},
    }
    return status
end

function m.copyStatusResults(a, b)
    local ra = a.results
    local rb = b.results
    for i = 1, #rb do
        ra[#ra+1] = rb[i]
    end
end

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

function m.searchFields(status, obj, key)
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
        local newStatus = m.status(status)
        local simple = m.getSimple(obj, 1)
        if not simple then
            return {}
        end
        simple[#simple+1] = key and ('s|' .. key) or '*'
        m.searchSameFields(newStatus, simple, 'def')
        local results = newStatus.results
        m.cleanResults(results)
        return results
    end
end

function m.getObjectValue(obj)
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

function m.checkSameSimpleInValueOfSetMetaTable(status, value, start, queue)
    if value.type ~= 'select' then
        return
    end
    local vararg = value.vararg
    if not vararg or vararg.type ~= 'call' then
        return
    end
    local func = vararg.node
    if not func or func.special ~= 'setmetatable' then
        return
    end
    local args = vararg.args
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
        m.checkSameSimpleInValueInMetaTable(status, mt, start, queue)
    end
end

function m.checkSameSimpleInBranch(status, ref, start, queue)
    -- 根据赋值扩大搜索范围
    local value = m.getObjectValue(ref)
    if value then
        -- 检查赋值是字面量表的情况
        m.checkSameSimpleInValueOfTable(status, value, start, queue)
        -- 检查赋值是 setmetatable 调用的情况
        m.checkSameSimpleInValueOfSetMetaTable(status, value, start, queue)
    end

    -- 检查自己是字面量表的情况
    m.checkSameSimpleInValueOfTable(status, ref, start, queue)
    -- 检查自己作为 setmetatable 第一个参数的情况
    m.checkSameSimpleInArg1OfSetMetaTable(status, ref, start, queue)
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

function m.checkSameSimple(status, simple, data, mode, results, queue)
    local ref   = data.obj
    local start = data.start
    local force = data.force
    for i = start, #simple do
        local sm = simple[i]
        if sm ~= '*' and not force and m.getSimpleName(ref) ~= sm then
            return
        end
        force = false
        -- 穿透 self:func 与 mt:func
        m.searchSameFieldsCrossMethod(status, ref, i, queue)
        if i == #simple then
            break
        end
        -- 检查形如 a = {} 的分支情况
        m.checkSameSimpleInBranch(status, ref, i, queue)
        ref = m.getNextRef(ref)
        if not ref then
            return
        end
    end
    if mode == 'def' then
        if ref.type == 'setglobal'
        or ref.type == 'setlocal'
        or ref.type == 'local' then
            results[#results+1] = ref
        elseif ref.type == 'setfield'
        or     ref.type == 'tablefield' then
            results[#results+1] = ref.field
        elseif ref.type == 'setmethod' then
            results[#results+1] = ref.method
        elseif ref.type == 'setindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref.index
        elseif ref.type == 'call' then
            if ref.node.special == 'rawset' then
                results[#results+1] = ref
            end
        end
    else
        if ref.type == 'setfield'
        or ref.type == 'getfield'
        or ref.type == 'tablefield' then
            results[#results+1] = ref.field
        elseif ref.type == 'setmethod'
        or     ref.type == 'getmethod' then
            results[#results+1] = ref.method
        elseif ref.type == 'setindex'
        or     ref.type == 'getindex'
        or     ref.type == 'tableindex' then
            results[#results+1] = ref.index
        else
            results[#results+1] = ref
        end
    end
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
    if simple.global then
        for i = 1, #queue do
            local data = queue[i]
            local obj  = data.obj
            local nxt  = m.getNextRef(obj)
            if nxt and obj.special == '_G' then
                data.obj = nxt
            end
        end
        if first and first.tag ~= '_ENV' then
            m.checkSameSimpleInBranch(status, first, 0, queue)
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
        m.checkSameSimple(status, simple, data, mode, status.results, queue)
    end
end

function m.searchRefsAsFunctionReturn(status, obj, mode)
    status.results[#status.results+1] = obj
    -- 搜索所在函数
    local currentFunc = m.getParentFunction(obj)
    local returns = currentFunc.returns
    if not returns then
        return
    end
    -- 看看他是第几个返回值
    local index
    for i = 1, #returns do
        local rtn = returns[i]
        if m.isContain(rtn, obj.start) then
            for j = 1, #rtn do
                if obj == rtn[j] then
                    index = j
                    goto BREAK
                end
            end
        end
    end
    ::BREAK::
    if not index then
        return
    end
    -- 搜索所有所在函数的调用者
    local funcRefs = m.status(status)
    m.searchRefOfValue(funcRefs, currentFunc)

    if #funcRefs.results == 0 then
        return
    end
    local calls = {}
    for _, res in ipairs(funcRefs.results) do
        local call = res.parent
        if call.type == 'call' then
            calls[#calls+1] = call
        end
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
        m.searchRefs(status, selects[i])
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

function m.searchRefs(status, obj, mode)
    status.depth = status.depth + 1

    -- 检查单步引用
    if status.flag & m.SearchFlag.STEP ~= 0 then
        local res = m.getStepRef(obj, mode)
        if res then
            for i = 1, #res do
                status.results[#status.results+1] = res[i]
            end
        end
    end
    -- 检查simple
    if status.flag & m.SearchFlag.SIMPLE ~= 0 then
        if status.depth <= 10 then
            local simple = m.getSimple(obj)
            if simple then
                m.searchSameFields(status, simple, mode)
            end
        elseif m.debugMode then
            error('stack overflow')
        end
    end

    status.depth = status.depth - 1

    m.cleanResults(status.results)
end

function m.searchRefOfValue(status, obj)
    local var = obj.parent
    if var.type == 'local'
    or var.type == 'set' then
        return m.searchRefs(status, var, 'ref')
    end
end

--- 请求对象的引用，包括 `a.b.c` 形式
--- 与 `return function` 形式。
--- 不穿透 `setmetatable` ，考虑由
--- 业务层进行反向 def 搜索。
function m.requestReference(obj)
    local status = m.status()
    -- 根据 field 搜索引用
    m.searchRefs(status, obj, 'ref')

    m.searchRefsAsFunction(status, obj, 'ref')

    return status.results
end

--- 请求对象的定义，包括 `a.b.c` 形式
--- 与 `return function` 形式。
--- 穿透 `setmetatable` 。
function m.requestDefinition(obj)
    local status = m.status()
    -- 根据 field 搜索定义
    m.searchRefs(status, obj, 'def')

    return status.results
end

--- 请求对象的域
function m.requestFields(obj)
    return m.searchFields(nil, obj)
end

return m
