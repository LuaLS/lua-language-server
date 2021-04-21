local util  = require 'utility'
local guide = require 'parser.guide'
local vm    = require 'vm.vm'

local Linkers
local LastIDCache = {}
local SPLIT_CHAR = '\x1F'
local SPLIT_REGEX = SPLIT_CHAR .. '.-$'
local INDEX_CHAR = '\x1E'

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
        return ('%d%s%s%d'):format(source.start, SPLIT_CHAR, INDEX_CHAR, source.index)
    elseif source.type == 'doc.class.name'
    or     source.type == 'doc.type.name'
    or     source.type == 'doc.alias.name' then
        return source[1], nil
    elseif source.type == 'doc.class'
    or     source.type == 'doc.type'
    or     source.type == 'doc.alias' then
        return source.start, nil
    end
    return nil, nil
end

local function checkMode(source)
    if source.type == 'table' then
        return 't:'
    end
    if source.type == 'select' then
        return 's:'
    end
    if source.type == 'function' then
        return 'f:'
    end
    if source.type == 'doc.class.name'
    or source.type == 'doc.type.name'
    or source.type == 'doc.alias.name'
    or source.type == 'doc.extends.name' then
        return 'dn:'
    end
    if source.type == 'doc.class' then
        return 'dc:'
    end
    if source.type == 'doc.type' then
        return 'dt:'
    end
    if source.type == 'doc.alias' then
        return 'da:'
    end
    if isGlobal(source) then
        return 'g:'
    end
    return 'l:'
end

local IDList = {}
---获取语法树单元的字符串ID
---@param source parser.guide.object
---@return string? id
local function getID(source)
    if not source then
        return nil
    end
    if source._id ~= nil then
        return source._id or nil
    end
    if source.type == 'field'
    or source.type == 'method' then
        source._id = false
        return nil
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
        if not node then
            break
        end
        if node.special == '_G' then
            break
        end
        current = node
    end
    if index == 0 then
        source._id = false
        return nil
    end
    for i = index + 1, #IDList do
        IDList[i] = nil
    end
    local mode = checkMode(current)
    if not mode then
        source._id = false
        return nil
    end
    util.revertTable(IDList)
    local id = mode .. table.concat(IDList, SPLIT_CHAR)
    source._id = id
    return id
end

local TempList = {}

---前进
---@param source parser.guide.object
---@return parser.guide.object[]
local function checkForward(source, id)
    local list = TempList
    local parent = source.parent
    if source.value then
        -- x = y : x -> y
        list[#list+1] = getID(source.value)
    end
    -- mt:f -> self
    if  parent.type == 'setmethod'
    and parent.node == source then
        local func = parent.value
        if func then
            local self = func.locals[1]
            if self.tag == 'self' then
                list[#list+1] = getID(self)
            end
        end
    end
    -- source 绑定的 @class/@type
    local bindDocs = source.bindDocs
    if bindDocs then
        for _, doc in ipairs(bindDocs) do
            if doc.type == 'doc.class'
            or doc.type == 'doc.type' then
                list[#list+1] = getID(doc)
            end
        end
    end
    -- 分解 @type
    if source.type == 'doc.type' then
        for _, typeUnit in ipairs(source.types) do
            list[#list+1] = getID(typeUnit)
        end
    end
    -- 分解 @class
    if source.type == 'doc.class' then
        list[#list+1] = getID(source.class)
        list[#list+1] = getID(source.extends)
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
local function checkBackward(source, id)
    local list  = TempList
    local parent = source.parent
    if parent.value == source then
        list[#list+1] = getID(parent)
    end
    -- self -> mt:xx
    if source.tag == 'self' then
        local func = guide.getParentFunction(source)
        local setmethod = func.parent
        if setmethod and setmethod.type == 'setmethod' then
            list[#list+1] = getID(setmethod.node)
        end
    end
    -- name 映射回 class 与 type
    if source.type == 'doc.class.name'
    or source.type == 'doc.type.name' then
        list[#list+1] = getID(parent)
    end
    -- class 与 type 绑定的 source
    if source.type == 'doc.class'
    or source.type == 'doc.type' then
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                list[#list+1] = getID(src)
            end
        end
        -- 将 @return 映射到函数返回值上
        if source.returnIndex then
            for _, src in ipairs(parent.bindSources) do
                if src.type == 'function' then
                    local fullID = ('%s%s%s%s'):format(getID(src), SPLIT_CHAR, INDEX_CHAR, source.returnIndex)
                    list[#list+1] = fullID
                end
            end
        end
    end
    -- 将函数返回值映射到call的返回值接收上
    if parent.type == 'call' and parent.node == source then
        local sel = parent.parent
        if sel.type == 'select' then
            list[#list+1] = ('s:%d'):format(sel.start)
        end
    end
    if #list == 0 then
        return nil
    else
        TempList = {}
        return list
    end
end

---@class link
-- 当前节点的id
---@field id     string
-- 语法树单元
---@field source parser.guide.object
-- 前进的关联单元
---@field forward parser.guide.object[]
-- 后退的关联单元
---@field backward parser.guide.object[]

---创建source的链接信息
---@param source parser.guide.object
---@return link
local function createLink(source)
    local id = getID(source)
    if not id then
        return nil
    end
    return {
        id        = id,
        source    = source,
        forward   = checkForward(source,  id),
        backward  = checkBackward(source, id),
    }
end

---@param link link
local function insertLinker(link)
    local id = link.id
    if not Linkers[id] then
        Linkers[id] = {}
    end
    Linkers[id][#Linkers[id]+1] = link
end

local m = {}

m.SPLIT_CHAR = SPLIT_CHAR
m.INDEX_CHAR = INDEX_CHAR

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
    return linkers[id]
end

---根据ID来获取上个节点的ID
---@param id string
---@return string
function m.getLastID(id)
    if LastIDCache[id] then
        return LastIDCache[id] or nil
    end
    local lastID, count = id:gsub(SPLIT_REGEX, '')
    if count == 0 then
        LastIDCache[id] = false
        return nil
    end
    LastIDCache[id] = lastID
    return lastID
end

---获取source的链接信息
---@param source parser.guide.object
---@return link
function m.getLink(source)
    if source._link == nil then
        source._link = createLink(source) or false
    end
    return source._link or nil
end

---获取source的ID
---@param source parser.guide.object
---@return string
function m.getID(source)
    return getID(source)
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
    Linkers = {}
    root._linkers = Linkers
    guide.eachSource(root, function (src)
        local link = m.getLink(src)
        if not link then
            return
        end
        insertLinker(link)
    end)
    return Linkers
end

return m
