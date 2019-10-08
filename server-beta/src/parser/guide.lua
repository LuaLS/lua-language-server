local error      = error
local type       = type
local next       = next

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
    ['index']       = {'index'},
    ['table']       = {'#'},
    ['tableindex']  = {'index', 'value'},
    ['tablefield']  = {'value'},
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

--- 寻找所在函数
function m.getParentFunction(obj)
    for _ = 1, 1000 do
        obj = obj.parent
        if not obj then
            break
        end
        local tp = obj.type
        if tp == 'function' then
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

--- 判断offset在source的范围内
function m.isInRange(source, offset)
    return source.start <= offset and (source.range or source.finish) >= offset - 1
end

--- 遍历所有包含offset的source
function m.eachSourceContain(ast, offset, callback)
    local map = m.childMap
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
                callback(obj)
            end
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
    end
end

--- 遍历所有包含offset的source
function m.eachSource(ast, callback)
    local map = m.childMap
    local list = { ast }
    while true do
        local len = #list
        if len == 0 then
            return
        end
        local obj = list[len]
        list[len] = nil
        callback(obj)
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
end

--- 获取偏移对应的坐标（row从0开始，col为光标位置）
---@param lines table
---@return integer {name = 'row'}
---@return integer {name = 'col'}
function m.positionOf(lines, offset)
    if offset < 1 then
        return 0, 0
    end
    local lastLine = lines[#lines]
    if offset > lastLine.finish then
        return #lines - 1, lastLine.finish - lastLine.start
    end
    local min = 1
    local max = #lines
    for _ = 1, 100 do
        if max <= min then
            local line = lines[min]
            return min - 1, offset - line.start
        end
        local row = (max - min) // 2 + min
        local line = lines[row]
        if offset < line.start then
            max = row - 1
        elseif offset >= line.finish then
            min = row + 1
        else
            return row - 1, offset - line.start
        end
    end
    error('Stack overflow!')
end

--- 获取坐标对应的偏移（row从0开始，col为光标位置）
---@param lines table
---@param row integer
---@param col integer
---@return integer {name = 'offset'}
function m.offsetOf(lines, row, col)
    if row < 0 then
        return 0
    end
    if row > #lines - 1 then
        local lastLine = lines[#lines]
        return lastLine.finish
    end
    local line = lines[row + 1]
    local len = line.finish - line.start
    if col < 0 then
        return line.start
    elseif col > len then
        return line.finish
    else
        return line.start + col
    end
end

function m.lineContent(lines, text, row)
    local line = lines[row + 1]
    if not line then
        return ''
    end
    return text:sub(line.start + 1, line.finish)
end

function m.lineRange(lines, row)
    local line = lines[row + 1]
    if not line then
        return 0, 0
    end
    return line.start + 1, line.finish
end

function m.getKeyName(obj)
    if obj.type == 'getglobal' or obj.type == 'setglobal' then
        return obj[1]
    elseif obj.type == 'getfield' or obj.type == 'setfield' then
        return obj.field[1]
    elseif obj.type == 'field' then
        return obj[1]
    end
    return nil
end

return m
