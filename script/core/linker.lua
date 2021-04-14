local util  = require 'utility'

local function getKey(source)
    if     source.type == 'local' then
        return tostring(source.start), nil
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        return tostring(source.node.start), nil
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        return ('%q'):format(source[1] or ''), nil
    elseif source.type == 'field'
    or     source.type == 'method' then
        return ('%q'):format(source[1] or ''), source.parent.node
    elseif source.type == 'getfield'
    or     source.type == 'setfield' then
        return ('%q'):format(source.field and source.field[1] or ''), source.node
    elseif source.type == 'tablefield' then
        return ('%q'):format(source.field and source.field[1] or ''), source.parent
    elseif source.type == 'getmethod'
    or     source.type == 'setmethod' then
        return ('%q'):format(source.method and source.method[1] or ''), source.node
    elseif source.type == 'table' then
        return source.start, nil
    end
end

local function checkGlobal(source)
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        return true
    end
    return nil
end

local function checkTableField(source)
    if source.type == 'table' then
        return true
    end
    return nil
end

local function checkFunctionReturn(source)
    if  source.parent
    and source.parent.type == 'return' then
        if source.parent.parent.type == 'main' then
            return 0
        elseif source.parent.parent.type == 'function' then
            for i = 1, #source.parent do
                if source.parent[i] == source then
                    return i
                end
            end
        end
    end
    return nil
end

local function getID(source)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    local current = source
    local idList = {}
    while true do
        local id, node = getKey(current)
        if not id then
            break
        end
        idList[#idList+1] = id
        source = current
        if not node then
            break
        end
        current = node
    end
    util.revertTable(idList)
    local id = table.concat(idList, '|')
    return id, current
end

---创建source的链接信息
local function createLink(source)
    local id, node = getID(source)
    return {
        id     = id,
        -- 全局变量
        global  = checkGlobal(node),
        -- 字面量表中的字段
        tfield  = checkTableField(node),
        -- 返回值，文件返回值总是0，函数返回值为第几个返回值
        freturn = checkFunctionReturn(node),
    }
end

local m = {}

---获取source的链接信息
function m.getLink(source)
    if not source._link then
        source._link = createLink(source)
    end
    return source._link
end

return m
