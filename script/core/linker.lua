local util    = require 'utility'
local guide   = require 'parser.guide'

local Linkers
local LastIDCache    = {}
local FirstIDCache   = {}
local SPLIT_CHAR     = '\x1F'
local LAST_REGEX     = SPLIT_CHAR .. '[^' .. SPLIT_CHAR .. ']*$'
local FIRST_REGEX    = '^[^' .. SPLIT_CHAR .. ']*'
local ANY_FIELD_CHAR = '*'
local RETURN_INDEX   = SPLIT_CHAR .. '#'
local PARAM_INDEX    = SPLIT_CHAR .. '@'
local TABLE_KEY      = SPLIT_CHAR .. '<'
local ANY_FIELD      = SPLIT_CHAR .. ANY_FIELD_CHAR

---创建source的链接信息
---@param id string
---@return link
local function getLink(id)
    if not Linkers[id] then
        Linkers[id] = {
            id = id,
        }
    end
    return Linkers[id]
end

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
            return ANY_FIELD_CHAR, source.node
        end
        if index.type == 'string' then
            return ('%q'):format(index[1] or ''), source.node
        else
            return ANY_FIELD_CHAR, source.node
        end
    elseif source.type == 'tableindex' then
        local index = source.index
        if not index then
            return ANY_FIELD_CHAR, source.parent
        end
        if index.type == 'string' then
            return ('%q'):format(index[1] or ''), source.parent
        else
            return ANY_FIELD_CHAR, source.parent
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
    elseif source.type == 'string' then
        return '', nil
    elseif source.type == 'integer'
    or     source.type == 'number'
    or     source.type == 'boolean'
    or     source.type == 'nil' then
        return source.start, nil
    elseif source.type == '...' then
        return source.start, nil
    elseif source.type == 'select' then
        return ('%d%s%d'):format(source.start, RETURN_INDEX, source.index)
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
        return source.start, nil
    elseif source.type == 'doc.class.name'
    or     source.type == 'doc.alias.name'
    or     source.type == 'doc.extends.name'
    or     source.type == 'doc.see.name' then
        local name = source[1]
        return name, nil
    elseif source.type == 'doc.type.name' then
        if source.typeGeneric then
            return source.start, nil
        else
            local name = source[1]
            return name, nil
        end
    elseif source.type == 'doc.class'
    or     source.type == 'doc.type'
    or     source.type == 'doc.alias'
    or     source.type == 'doc.param'
    or     source.type == 'doc.vararg'
    or     source.type == 'doc.field.name'
    or     source.type == 'doc.type.enum'
    or     source.type == 'doc.type.table'
    or     source.type == 'doc.type.array'
    or     source.type == 'doc.type.function' then
        return source.start, nil
    elseif source.type == 'doc.see.field' then
        return ('%q'):format(source[1]), source.parent.name
    elseif source.type == 'generic.closure' then
        return source.call.start, nil
    elseif source.type == 'generic.value' then
        return ('%s|%s'):format(
            source.closure.call.start,
            getKey(source.proto)
        )
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
    if source.type == 'string' then
        return 'str:'
    end
    if source.type == 'number'
    or source.type == 'integer'
    or source.type == 'boolean'
    or source.type == 'nil' then
        return 'l:'
    end
    if source.type == 'call' then
        return 'c:'
    end
    if source.type == 'doc.class.name'
    or source.type == 'doc.type.name'
    or source.type == 'doc.alias.name'
    or source.type == 'doc.extends.name' then
        return 'dn:'
    end
    if source.type == 'doc.field.name' then
        return 'dfn:'
    end
    if source.type == 'doc.see.name' then
        return 'dsn:'
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
    if source.type == 'doc.type.function' then
        return 'dfun:'
    end
    if source.type == 'doc.type.table' then
        return 'dtable:'
    end
    if source.type == 'doc.type.array' then
        return 'darray:'
    end
    if source.type == 'doc.vararg' then
        return 'dv:'
    end
    if source.type == 'doc.type.enum' then
        return 'de:'
    end
    if source.type == 'generic.closure' then
        return 'gc:'
    end
    if source.type == 'generic.value' then
        return 'gv:'
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
        if current.type == 'paren' then
            current = current.exp
            goto CONTINUE
        end
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
        ::CONTINUE::
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

---添加关联的前进ID
---@param id string
---@param forwardID string
local function pushForward(id, forwardID)
    if not id
    or not forwardID
    or forwardID == ''
    or id == forwardID then
        return
    end
    local link = getLink(id)
    if not link.forward then
        link.forward = {}
    end
    link.forward[#link.forward+1] = forwardID
end

---添加关联的后退ID
---@param id string
---@param backwardID string
local function pushBackward(id, backwardID)
    if not id
    or not backwardID
    or backwardID == ''
    or id == backwardID then
        return
    end
    local link = getLink(id)
    if not link.backward then
        link.backward = {}
    end
    link.backward[#link.backward+1] = backwardID
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
-- 函数调用参数信息（用于泛型）
---@field call parser.guide.object

local m = {}

m.SPLIT_CHAR   = SPLIT_CHAR
m.RETURN_INDEX = RETURN_INDEX
m.PARAM_INDEX  = PARAM_INDEX
m.TABLE_KEY    = TABLE_KEY
m.ANY_FIELD    = ANY_FIELD

---添加关联单元
---@param source parser.guide.object
function m.pushSource(source)
    local id = m.getID(source)
    if not id then
        return
    end
    local link = getLink(id)
    if not link.sources then
        link.sources = {}
    end
    link.sources[#link.sources+1] = source
end

---@param source parser.guide.object
---@return parser.guide.object[]
function m.compileLink(source)
    local id = getID(source)
    local parent = source.parent
    if not parent then
        return
    end
    if source.value then
        -- x = y : x -> y
        pushForward(id, getID(source.value))
        pushBackward(getID(source.value), id)
    end
    -- self -> mt:xx
    if source.type == 'local' and source[1] == 'self' then
        local func = guide.getParentFunction(source)
        local setmethod = func.parent
        -- guess `self`
        if setmethod and ( setmethod.type == 'setmethod'
                        or setmethod.type == 'setfield'
                        or setmethod.type == 'setindex') then
            pushForward(id, getID(setmethod.node))
            pushBackward(getID(setmethod.node), id)
        end
    end
    -- 分解 @type
    if source.type == 'doc.type' then
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                pushForward(getID(src), id)
                pushForward(id, getID(src))
            end
        end
        for _, typeUnit in ipairs(source.types) do
            pushForward(id, getID(typeUnit))
            pushBackward(getID(typeUnit), id)
        end
        for _, enumUnit in ipairs(source.enums) do
            pushForward(id, getID(enumUnit))
        end
    end
    -- 分解 @class
    if source.type == 'doc.class' then
        pushForward(id, getID(source.class))
        pushForward(getID(source.class), id)
        if source.extends then
            for _, ext in ipairs(source.extends) do
                pushForward(id, getID(ext))
                pushBackward(getID(ext), id)
            end
        end
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                pushForward(getID(src), id)
                pushForward(id, getID(src))
            end
        end
        do
            local start
            for _, doc in ipairs(source.bindGroup) do
                if doc.type == 'doc.class' then
                    start = doc == source
                end
                if start and doc.type == 'doc.field' then
                    local key = doc.field[1]
                    if key then
                        local keyID = ('%s%s%q'):format(
                            id,
                            SPLIT_CHAR,
                            key
                        )
                        pushForward(keyID, getID(doc.field))
                        pushBackward(getID(doc.field), keyID)
                        pushForward(keyID, getID(doc.extends))
                        pushBackward(getID(doc.extends), keyID)
                    end
                end
            end
        end
    end
    if source.type == 'doc.param' then
        pushForward(getID(source), getID(source.extends))
    end
    if source.type == 'doc.vararg' then
        pushForward(getID(source), getID(source.vararg))
    end
    if source.type == 'doc.see' then
        local nameID  = getID(source.name)
        local classID = nameID:gsub('^dsn:', 'dn:')
        pushForward(nameID, classID)
        if source.field then
            local fieldID      = getID(source.field)
            local fieldClassID = fieldID:gsub('^dsn:', 'dn:')
            pushForward(fieldID, fieldClassID)
        end
    end
    if source.type == 'call' then
        local node = source.node
        local nodeID = getID(node)
        if not nodeID then
            return
        end
        getLink(id).call = source
        -- 将 call 映射到 node#1 上
        local callID = ('%s%s%s'):format(
            nodeID,
            RETURN_INDEX,
            1
        )
        pushForward(id, callID)
        -- 将setmetatable映射到 param1 以及 param2.__index 上
        if node.special == 'setmetatable' then
            local tblID  = getID(source.args and source.args[1])
            local metaID = getID(source.args and source.args[2])
            local indexID
            if metaID then
                indexID = ('%s%s%q'):format(
                    metaID,
                    SPLIT_CHAR,
                    '__index'
                )
            end
            pushForward(id, callID)
            pushBackward(callID, id)
            pushForward(callID, tblID)
            pushForward(callID, indexID)
            pushBackward(tblID, callID)
            --pushBackward(indexID, callID)
        end
    end
    if source.type == 'select' then
        if source.vararg.type == 'call' then
            local call = source.vararg
            local node = call.node
            local nodeID = getID(node)
            if not nodeID then
                return
            end
            -- 将call的返回值接收映射到函数返回值上
            local callXID = ('%s%s%s'):format(
                nodeID,
                RETURN_INDEX,
                source.index
            )
            pushForward(id, callXID)
            pushBackward(callXID, id)
            getLink(id).call = call
            if node.special == 'pcall'
            or node.special == 'xpcall' then
                local index = source.index - 1
                if index <= 0 then
                    return
                end
                local funcID = call.args and getID(call.args[1])
                if not funcID then
                    return
                end
                local funcXID = ('%s%s%s'):format(
                    funcID,
                    RETURN_INDEX,
                    index
                )
                pushForward(id, funcXID)
                pushBackward(funcXID, id)
            end
        end
    end
    if source.type == 'doc.type.function' then
        if source.returns then
            for index, rtn in ipairs(source.returns) do
                local returnID = ('%s%s%s'):format(
                    id,
                    RETURN_INDEX,
                    index
                )
                pushForward(returnID, getID(rtn))
            end
        end
    end
    if source.type == 'doc.type.table' then
        if source.tkey then
            local keyID = ('%s%s'):format(
                id,
                TABLE_KEY
            )
            pushForward(keyID, getID(source.tkey))
        end
        if source.tvalue then
            local valueID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(valueID, getID(source.tvalue))
        end
    end
    if source.type == 'doc.type.array' then
        if source.node then
            local nodeID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(nodeID, getID(source.node))
        end
    end
    -- 将函数的返回值映射到具体的返回值上
    if source.type == 'function' then
        -- 检查实体返回值
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
                local returnID = ('%s%s%s'):format(
                    id,
                    RETURN_INDEX,
                    index
                )
                for _, rtnObj in ipairs(rtnObjs) do
                    pushForward(returnID, getID(rtnObj))
                    if rtnObj.type == 'function'
                    or rtnObj.type == 'call' then
                        pushBackward(getID(rtnObj), returnID)
                    end
                end
            end
        end
        -- 检查 luadoc
        if source.bindDocs then
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.return' then
                    for _, rtn in ipairs(doc.returns) do
                        local fullID = ('%s%s%s'):format(
                            id,
                            RETURN_INDEX,
                            rtn.returnIndex
                        )
                        pushForward(fullID, getID(rtn))
                        pushBackward(getID(rtn), fullID)
                    end
                end
                if doc.type == 'doc.param' then
                    local paramName = doc.param[1]
                    if source.docParamMap then
                        local paramIndex = source.docParamMap[paramName]
                        local param = source.args[paramIndex]
                        if param then
                            pushForward(getID(param), getID(doc))
                            param.docParam = doc
                        end
                    end
                end
                if doc.type == 'doc.vararg' then
                    for _, param in ipairs(source.args) do
                        if param.type == '...' then
                            pushForward(getID(param), getID(doc))
                        end
                    end
                end
                if doc.type == 'doc.generic' then
                    source.isGeneric = true
                end
            end
        end
    end
    if source.type == 'generic.closure' then
        for i, rtn in ipairs(source.returns) do
            local closureID = ('%s%s%s'):format(
                id,
                RETURN_INDEX,
                i
            )
            local returnID = getID(rtn)
            pushForward(closureID, returnID)
            pushBackward(returnID, closureID)
        end
    end
    if source.type == 'generic.value' then
        local proto    = source.proto
        local closure  = source.closure
        local upvalues = closure.upvalues
        if proto.type == 'doc.type.name' then
            local key = proto[1]
            if upvalues[key] then
                for _, paramID in ipairs(upvalues[key]) do
                    pushForward(id, paramID)
                    pushBackward(paramID, id)
                end
            end
        end
        if proto.type == 'doc.type' then
            for _, tp in ipairs(source.types) do
                pushForward(id, getID(tp))
                pushBackward(getID(tp), id)
            end
        end
        if proto.type == 'doc.type.array' then
            local nodeID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(nodeID, getID(source.node))
        end
        if proto.type == 'doc.type.table' then
            if source.tkey then
                local keyID = ('%s%s'):format(
                    id,
                    TABLE_KEY
                )
                pushForward(keyID, getID(source.tkey))
            end
            if source.tvalue then
                local valueID = ('%s%s'):format(
                    id,
                    ANY_FIELD
                )
                pushForward(valueID, getID(source.tvalue))
            end
        end
    end
end

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

---根据ID来获取第一个节点的ID
---@param id string
---@return string
function m.getFirstID(id)
    if FirstIDCache[id] then
        return FirstIDCache[id] or nil
    end
    local firstID, count = id:match(FIRST_REGEX)
    if count == 0 then
        FirstIDCache[id] = false
        return nil
    end
    FirstIDCache[id] = firstID
    return firstID
end

---根据ID来获取上个节点的ID
---@param id string
---@return string
function m.getLastID(id)
    if LastIDCache[id] then
        return LastIDCache[id] or nil
    end
    local lastID, count = id:gsub(LAST_REGEX, '')
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
        m.pushSource(src)
        m.compileLink(src)
    end)
    -- Special rule: ('').XX -> stringlib.XX
    pushForward('str:', 'dn:stringlib')
    return Linkers
end

return m
