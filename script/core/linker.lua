local util  = require 'utility'
local guide = require 'parser.guide'

---获取语法树单元的key
---@param source parser.guide.object
---@return string? key
---@return parser.guide.object? node
local function getKey(source)
    if     source.type == 'local' then
        return tostring(source.start), nil
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        return tostring(source.node.start), nil
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        return ('%q'):format(source[1] or ''), nil
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
    elseif source.type == 'label' then
        return source.start, nil
    elseif source.type == 'goto' then
        if source.node then
            return source.node.start, nil
        end
        return nil, nil
    end
    return nil, nil
end

local function checkMode(source)
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        return 'g:'
    end
    if source.type == 'local'
    or source.type == 'setlocal'
    or source.type == 'getlocal' then
        return 'l:'
    end
    if source.type == 'label'
    or source.type == 'goto' then
        return 'l:'
    end
    if source.type == 'table' then
        return 'l:'
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

local TempList = {}

---前进
---@param source parser.guide.object
---@return parser.guide.object[]
local function checkForward(source)
    local list = TempList
    if source.value then
        list[#list+1] = source.value
    end
    if #list == 0 then
        return nil
    else
        TempList = {}
        return list
    end
end

---后退
---@param source parser.guide.object
---@return parser.guide.object[]
local function checkBackward(source)
    local list   = TempList
    local parent = source.parent
    if parent.value == source then
        list[#list+1] = parent
    end
    if #list == 0 then
        return nil
    else
        TempList = {}
        return list
    end
end

local IDList = {}
---获取语法树单元的字符串ID
---@param source parser.guide.object
---@return string? id
---@return parser.guide.object?
local function getID(source)
    if source.type == 'field'
    or source.type == 'method' then
        return nil, nil
    end
    local current = source
    local index = 0
    while true do
        local id, node = getKey(current)
        if not id then
            break
        end
        index = index + 1
        IDList[index] = id
        source = current
        if not node then
            break
        end
        current = node
    end
    if index == 0 then
        return nil
    end
    for i = index + 1, #IDList do
        IDList[i] = nil
    end
    local mode = checkMode(current)
    if mode then
        IDList[#IDList+1] = mode
    end
    util.revertTable(IDList)
    local id = table.concat(IDList, '|')
    local parentID
    if index > 1 then
        parentID = table.concat(IDList, '|', 1, index)
    end
    return id, current, parentID
end

---@class link
-- 当前节点的id
---@field id     string
-- 父节点的id
---@field parentID string
-- 语法树单元
---@field source parser.guide.object
-- 返回值，文件返回值总是0，函数返回值为第几个返回值
---@field freturn integer
-- 前进的关联单元
---@field forward parser.guide.object[]
-- 后退的关联单元
---@field backward parser.guide.object[]
-- 缓存的关联links
---@field _links link[]

---创建source的链接信息
---@param source parser.guide.object
---@return link
local function createLink(source)
    local id, node, parentID = getID(source)
    if not id then
        return nil
    end
    return {
        id       = id,
        source   = source,
        parentID = parentID,
        freturn  = checkFunctionReturn(node),
        forward  = checkForward(source),
        backward = checkBackward(source),
    }
end

local function insertLinker(linkers, mode, link)
    local list = linkers[mode]
    local id   = link.id
    if not list[id] then
        list[id] = {}
    end
    list[id][#list[id]+1] = link
    link._links = list[id]
end

local m = {}

---根据语法树单元获取关联的link列表
---@param source parser.guide.object
---@return link[]?
function m.getLinksBySource(source)
    if not source._link then
        source._link = createLink(source)
    end
    return source._link and source._link._links
end

---根据ID来获取所有的link
---@param source parser.guide.object
---@param mode string
---@param id string
---@return link[]?
function m.getLinksByID(source, mode, id)
    local root = guide.getRoot(source)
    if not root._linkers then
        return nil
    end
    local linkers = root._linkers[mode]
    if not linkers then
        return nil
    end
    return linkers[id]
end

---获取source的链接信息
---@param source parser.guide.object
---@return link
function m.getLink(source)
    if not source._link then
        source._link = createLink(source)
    end
    return source._link
end

---编译整个文件的link
---@param  source parser.guide.object
---@return table
function m.compileLinks(source)
    local root = guide.getRoot(source)
    if root._linkers then
        return root._linkers
    end
    local linkers = {}
    guide.eachSource(root, function (src)
        local link = m.getLink(src)
        if not link then
            return
        end
        if link.mode then
            insertLinker(linkers, link.mode, link)
        end
    end)
    root._linkers = linkers
    return linkers
end

return m
