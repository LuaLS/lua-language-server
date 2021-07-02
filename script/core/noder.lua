local util      = require 'utility'
local guide     = require 'parser.guide'
local collector = require 'core.collector'
local files     = require 'files'

local SPLIT_CHAR     = '\x1F'
local LAST_REGEX     = SPLIT_CHAR .. '[^' .. SPLIT_CHAR .. ']*$'
local FIRST_REGEX    = '^[^' .. SPLIT_CHAR .. ']*'
local HEAD_REGEX    = '^' .. SPLIT_CHAR .. '?[^' .. SPLIT_CHAR .. ']*'
local ANY_FIELD_CHAR = '*'
local INDEX_CHAR     = '['
local RETURN_INDEX   = SPLIT_CHAR .. '#'
local PARAM_INDEX    = SPLIT_CHAR .. '&'
local TABLE_KEY      = SPLIT_CHAR .. '<'
local WEAK_TABLE_KEY = SPLIT_CHAR .. '<<'
local INDEX_FIELD    = SPLIT_CHAR .. INDEX_CHAR
local ANY_FIELD      = SPLIT_CHAR .. ANY_FIELD_CHAR
local WEAK_ANY_FIELD = SPLIT_CHAR .. ANY_FIELD_CHAR .. ANY_FIELD_CHAR
local URI_CHAR       = '@'
local URI_REGEX      = URI_CHAR .. '([^' .. URI_CHAR .. ']*)' .. URI_CHAR .. '(.*)'

---@class node
-- 当前节点的id
---@field id     string
-- 使用该ID的单元
---@field source parser.guide.object
-- 使用该ID的单元
---@field sources parser.guide.object[]
-- 前进的关联ID
---@field forward string
-- 第一个前进关联的tag
---@field ftag string|boolean
-- 前进的关联ID
---@field forwards string[]
-- 后退的关联ID
---@field backward string
-- 第一个后退关联的tag
---@field btag string|boolean
-- 后退的关联ID
---@field backwards string[]
-- 函数调用参数信息（用于泛型）
---@field call parser.guide.object
---@field skip boolean

---@alias noders table<string, node[]>

---创建source的链接信息
---@param noders noders
---@param id string
---@return node
local function getNode(noders, id)
    if not noders[id] then
        noders[id] = {
            id = id,
        }
    end
    return noders[id]
end

---如果对象是 arg self, 则认为 id 是 method 的 node
---@param source parser.guide.object
---@return nil
local function getMethodNode(source)
    if source.type ~= 'local' or source[1] ~= 'self' then
        return nil
    end
    if source._mnode ~= nil then
        return source._mnode or nil
    end
    source._mnode = false
    local func = guide.getParentFunction(source)
    if func.isGeneric then
        return
    end
    if source.parent.type ~= 'funcargs' then
        return
    end
    local setmethod = func.parent
    if setmethod and ( setmethod.type == 'setmethod'
                    or setmethod.type == 'setfield'
                    or setmethod.type == 'setindex') then
        source._mnode = setmethod.node
        return setmethod.node
    end
end

---获取语法树单元的key
---@param source parser.guide.object
---@return string? key
---@return parser.guide.object? node
local function getKey(source)
    if     source.type == 'local' then
        if source.parent.type == 'funcargs' then
            return 'p:' .. source.start, nil
        end
        return 'l:' .. source.start, nil
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        return getKey(source.node)
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        local node = source.node
        if node.tag == '_ENV' then
            return ('%q'):format(source[1] or ''), nil
        else
            return ('%q'):format(source[1] or ''), node
        end
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
            return INDEX_CHAR, source.node
        end
        if index.type == 'string'
        or index.type == 'boolean'
        or index.type == 'integer'
        or index.type == 'number' then
            return ('%q'):format(index[1] or ''), source.node
        else
            return INDEX_CHAR, source.node
        end
    elseif source.type == 'tableindex' then
        local index = source.index
        if not index then
            return ANY_FIELD_CHAR, source.parent
        end
        if index.type == 'string'
        or index.type == 'boolean'
        or index.type == 'integer'
        or index.type == 'number' then
            return ('%q'):format(index[1] or ''), source.parent
        elseif index.type ~= 'function'
        and    index.type ~= 'table' then
            return ANY_FIELD_CHAR, source.parent
        end
    elseif source.type == 'table' then
        return 't:' .. source.start, nil
    elseif source.type == 'label' then
        return 'l:' .. source.start, nil
    elseif source.type == 'goto' then
        if source.node then
            return 'l:' .. source.node.start, nil
        end
        return nil, nil
    elseif source.type == 'function' then
        return 'f:' .. source.start, nil
    elseif source.type == 'string' then
        return 'str:', nil
    elseif source.type == 'integer' then
        return 'int:'
    elseif source.type == 'number' then
        return 'num:'
    elseif source.type == 'boolean' then
        return 'bool:'
    elseif source.type == 'nil' then
        return 'nil:', nil
    elseif source.type == '...' then
        return 'va:' .. source.start, nil
    elseif source.type == 'varargs' then
        if source.node then
            return 'va:' .. source.node.start, nil
        end
    elseif source.type == 'select' then
        return ('s:%d%s%d'):format(source.start, RETURN_INDEX, source.sindex)
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
        return 'c:' .. source.finish, nil
    elseif source.type == 'doc.class.name'
    or     source.type == 'doc.alias.name'
    or     source.type == 'doc.extends.name' then
        local name = source[1]
        return 'dn:' .. name, nil
    elseif source.type == 'doc.type.name' then
        local name = source[1]
        if source.typeGeneric then
            return 'dg:' .. source.typeGeneric[name][1].start, nil
        else
            return 'dn:' .. name, nil
        end
    elseif source.type == 'doc.see.name' then
        local name = source[1]
        return 'dsn:' .. name, nil
    elseif source.type == 'doc.class' then
        return 'dc:' .. source.start
    elseif source.type == 'doc.type' then
        return 'dt:' .. source.start
    elseif source.type == 'doc.param' then
        return 'dp:' .. source.start
    elseif source.type == 'doc.vararg' then
        return 'dv:' .. source.start
    elseif source.type == 'doc.field.name' then
        return 'dfn:' .. source.start
    elseif source.type == 'doc.type.enum'
    or     source.type == 'doc.resume' then
        return 'de:' .. source.start
    elseif source.type == 'doc.type.table' then
        return 'dtable:' .. source.start
    elseif source.type == 'doc.type.array' then
        return 'darray:' .. source.start
    elseif source.type == 'doc.type.function' then
        return 'dfun:' .. source.start, nil
    elseif source.type == 'doc.see.field' then
        return ('%q'):format(source[1]), source.parent.name
    elseif source.type == 'generic.closure' then
        return 'gc:' .. source.call.start, nil
    elseif source.type == 'generic.value' then
        local tail = ''
        if guide.getUri(source.closure.call) ~= guide.getUri(source.proto) then
            tail = URI_CHAR .. guide.getUri(source.closure.call)
        end
        return ('gv:%s|%s%s'):format(
            source.closure.call.start,
            getKey(source.proto),
            tail
        )
    end
    return nil, nil
end

local function getNodeKey(source)
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        source = source.node
    end
    local methodNode = getMethodNode(source)
    if methodNode then
        return getNodeKey(methodNode)
    end
    local key, node = getKey(source)
    if guide.isGlobal(source) then
        return 'g:' .. key, nil
    end
    return key, node
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
            if not current then
                return nil
            end
            goto CONTINUE
        end
        local id, node = getNodeKey(current)
        if not id then
            break
        end
        index = index + 1
        IDList[index] = id
        if not node then
            break
        end
        current = node
        ::CONTINUE::
    end
    if index == 0 then
        source._id = false
        return nil
    end
    for i = index + 1, #IDList do
        IDList[i] = nil
    end
    util.revertTable(IDList)
    local id = table.concat(IDList, SPLIT_CHAR)
    source._id = id
    return id
end

---添加关联的前进ID
---@param noders noders
---@param id string
---@param forwardID string
local function pushForward(noders, id, forwardID, tag)
    if not id
    or not forwardID
    or forwardID == ''
    or id == forwardID then
        return
    end
    local node = getNode(noders, id)
    if not node.forward then
        node.forward = forwardID
        node.ftag    = tag
        return
    end
    if node.forward == forwardID then
        return
    end
    if not node.forwards then
        node.forwards = {}
    end
    if node.forwards[forwardID] ~= nil then
        return
    end
    node.forwards[forwardID] = tag or false
    node.forwards[#node.forwards+1] = forwardID
end

---添加关联的后退ID
---@param noders noders
---@param id string
---@param backwardID string
local function pushBackward(noders, id, backwardID, tag)
    if not id
    or not backwardID
    or backwardID == ''
    or id == backwardID then
        return
    end
    local node = getNode(noders, id)
    if not node.backward then
        node.backward = backwardID
        node.btag     = tag
        return
    end
    if node.backward == backwardID then
        return
    end
    if not node.backwards then
        node.backwards = {}
    end
    if node.backwards[backwardID] ~= nil then
        return
    end
    node.backwards[backwardID] = tag or false
    node.backwards[#node.backwards+1] = backwardID
end

---@class noder
local m = {}

m.SPLIT_CHAR     = SPLIT_CHAR
m.RETURN_INDEX   = RETURN_INDEX
m.PARAM_INDEX    = PARAM_INDEX
m.TABLE_KEY      = TABLE_KEY
m.ANY_FIELD      = ANY_FIELD
m.URI_CHAR       = URI_CHAR
m.INDEX_FIELD    = INDEX_FIELD
m.WEAK_TABLE_KEY = WEAK_TABLE_KEY
m.WEAK_ANY_FIELD = WEAK_ANY_FIELD

--- 寻找doc的主体
---@param obj parser.guide.object
---@return parser.guide.object
local function getDocStateWithoutCrossFunction(obj)
    for _ = 1, 1000 do
        local parent = obj.parent
        if not parent then
            return obj
        end
        if parent.type == 'doc' then
            return obj
        end
        if parent.type == 'doc.type.function' then
            return nil
        end
        obj = parent
    end
    error('guide.getDocState overstack')
end

---添加关联单元
---@param noders noders
---@param source parser.guide.object
function m.pushSource(noders, source, id)
    id = id or m.getID(source)
    if not id then
        return
    end
    if id == 'str:'
    or id == 'nil:'
    or id == 'num:'
    or id == 'int:'
    or id == 'bool:' then
        return
    end
    local node = getNode(noders, id)
    if not node.source then
        node.source = source
        return
    end
    if not node.sources then
        node.sources = {}
    end
    node.sources[#node.sources+1] = source
end

local DUMMY_FUNCTION = function () end

---遍历关联单元
---@param node node
---@return fun():parser.guide.object
function m.eachSource(node)
    if not node.source then
        return DUMMY_FUNCTION
    end
    local index
    local sources = node.sources
    return function ()
        if not index then
            index = 0
            return node.source
        end
        if not sources then
            return nil
        end
        index = index + 1
        return sources[index]
    end
end

---遍历forward
---@param node node
---@return fun():string, string
function m.eachForward(node)
    if not node.forward then
        return DUMMY_FUNCTION
    end
    local index
    local forwards = node.forwards
    return function ()
        if not index then
            index = 0
            return node.forward, node.ftag
        end
        if not forwards then
            return nil
        end
        index = index + 1
        local id  = forwards[index]
        local tag = forwards[id]
        return id, tag
    end
end

---遍历backward
---@param node node
---@return fun():string, string
function m.eachBackward(node)
    if not node.backward then
        return DUMMY_FUNCTION
    end
    local index
    local backwards = node.backwards
    return function ()
        if not index then
            index = 0
            return node.backward, node.btag
        end
        if not backwards then
            return nil
        end
        index = index + 1
        local id  = backwards[index]
        local tag = backwards[id]
        return id, tag
    end
end

local function bindValue(noders, source, id)
    local value = source.value
    if not value then
        return
    end
    local valueID = getID(value)
    if not valueID then
        return
    end
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        source = source.node
    end
    if source.bindDocs and value.type ~= 'table' then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.class'
            or doc.type == 'doc.type' then
                return
            end
        end
    end
    -- x = y : x -> y
    pushForward(noders, id, valueID, 'set')
    -- 参数/call禁止反向查找赋值
    local valueType = valueID:match '^(.-:).'
    if not valueType then
        return
    end
    if  valueType ~= 'p:'
    and valueType ~= 's:'
    and valueType ~= 'c:' then
        pushBackward(noders, valueID, id, 'set')
    else
        pushBackward(noders, valueID, id, 'deep')
    end
end

local function compileCallParam(noders, call, sourceID)
    if not sourceID then
        return
    end
    if not call.args then
        return
    end
    local node = call.node
    local fixIndex = 0
    if call.node.special == 'pcall' then
        fixIndex = 1
        node = call.args[1]
    elseif call.node.special == 'xpcall' then
        fixIndex = 2
        node = call.args[1]
    end
    local nodeID = getID(node)
    if not nodeID then
        return
    end
    for firstIndex, callArg in ipairs(call.args) do
        firstIndex = firstIndex - fixIndex
        if firstIndex > 0 and callArg.type == 'function' then
            if callArg.args then
                for secondIndex, funcParam in ipairs(callArg.args) do
                    local paramID = ('%s%s%s%s%s'):format(
                        nodeID,
                        PARAM_INDEX,
                        firstIndex,
                        PARAM_INDEX,
                        secondIndex
                    )
                    pushForward(noders, getID(funcParam), paramID)
                end
            end
        end
    end
end

local function compileCallReturn(noders, call, sourceID, returnIndex)
    if not sourceID then
        return
    end
    local node = call.node
    local nodeID = getID(node)
    if not nodeID then
        return
    end
    local callID = getID(call)
    if not callID then
        return
    end
    -- 将setmetatable映射到 param1 以及 param2.__index 上
    if node.special == 'setmetatable' then
        local tblID  = getID(call.args and call.args[1])
        local metaID = getID(call.args and call.args[2])
        local indexID
        if metaID then
            indexID = ('%s%s%q'):format(
                metaID,
                SPLIT_CHAR,
                '__index'
            )
        end
        pushForward(noders, sourceID, tblID)
        pushForward(noders, sourceID, indexID)
        pushBackward(noders, tblID, sourceID)
        --pushBackward(noders, indexID, callID)
        return
    end
    if node.special == 'require' then
        local arg1 = call.args and call.args[1]
        if arg1 and arg1.type == 'string' then
            getNode(noders, sourceID).require = arg1[1]
        end
        pushBackward(noders, callID, sourceID, 'deep')
        return
    end
    if node.special == 'pcall'
    or node.special == 'xpcall' then
        local index = returnIndex - 1
        if index <= 0 then
            return
        end
        local funcID = call.args and getID(call.args[1])
        if not funcID then
            return
        end
        local pfuncXID = ('%s%s%s'):format(
            funcID,
            RETURN_INDEX,
            index
        )
        pushForward(noders, sourceID, pfuncXID)
        pushBackward(noders, pfuncXID, sourceID, 'deep')
        return
    end
    local funcXID = ('%s%s%s'):format(
        nodeID,
        RETURN_INDEX,
        returnIndex
    )
    getNode(noders, sourceID).call = call
    pushForward(noders, sourceID, funcXID)
    pushBackward(noders, funcXID, sourceID, 'deep')
end

---@param noders noders
---@param source parser.guide.object
---@return parser.guide.object[]
function m.compileNode(noders, source)
    local id = getID(source)
    bindValue(noders, source, id)
    if source.special == 'setmetatable'
    or source.special == 'require'
    or source.special == 'dofile'
    or source.special == 'loadfile'
    or source.special == 'rawset'
    or source.special == 'rawget' then
        local node = getNode(noders, id)
        node.skip = true
    end
    if source.type == 'string' then
        pushForward(noders, id, 'str:')
    end
    if source.type == 'boolean' then
        pushForward(noders, id, 'dn:boolean')
    end
    if source.type == 'number' then
        pushForward(noders, id, 'dn:number')
    end
    if source.type == 'integer' then
        pushForward(noders, id, 'dn:integer')
    end
    if source.type == 'nil' then
        pushForward(noders, id, 'dn:nil')
    end
    -- self -> mt:xx
    if source.type == 'local' and source[1] == 'self' then
        local func = guide.getParentFunction(source)
        if func.isGeneric then
            return
        end
        if source.parent.type ~= 'funcargs' then
            return
        end
        local setmethod = func.parent
        -- guess `self`
        if setmethod and ( setmethod.type == 'setmethod'
                        or setmethod.type == 'setfield'
                        or setmethod.type == 'setindex') then
            pushForward(noders, id, getID(setmethod.node))
            pushBackward(noders, getID(setmethod.node), id, 'deep')
        end
    end
    -- 分解 @type
    if source.type == 'doc.type' then
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                pushForward(noders, getID(src), id)
                pushForward(noders, id, getID(src))
            end
        end
        for _, enumUnit in ipairs(source.enums) do
            pushForward(noders, id, getID(enumUnit))
        end
        for _, resumeUnit in ipairs(source.resumes) do
            pushForward(noders, id, getID(resumeUnit))
        end
        for _, typeUnit in ipairs(source.types) do
            local unitID = getID(typeUnit)
            pushForward(noders, id, unitID)
            if source.bindSources then
                for _, src in ipairs(source.bindSources) do
                    pushBackward(noders, unitID, getID(src))
                end
            end
        end
    end
    -- 分解 @alias
    if source.type == 'doc.alias' then
        pushForward(noders, getID(source.alias), getID(source.extends))
    end
    -- 分解 @class
    if source.type == 'doc.class' then
        pushForward(noders, id, getID(source.class))
        pushForward(noders, getID(source.class), id)
        if source.extends then
            for _, ext in ipairs(source.extends) do
                pushBackward(noders, id, getID(ext))
            end
        end
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                pushForward(noders, getID(src), id)
                pushForward(noders, id, getID(src))
            end
        end
        for _, field in ipairs(source.fields) do
            local key = field.field[1]
            if key then
                local keyID = ('%s%s%q'):format(
                    id,
                    SPLIT_CHAR,
                    key
                )
                pushForward(noders, keyID, getID(field.field))
                pushForward(noders, getID(field.field), keyID)
                pushForward(noders, keyID, getID(field.extends))
                pushBackward(noders, getID(field.extends), keyID)
            end
        end
    end
    if source.type == 'doc.param' then
        pushForward(noders, id, getID(source.extends))
        for _, src in ipairs(source.bindSources) do
            if src.type == 'local' and src.parent.type == 'in' then
                pushForward(noders, getID(src), id)
            end
        end
    end
    if source.type == 'doc.vararg' then
        pushForward(noders, getID(source), getID(source.vararg))
    end
    if source.type == 'doc.see' then
        local nameID  = getID(source.name)
        local classID = nameID:gsub('^dsn:', 'dn:')
        pushForward(noders, nameID, classID)
        if source.field then
            local fieldID      = getID(source.field)
            local fieldClassID = fieldID:gsub('^dsn:', 'dn:')
            pushForward(noders, fieldID, fieldClassID)
        end
    end
    if source.type == 'call' then
        if source.parent.type ~= 'select' then
            compileCallReturn(noders, source, id, 1)
        end
        compileCallParam(noders, source, id)
    end
    if source.type == 'select' then
        if source.vararg.type == 'call' then
            local call = source.vararg
            compileCallReturn(noders, call, id, source.sindex)
        end
        if source.vararg.type == 'varargs' then
            pushForward(noders, id, getID(source.vararg))
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
                pushForward(noders, returnID, getID(rtn))
            end
            for index, param in ipairs(source.args) do
                local paramID = ('%s%s%s'):format(
                    id,
                    PARAM_INDEX,
                    index
                )
                pushForward(noders, paramID, getID(param.extends))
            end
        end
        -- @type fun(x: T):T 的情况
        local docType = getDocStateWithoutCrossFunction(source)
        if docType and docType.type == 'doc.type' then
            guide.eachSourceType(source, 'doc.type.name', function (typeName)
                if typeName.typeGeneric then
                    source.isGeneric = true
                    return false
                end
            end)
        end
    end
    if source.type == 'doc.type.table' then
        if source.tkey then
            local keyID = ('%s%s'):format(
                id,
                TABLE_KEY
            )
            pushForward(noders, keyID, getID(source.tkey))
        end
        if source.tvalue then
            local valueID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(noders, valueID, getID(source.tvalue))
        end
    end
    if source.type == 'doc.type.array' then
        if source.node then
            local nodeID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(noders, nodeID, getID(source.node))
        end
        local keyID = ('%s%s'):format(
            id,
            TABLE_KEY
        )
        pushForward(noders, keyID, 'dn:integer')
    end
    if source.type == 'doc.type.name' then
        local uri = guide.getUri(source)
        collector.subscribe(uri, id, getNode(noders, id))
    end
    if source.type == 'doc.class.name'
    or source.type == 'doc.alias.name' then
        local uri = guide.getUri(source)
        collector.subscribe(uri, id, getNode(noders, id))

        local defID = 'def:' .. id
        collector.subscribe(uri, defID, getNode(noders, defID))
        m.pushSource(noders, source, defID)

        local defAnyID = 'def:dn:'
        collector.subscribe(uri, defAnyID, getNode(noders, defAnyID))
        m.pushSource(noders, source, defAnyID)
    end
    if id and id:sub(1, 2) == 'g:' then
        local uri = guide.getUri(source)
        collector.subscribe(uri, id, getNode(noders, id))
        if guide.isSet(source) then

            local defID = 'def:' .. id
            collector.subscribe(uri, defID, getNode(noders, defID))
            m.pushSource(noders, source, defID)

            if guide.isGlobal(source) then
                local defAnyID = 'def:g:'
                collector.subscribe(uri, defAnyID, getNode(noders, defAnyID))
                m.pushSource(noders, source, defAnyID)
            end
        end
    end
    -- 将函数的返回值映射到具体的返回值上
    if source.type == 'function' then
        local hasDocReturn = {}
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
                        pushForward(noders, fullID, getID(rtn))
                        for _, typeUnit in ipairs(rtn.types) do
                            pushBackward(noders, getID(typeUnit), fullID, 'deep')
                        end
                        hasDocReturn[rtn.returnIndex] = true
                    end
                end
                if doc.type == 'doc.param' then
                    local paramName = doc.param[1]
                    if source.docParamMap then
                        local paramIndex = source.docParamMap[paramName]
                        local param = source.args[paramIndex]
                        if param then
                            pushForward(noders, getID(param), getID(doc))
                            param.docParam = doc
                            local paramID = ('%s%s%s'):format(
                                id,
                                PARAM_INDEX,
                                paramIndex
                            )
                            pushForward(noders, paramID, getID(doc.extends))
                        end
                    end
                end
                if doc.type == 'doc.vararg' then
                    for _, param in ipairs(source.args) do
                        if param.type == '...' then
                            pushForward(noders, getID(param), getID(doc))
                        end
                    end
                end
                if doc.type == 'doc.generic' then
                    source.isGeneric = true
                end
                if doc.type == 'doc.overload' then
                    pushForward(noders, id, getID(doc.overload))
                end
            end
        end
        -- 检查实体返回值
        if source.returns then
            local returns = {}
            for _, rtn in ipairs(source.returns) do
                for index, rtnObj in ipairs(rtn) do
                    if not hasDocReturn[index] then
                        if not returns[index] then
                            returns[index] = {}
                        end
                        returns[index][#returns[index]+1] = rtnObj
                    end
                end
            end
            for index, rtnObjs in ipairs(returns) do
                local returnID = ('%s%s%s'):format(
                    id,
                    RETURN_INDEX,
                    index
                )
                for _, rtnObj in ipairs(rtnObjs) do
                    pushForward(noders, returnID, getID(rtnObj))
                    pushBackward(noders, getID(rtnObj), returnID, 'deep')
                end
            end
        end
    end
    if source.type == 'table' then
        local firstField = source[1]
        if firstField then
            if firstField.type == 'varargs' then
                local keyID = ('%s%s'):format(
                    id,
                    TABLE_KEY
                )
                local valueID = ('%s%s'):format(
                    id,
                    ANY_FIELD
                )
                source.array = firstField
                pushForward(noders, keyID, 'dn:integer')
                pushForward(noders, valueID, getID(firstField))
            else
                local keyID = ('%s%s'):format(
                    id,
                    WEAK_TABLE_KEY
                )
                local valueID = ('%s%s'):format(
                    id,
                    WEAK_ANY_FIELD
                )
                if firstField.type == 'tablefield' then
                    pushForward(noders, keyID, 'dn:string')
                    pushForward(noders, valueID, getID(firstField.value))
                elseif firstField.type == 'tableindex' then
                    pushForward(noders, keyID,   getID(firstField.index))
                    pushForward(noders, valueID, getID(firstField.value))
                else
                    pushForward(noders, keyID,   'dn:integer')
                    pushForward(noders, valueID, getID(firstField))
                end
            end
        end
    end
    if source.type == 'main' then
        if source.returns then
            for _, rtn in ipairs(source.returns) do
                local rtnObj = rtn[1]
                if rtnObj then
                    pushForward(noders, 'mainreturn', getID(rtnObj))
                    pushBackward(noders, getID(rtnObj), 'mainreturn', 'deep')
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
            pushForward(noders, closureID, returnID)
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
                    pushForward(noders, id, paramID)
                    pushBackward(noders, paramID, id)
                end
            end
        end
        if proto.type == 'doc.type' then
            for _, tp in ipairs(source.types) do
                pushForward(noders, id, getID(tp))
                pushBackward(noders, getID(tp), id)
            end
        end
        if proto.type == 'doc.type.array' then
            local nodeID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(noders, nodeID, getID(source.node))
            local keyID = ('%s%s'):format(
                id,
                TABLE_KEY
            )
            pushForward(noders, keyID, 'dn:integer')
        end
        if proto.type == 'doc.type.table' then
            if source.tkey then
                local keyID = ('%s%s'):format(
                    id,
                    TABLE_KEY
                )
                pushForward(noders, keyID, getID(source.tkey))
            end
            if source.tvalue then
                local valueID = ('%s%s'):format(
                    id,
                    ANY_FIELD
                )
                pushForward(noders, valueID, getID(source.tvalue))
            end
        end
    end
end

---根据ID来获取所有的node
---@param root parser.guide.object
---@param id string
---@return node?
function m.getNodeByID(root, id)
    root = guide.getRoot(root)
    local noders = root._noders
    if not noders then
        return nil
    end
    return noders[id]
end

---根据ID来获取第一个节点的ID
---@param id string
---@return string
function m.getFirstID(id)
    local firstID, count = id:match(FIRST_REGEX)
    if count == 0 then
        return nil
    end
    if firstID == '' then
        return nil
    end
    return firstID
end

---根据ID来获取第一个节点的ID或field
---@param id string
---@return string
function m.getHeadID(id)
    local headID, count = id:match(HEAD_REGEX)
    if count == 0 then
        return nil
    end
    if headID == '' then
        return nil
    end
    return headID
end

---根据ID来获取上个节点的ID
---@param id string
---@return string
function m.getLastID(id)
    local lastID, count = id:gsub(LAST_REGEX, '')
    if count == 0 then
        return nil
    end
    if lastID == '' then
        return nil
    end
    return lastID
end

---获取ID的长度
---@param id string
---@return integer
function m.getIDLength(id)
    if not id then
        return 0
    end
    local _, count = id:gsub(SPLIT_CHAR, SPLIT_CHAR)
    return count + 1
end

---测试id是否包含field，如果遇到函数调用则中断
---@param id string
---@return boolean
function m.hasField(id)
    local firstID = m.getFirstID(id)
    if firstID == id or not firstID then
        return false
    end
    local nextChar = id:sub(#firstID + 1, #firstID + 1)
    if nextChar ~= SPLIT_CHAR then
        return false
    end
    local next2Char = id:sub(#firstID + 2, #firstID + 2)
    if next2Char == RETURN_INDEX
    or next2Char == PARAM_INDEX then
        return false
    end
    return true
end

---把形如 `@file:\\\XXXXX@gv:1|1`拆分成uri与id
---@param id string
---@return uri? string
---@return string id
function m.getUriAndID(id)
    local uri, newID = id:match(URI_REGEX)
    return uri, newID
end

---获取source的ID
---@param source parser.guide.object
---@return string
function m.getID(source)
    return getID(source)
end

---获取source的key
---@param source parser.guide.object
---@return string
function m.getKey(source)
    return getKey(source)
end

---清除临时id（用于泛型的临时对象）
---@param root parser.guide.object
---@param id string
function m.removeID(root, id)
    root = guide.getRoot(root)
    local noders = root._noders
    noders[id] = nil
end

---寻找doc的主体
---@param doc parser.guide.object
function m.getDocState(doc)
    return getDocStateWithoutCrossFunction(doc)
end

---获取对象的noders
---@param source parser.guide.object
---@return noders
function m.getNoders(source)
    local root = guide.getRoot(source)
    if not root._noders then
        root._noders = {}
    end
    return root._noders
end

---编译整个文件的node
---@param  source parser.guide.object
---@return table
function m.compileNodes(source)
    local root = guide.getRoot(source)
    local noders = m.getNoders(source)
    if next(noders) then
        return noders
    end
    log.debug('compileNodes:', guide.getUri(root))
    collector.dropUri(guide.getUri(root))
    guide.eachSource(root, function (src)
        m.pushSource(noders, src)
        m.compileNode(noders, src)
    end)
    log.debug('compileNodes finish:', guide.getUri(root))
    return noders
end

files.watch(function (ev, uri)
    uri = files.asKey(uri)
    if ev == 'update' then
        local state = files.getState(uri)
        if state then
            m.compileNodes(state.ast)
        end
    end
    if ev == 'remove' then
        collector.dropUri(uri)
    end
end)

return m
