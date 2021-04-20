local util  = require 'utility'
local guide = require 'parser.guide'
local vm    = require 'vm.vm'

---是否是全局变量（包括 _G.XXX 形式）
---@param source parser.guide.object
---@return boolean
local function isGlobal(source)
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        if source.node and source.node.tag == '_ENV' then
            return true
        end
    end
    if source.type == 'field' then
        source = source.parent
    end
    if source.type == 'getfield'
    or source.type == 'setfield' then
        local node = source.node
        if node and node.special == '_G' then
            return true
        end
    end
    return false
end

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
    elseif source.type == 'setindex'
    or     source.type == 'getindex' then
        local index = source.index
        if not index then
            return '', source.node
        end
        if index.type == 'string' then
            return ('%q'):format(index[1] or ''), source.node
        else
            return '', source.node
        end
    elseif source.type == 'tableindex' then
        local index = source.index
        if not index then
            return '', source.parent
        end
        if index.type == 'string' then
            return ('%q'):format(index[1] or ''), source.parent
        else
            return '', source.parent
        end
    elseif source.type == 'table' then
        return source.start, nil
    elseif source.type == 'label' then
        return source.start, nil
    elseif source.type == 'goto' then
        if source.node then
            return source.node.start, nil
        end
        return nil, nil
    elseif source.type == 'function' then
        return source.start, nil
    elseif source.type == 'select' then
        return ('%d:%d'):format(source.start, source.index)
    elseif source.type == 'doc.class.name'
    or     source.type == 'doc.type.name'
    or     source.type == 'doc.alias.name' then
        return source[1], nil
    end
    return nil, nil
end

local function checkMode(source)
    if source.type == 'table' then
        return 't'
    end
    if source.type == 'select' then
        return 's'
    end
    if source.type == 'function' then
        return 'f'
    end
    if source.type == 'doc.class.name'
    or source.type == 'doc.type.name'
    or source.type == 'doc.alias.name'
    or source.type == 'doc.extends.name' then
        return 'd'
    end
    if isGlobal(source) then
        return 'g'
    end
    return 'l'
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
    local parent = source.parent
    if source.value then
        -- x = y : x -> y
        list[#list+1] = source.value
    end
    -- mt:f -> self
    if  parent.type == 'setmethod'
    and parent.node == source then
        local func = parent.value
        if func then
            local self = func.locals[1]
            if self.tag == 'self' then
                list[#list+1] = self
            end
        end
    end
    -- source 绑定的 @class/@type
    local bindDocs = source.bindDocs
    if bindDocs then
        for _, doc in ipairs(bindDocs) do
            if doc.type == 'doc.class' then
                list[#list+1] = doc.class
            elseif doc.type == 'doc.type' then
                if doc.types then
                    for _, typeUnit in ipairs(doc.types) do
                        list[#list+1] = typeUnit
                    end
                end
            end
        end
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
    local list  = TempList
    local parent = source.parent
    if parent.value == source then
        list[#list+1] = parent
    end
    -- self -> mt:xx
    if source.tag == 'self' then
        local func = guide.getParentFunction(source)
        local setmethod = func.parent
        if setmethod and setmethod.type == 'setmethod' then
            list[#list+1] = setmethod.node
        end
    end
    if parent.parent and parent.parent.type == 'doc' then
        -- @class 绑定的 source
        if source.type == 'doc.class.name' then
            if parent.type == 'doc.class' then
                for _, src in ipairs(parent.bindSources) do
                    list[#list+1] = src
                end
            end
        end
        -- @type 绑定的 source
        if source.type == 'doc.type.name' then
            if parent.type == 'doc.type' and parent.parent.type == 'doc' then
                for _, src in ipairs(parent.bindSources) do
                    list[#list+1] = src
                end
            end
        end
    end
    if #list == 0 then
        return nil
    else
        TempList = {}
        return list
    end
end

local function checkSpecial(source)
    local list = TempList
    -- 接收 call 的返回值
    if source.type == 'select' then
        local index = source.index
        local call  = source.vararg
        if call.type == 'call' then
            list.call = {
                node  = call.node,
                index = index,
            }
        end
    end
    -- func 的返回值
    if source.type == 'function' then
        local returns = {}
        list.returns = returns
        if source.bindDocs then
            local index = 0
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.return' then
                    for _, rtn in ipairs(doc.returns) do
                        index = index + 1
                        if not returns[index] then
                            returns[index] = {}
                        end
                        if rtn.types then
                            for _, typeUnit in ipairs(rtn.types) do
                                returns[index][#returns[index]+1] = typeUnit
                            end
                        end
                    end
                end
            end
        end
    end
    if not next(list) then
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
        if node.special == '_G' then
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
    local lastID
    if index > 1 then
        lastID = table.concat(IDList, '|', 1, index)
    end
    return id, current, lastID
end

---@class link
-- 当前节点的id
---@field id     string
-- 上个节点的id
---@field lastID string
-- 语法树单元
---@field source parser.guide.object
-- 返回值，文件返回值总是0，函数返回值为第几个返回值
---@field freturn integer
-- 前进的关联单元
---@field forward parser.guide.object[]
-- 后退的关联单元
---@field backward parser.guide.object[]
-- 缓存的特殊数据
---@field special table

---创建source的链接信息
---@param source parser.guide.object
---@return link
local function createLink(source)
    local id, node, lastID = getID(source)
    if not id then
        return nil
    end
    return {
        id        = id,
        source    = source,
        lastID    = lastID,
        freturn   = checkFunctionReturn(node),
        forward   = checkForward(source),
        backward  = checkBackward(source),
        special   = checkSpecial(source),
    }
end

---@param link link
local function insertLinker(linkers, link)
    local idMap     = linkers.idMap
    local id        = link.id
    if not idMap[id] then
        idMap[id] = {}
    end
    idMap[id][#idMap[id]+1] = link
    if link.lastID then
        linkers.lastIDMap[id] = link.lastID
    end
end

local m = {}

---根据ID来获取所有的link
---@param root parser.guide.object
---@param id string
---@return link[]?
function m.getLinksByID(root, id)
    root = guide.getRoot(root)
    local linkers = root._linkers
    if not linkers then
        return nil
    end
    return linkers.idMap[id]
end

---根据ID来获取上个节点的ID
---@param root parser.guide.object
---@param id string
---@return string
function m.getLastID(root, id)
    root = guide.getRoot(root)
    local linkers = root._linkers
    if not linkers then
        return nil
    end
    return linkers.lastIDMap[id]
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

---获取source的ID
---@param source parser.guide.object
---@return string
function m.getID(source)
    if not source then
        return nil
    end
    local link = m.getLink(source)
    if not link then
        return nil
    end
    return link.id
end

---获取source的special
---@param source parser.guide.object
---@return table
function m.getSpecial(source, key)
    if not source then
        return nil
    end
    local link = m.getLink(source)
    if not link then
        return nil
    end
    local special = link.special
    if not special then
        return nil
    end
    return special[key]
end

---编译整个文件的link
---@param  source parser.guide.object
---@return table
function m.compileLinks(source)
    local root = guide.getRoot(source)
    if root._linkers then
        return root._linkers
    end
    local linkers = {
        idMap     = {},
        lastIDMap = {},
    }
    guide.eachSource(root, function (src)
        local link = m.getLink(src)
        if not link then
            return
        end
        insertLinker(linkers, link)
    end)
    root._linkers = linkers
    return linkers
end

return m
