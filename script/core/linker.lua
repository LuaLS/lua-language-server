local util  = require 'utility'
local guide = require 'parser.guide'
local vm    = require 'vm.vm'

local Linkers, GetLink
local LastIDCache = {}
local SPLIT_CHAR = '\x1F'
local SPLIT_REGEX = SPLIT_CHAR .. '[^' .. SPLIT_CHAR .. ']+$'
local RETURN_INDEX_CHAR = '#'
local PARAM_INDEX_CHAR = '@'

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
    --if source.type == 'getfield'
    --or source.type == 'setfield' then
    --    local node = source.node
    --    if node and node.special == '_G' then
    --        return true
    --    end
    --end
    if source.special == '_G' then
        return true
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
        return ('%d%s%s%d'):format(source.start, SPLIT_CHAR, RETURN_INDEX_CHAR, source.index)
    elseif source.type == 'call' then
        local node = source.node
        if node.special == 'rawget'
        or node.special == 'rawset' then
            if not source.args then
                return nil, nil
            end
            local tbl, key = source.args[1], source.args[2]
            if not tbl or not key then
                return nil, nil
            end
            if key.type == 'string' then
                return ('%q'):format(key[1] or ''), tbl
            else
                return '', tbl
            end
        end
    elseif source.type == 'doc.class.name'
    or     source.type == 'doc.type.name'
    or     source.type == 'doc.alias.name' then
        return source[1], nil
    elseif source.type == 'doc.class'
    or     source.type == 'doc.type'
    or     source.type == 'doc.alias'
    or     source.type == 'doc.param' then
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
    if source.type == 'doc.param' then
        return 'dp:'
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
        current = node
        if current.special == '_G' then
            break
        end
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

---添加关联单元
---@param id string
---@param source parser.guide.object
local function pushSource(id, source)
    local link = GetLink(id)
    if not link.sources then
        link.sources = {}
    end
    link.sources[#link.sources+1] = source
end

---添加关联的前进ID
---@param id string
---@param forwardID string
local function pushForward(id, forwardID)
    if not forwardID or forwardID == '' or id == forwardID then
        return
    end
    local link = GetLink(id)
    if not link.forward then
        link.forward = {}
    end
    link.forward[#link.forward+1] = forwardID
end

---添加关联的后退ID
---@param id string
---@param backwardID string
local function pushBackward(id, backwardID)
    if not backwardID or backwardID == '' or id == backwardID then
        return
    end
    local link = GetLink(id)
    if not link.backward then
        link.backward = {}
    end
    link.backward[#link.backward+1] = backwardID
end

---前进
---@param source parser.guide.object
---@return parser.guide.object[]
local function checkForward(source)
    local id   = getID(source)
    local parent = source.parent
    if source.value then
        -- x = y : x -> y
        pushForward(id, getID(source.value))
    end
    -- mt:f -> self
    if  parent.type == 'setmethod'
    and parent.node == source then
        local func = parent.value
        if func then
            local self = func.locals[1]
            if self.tag == 'self' then
                pushForward(id, getID(self))
            end
        end
    end
    -- self -> mt:xx
    if source.tag == 'self' then
        local func = guide.getParentFunction(source)
        local setmethod = func.parent
        if setmethod and setmethod.type == 'setmethod' then
            pushForward(id, getID(setmethod.node))
        end
    end
    -- source 绑定的 @class/@type
    local bindDocs = source.bindDocs
    if bindDocs then
        for _, doc in ipairs(bindDocs) do
            if doc.type == 'doc.class'
            or doc.type == 'doc.type' then
                pushForward(id, getID(doc))
            end
        end
    end
    -- 分解 @type
    if source.type == 'doc.type' then
        for _, typeUnit in ipairs(source.types) do
            pushForward(id, getID(typeUnit))
        end
    end
    -- 分解 @class
    if source.type == 'doc.class' then
        pushForward(id, getID(source.class))
        pushForward(id, getID(source.extends))
    end
    -- 将call的返回值接收映射到函数返回值上
    if source.type == 'select' then
        local call = source.vararg
        if call.type == 'call' then
            local node = call.node
            local callID = ('%s%s%s%s'):format(
                getID(node),
                SPLIT_CHAR,
                RETURN_INDEX_CHAR,
                source.index
            )
            pushForward(id, callID)
            -- 将setmetatable映射到 param1 以及 param2.__index 上
            if node.special == 'setmetatable' and source.index == 1 then
                pushForward(id, getID())
            end
        end
    end
    -- 将函数的返回值映射到具体的返回值上
    if source.type == 'function' then
        if source.returns then
            local returns = {}
            for _, rtn in ipairs(source.returns) do
                for index, rtnObj in ipairs(rtn) do
                    if not returns[index] then
                        returns[index] = {}
                    end
                    returns[index][#returns[index]+1] = rtnObj
                end
            end
            for index, rtnObjs in ipairs(returns) do
                local returnID = ('%s%s%s%s'):format(
                    getID(source),
                    SPLIT_CHAR,
                    RETURN_INDEX_CHAR,
                    index
                )
                for _, rtnObj in ipairs(rtnObjs) do
                    pushForward(returnID, getID(rtnObj))
                end
            end
        end
    end
end

---后退
---@param source parser.guide.object
---@return parser.guide.object[]
local function checkBackward(source)
    local id = getID(source)
    local parent = source.parent
    if parent.value == source then
        pushBackward(id, getID(parent))
    end
    -- name 映射回 class 与 type
    if source.type == 'doc.class.name'
    or source.type == 'doc.type.name' then
        pushBackward(id, getID(parent))
    end
    -- class 与 type 绑定的 source
    if source.type == 'doc.class'
    or source.type == 'doc.type' then
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                pushBackward(id, getID(src))
            end
        end
        -- 将 @return 映射到函数返回值上
        if source.returnIndex then
            for _, src in ipairs(parent.bindSources) do
                if src.type == 'function' then
                    local fullID = ('%s%s%s%s'):format(getID(src), SPLIT_CHAR, RETURN_INDEX_CHAR, source.returnIndex)
                    pushBackward(id, fullID)
                end
            end
        end
    end
    -- 将函数返回值映射到call的返回值接收上
    if parent.type == 'call' and parent.node == source then
        local sel = parent.parent
        if sel.type == 'select' then
            pushBackward(id, ('s:%d'):format(sel.start))
        end
    end
    -- 将调用参数映射到函数调用上
    if parent.type == 'callargs' then
        for i = 1, #parent do
            if parent[i] == source then
                local call = parent.parent
                local node = call.node
                local nodeID = getID(node)
                if not nodeID then
                    break
                end
                pushBackward(id, ('%s%s%s%s'):format(
                    nodeID,
                    SPLIT_CHAR,
                    PARAM_INDEX_CHAR,
                    i
                ))
                break
            end
        end
    end
    if source.type == 'doc.param' then
        print(source)
    end
end

---@class link
-- 当前节点的id
---@field id     string
-- 使用该ID的单元
---@field sources parser.guide.object[]
-- 前进的关联ID
---@field forward string[]
-- 后退的关联ID
---@field backward string[]

---创建source的链接信息
---@param id string
---@return link
function GetLink(id)
    if not Linkers[id] then
        Linkers[id] = {
            id = id,
        }
    end
    return Linkers[id]
end

local m = {}

m.SPLIT_CHAR = SPLIT_CHAR
m.RETURN_INDEX_CHAR = RETURN_INDEX_CHAR
m.PARAM_INDEX_CHAR = PARAM_INDEX_CHAR

---根据ID来获取所有的link
---@param root parser.guide.object
---@param id string
---@return link?
function m.getLinkByID(root, id)
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
        local id = getID(src)
        if not id then
            return
        end
        pushSource(id, src)
        checkForward(src)
        checkBackward(src)
    end)
    return Linkers
end

return m
