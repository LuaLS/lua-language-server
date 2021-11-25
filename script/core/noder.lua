local util      = require 'utility'
local guide     = require 'parser.guide'
local collector = require 'core.collector'
local files     = require 'files'
local config    = require 'config'

local tostring = tostring
local error    = error
local ipairs   = ipairs
local type     = type
local next     = next
local log      = log
local ssub     = string.sub
local sformat  = string.format
local sgsub    = string.gsub
local smatch   = string.match
local sfind    = string.find

_ENV = nil

local SPLIT_CHAR     = '\x1F'
local LAST_REGEX     = SPLIT_CHAR .. '[^' .. SPLIT_CHAR .. ']*$'
local FIRST_REGEX    = '^[^' .. SPLIT_CHAR .. ']*'
local HEAD_REGEX     = '^' .. SPLIT_CHAR .. '?[^' .. SPLIT_CHAR .. ']*'
local STRING_CHAR    = '.'
local ANY_FIELD_CHAR = '*'
local INDEX_CHAR     = '['
local RETURN_INDEX   = SPLIT_CHAR .. '#'
local PARAM_INDEX    = SPLIT_CHAR .. '&'
local PARAM_NAME     = SPLIT_CHAR .. '$'
local EVENT_ENUM     = SPLIT_CHAR .. '>'
local TABLE_KEY      = SPLIT_CHAR .. '<'
local WEAK_TABLE_KEY = SPLIT_CHAR .. '<<'
local STRING_FIELD   = SPLIT_CHAR .. STRING_CHAR
local INDEX_FIELD    = SPLIT_CHAR .. INDEX_CHAR
local ANY_FIELD      = SPLIT_CHAR .. ANY_FIELD_CHAR
local WEAK_ANY_FIELD = SPLIT_CHAR .. ANY_FIELD_CHAR .. ANY_FIELD_CHAR
local URI_CHAR       = '@'
local URI_REGEX      = URI_CHAR .. '([^' .. URI_CHAR .. ']*)' .. URI_CHAR .. '(.*)'

local INFO_DEEP = {
    deep = true,
}
local INFO_REJECT_SET = {
    reject = 'set',
}
local INFO_DEEP_AND_REJECT_SET = {
    reject = 'set',
    deep   = true,
}
local INFO_META_INDEX = {
    filter = function (id, field)
        if field then
            return true
        end
        return ssub(id, 1, 2) ~= 'f:'
    end,
    filterValid = function (id, field)
        return not field
    end
}
local INFO_CLASS_TO_EXNTENDS = {
    filter = function (_, field, mode)
        return field ~= nil
            or mode == 'field'
            or mode == 'allfield'
    end,
    filterValid = function (_, field)
        return not field
    end,
    reject = 'set',
}
local INFO_DEEP_AND_DONT_CROSS = {
    deep      = true,
    dontCross = true,
}

---@alias node.id string
---@alias node.filter fun(id: string, field?: string):boolean

---@class noders
-- 使用该ID的单元
---@field source    table<node.id, parser.guide.object>
-- 使用该ID的单元
---@field sources   table<node.id, parser.guide.object[]>
-- 前进的关联ID
---@field forward   table<node.id, node.id>
-- 第一个前进关联的info
---@field finfo?    table<node.id, node.info>
-- 前进的关联ID与info
---@field forwards  table<node.id, node.id[]|table<node.id, node.info>>
-- 后退的关联ID
---@field backward  table<node.id, node.id>
-- 第一个后退关联的info
---@field binfo?    table<node.id, node.info>
-- 后退的关联ID与info
---@field backwards table<node.id, node.id[]|table<node.id, node.info>>
-- 函数调用参数信息（用于泛型）
---@field call      table<node.id, parser.guide.object>
---@field require   table<node.id, string>
---@field skip      table<node.id, boolean>

---@class node.info
---@field reject?      string
---@field deep?        boolean
---@field filter?      node.filter
---@field filterValid? node.filter
---@field dontCross?   boolean

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
    if not func then
        return
    end
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

local function getFieldEventName(field)
    if field._eventName then
        return field._eventName or nil
    end
    field._eventName = false
    local fieldType = field.extends
    if not fieldType then
        return nil
    end
    local docFunc = fieldType.types[1]
    if not docFunc or docFunc.type ~= 'doc.type.function' then
        return nil
    end
    local firstArg = docFunc.args and docFunc.args[1]
    if not firstArg then
        return nil
    end
    local secondArg
    if firstArg.name[1] == 'self' then
        firstArg = docFunc.args[2]
        if not firstArg then
            return nil
        end
        secondArg = docFunc.args[3]
    else
        secondArg = docFunc.args[2]
    end
    if not secondArg then
        return
    end
    local firstType = firstArg.extends
    if not firstType then
        return nil
    end
    local firstEnum = #firstType.enums == 1 and #firstType.types == 0 and firstType.enums[1]
    if not firstEnum then
        return nil
    end
    local secondType = secondArg.extends
    if not secondType then
        return nil
    end
    local secondTypeUnit = #secondType.enums == 0 and #secondType.types == 1 and secondType.types[1]
    if not secondTypeUnit or secondTypeUnit.type ~= 'doc.type.function' then
        return nil
    end
    local eventName = firstEnum[1]:match [[^['"](.+)['"]$]]
    field._eventName = eventName
    return eventName
end

local getKey, getID
local getKeyMap = util.switch()
    : case 'local'
    : call(function (source)
        if source.parent.type == 'funcargs' then
            return 'p:' .. source.start, nil
        end
        return 'l:' .. source.start, nil
    end)
    : case 'setlocal'
    : case 'getlocal'
    : call(function (source)
        return getKey(source.node)
    end)
    : case 'setglobal'
    : case 'getglobal'
    : call(function (source)
        local node = source.node
        if node.tag == '_ENV' then
            return STRING_CHAR .. (source[1] or ''), nil
        else
            return STRING_CHAR .. (source[1] or ''), node
        end
    end)
    : case 'getfield'
    : case 'setfield'
    : call(function (source)
        return STRING_CHAR .. (source.field and source.field[1] or ''), source.node
    end)
    : case 'tablefield'
    : call(function (source)
        local t = source.parent
        local parent = t.parent
        local node
        if parent.value == t then
            node = parent
        else
            node = t
        end
        return STRING_CHAR .. (source.field and source.field[1] or ''), node
    end)
    : case 'getmethod'
    : case 'setmethod'
    : call(function (source)
        return STRING_CHAR .. (source.method and source.method[1] or ''), source.node
    end)
    : case 'setindex'
    : case 'getindex'
    : call(function (source)
        local index = source.index
        if not index then
            return INDEX_CHAR, source.node
        end
        if index.type == 'string' then
            return STRING_CHAR .. (index[1] or ''), source.node
        elseif index.type == 'boolean'
        or     index.type == 'integer'
        or     index.type == 'number' then
            return tostring(index[1] or ''), source.node
        else
            return INDEX_CHAR, source.node
        end
    end)
    : case 'tableindex'
    : call(function (source)
        local t = source.parent
        local parent = t.parent
        local node
        if parent.value == t then
            node = parent
        else
            node = t
        end
        local index = source.index
        if not index then
            return ANY_FIELD_CHAR, node
        end
        if index.type == 'string' then
            return STRING_CHAR .. (index[1] or ''), node
        elseif index.type == 'boolean'
        or     index.type == 'integer'
        or     index.type == 'number' then
            return tostring(index[1] or ''), node
        elseif index.type ~= 'function'
        and    index.type ~= 'table' then
            return ANY_FIELD_CHAR, node
        end
    end)
    : case 'tableexp'
    : call(function (source)
        local t = source.parent
        local parent = t.parent
        local node
        if parent.value == t then
            node = parent
        else
            node = t
        end
        return tostring(source.tindex), node
    end)
    : case 'table'
    : call(function (source)
        return 't:' .. source.start, nil
    end)
    : case 'label'
    : call(function (source)
        return 'l:' .. source.start, nil
    end)
    : case 'goto'
    : call(function (source)
        if source.node then
            return 'l:' .. source.node.start, nil
        end
        return nil, nil
    end)
    : case 'function'
    : call(function (source)
        return 'f:' .. source.start, nil
    end)
    : case 'string'
    : call(function (source)
        return 'str:', nil
    end)
    : case 'integer'
    : call(function (source)
        return 'int:', nil
    end)
    : case 'number'
    : call(function (source)
        return 'num:', nil
    end)
    : case 'boolean'
    : call(function (source)
        return 'bool:', nil
    end)
    : case 'nil'
    : call(function (source)
        return 'nil:', nil
    end)
    : case '...'
    : call(function (source)
        return 'va:' .. source.start, nil
    end)
    : case 'varargs'
    : call(function (source)
        if source.node then
            return 'va:' .. source.node.start, nil
        end
    end)
    : case 'select'
    : call(function (source)
        return sformat('s:%d%s%d', source.start, RETURN_INDEX, source.sindex)
    end)
    : case 'call'
    : call(function (source)
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
                return STRING_CHAR .. (key[1] or ''), tbl
            else
                return '', tbl
            end
        end
        return 'c:' .. source.finish, nil
    end)
    : case 'doc.class.name'
    : case 'doc.alias.name'
    : case 'doc.extends.name'
    : call(function (source)
        local name = source[1]
        return 'dn:' .. name, nil
    end)
    : case 'doc.type.name'
    : call(function (source)
        local name = source[1]
        if source.typeGeneric then
            local first = source.typeGeneric[name][1]
            if first then
                return 'dg:' .. first.start, nil
            end
        else
            return 'dn:' .. name, nil
        end
    end)
    : case 'doc.see.name'
    : call(function (source)
        local name = source[1]
        return 'dsn:' .. name, nil
    end)
    : case 'doc.class'
    : call(function (source)
        return 'dc:' .. source.start
    end)
    : case 'doc.type'
    : call(function (source)
        return 'dt:' .. source.start
    end)
    : case 'doc.param'
    : call(function (source)
        return 'dp:' .. source.start
    end)
    : case 'doc.vararg'
    : call(function (source)
        return 'dv:' .. source.start
    end)
    : case 'doc.field.name'
    : call(function (source)
        return 'dfn:' .. source.start
    end)
    : case 'doc.type.enum'
    : case 'doc.resume'
    : call(function (source)
        return 'de:' .. source.start
    end)
    : case 'doc.type.table'
    : call(function (source)
        return 'dtable:' .. source.start
    end)
    : case 'doc.type.ltable'
    : call(function (source)
        return 'dltable:' .. source.start
    end)
    : case 'doc.type.field'
    : call(function (source)
        return 'dfield:' .. source.start
    end)
    : case 'doc.type.array'
    : call(function (source)
        return 'darray:' .. source.finish
    end)
    : case 'doc.type.function'
    : call(function (source)
        return 'dfun:' .. source.start, nil
    end)
    : case 'doc.see.field'
    : call(function (source)
        return STRING_CHAR .. (source[1]), source.parent.name
    end)
    : case 'generic.closure'
    : call(function (source)
        return 'gc:' .. source.call.start, nil
    end)
    : case 'generic.value'
    : call(function (source)
        local tail = ''
        if guide.getUri(source.closure.call) ~= guide.getUri(source.proto) then
            tail = URI_CHAR .. guide.getUri(source.closure.call)
        end
        return sformat('gv:%s|%s%s'
            , source.closure.call.start
            , getKey(source.proto)
            , tail
        )
    end)
    : getMap()

---获取语法树单元的key
---@param source parser.guide.object
---@return string? key
---@return parser.guide.object? node
function getKey(source)
    local f = getKeyMap[source.type]
    if f then
        return f(source)
    end
    return nil
end

local function getLocalValueID(source)
    if source.type ~= 'local' then
        return nil
    end
    local value = source.value
    if not value then
        return nil
    end
    local id = getID(value)
    if not id then
        return nil
    end
    local ct = id:sub(1, 2)
    if ct == 'g:'
    or ct == 'p:'
    or ct == 'l:' then
        return id
    end
    return nil
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
    if config.get 'Lua.IntelliSense.traceFieldInject' then
        local localValueID = getLocalValueID(source)
        if localValueID then
            return localValueID
        end
    end
    local key, node = getKey(source)
    if key and guide.isGlobal(source) then
        return 'g:' .. key, nil
    end
    return key, node
end

---获取语法树单元的字符串ID
---@param source parser.guide.object
---@return string? id
function getID(source)
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
    while current.type == 'paren' do
        current = current.exp
        if not current then
            source._id = false
            return nil
        end
    end
    local id, node = getNodeKey(current)
    if not id then
        source._id = false
        return nil
    end
    if node then
        local pid = getID(node)
        if not pid then
            source._id = false
            return nil
        end
        id = pid .. SPLIT_CHAR .. id
    end
    source._id = id
    return id
end

---添加关联的前进ID
---@param noders    noders
---@param id        string
---@param forwardID string
---@param info?     node.info
local function pushForward(noders, id, forwardID, info)
    if not id
    or not forwardID
    or forwardID == ''
    or id == forwardID then
        return
    end
    if not noders.forward[id] then
        noders.forward[id] = forwardID
        noders.finfo[id]   = info
        return
    end
    if noders.forward[id] == forwardID then
        return
    end
    local forwards = noders.forwards[id]
    if not forwards then
        forwards = {}
        noders.forwards[id] = forwards
    end
    if forwards[forwardID] ~= nil then
        return
    end
    forwards[forwardID] = info or false
    forwards[#forwards+1] = forwardID
end

---添加关联的后退ID
---@param noders     noders
---@param id         string
---@param backwardID string
---@param info?      node.info
local function pushBackward(noders, id, backwardID, info)
    if not id
    or not backwardID
    or backwardID == ''
    or id == backwardID then
        return
    end
    if not noders.backward[id] then
        noders.backward[id] = backwardID
        noders.binfo[id]    = info
        return
    end
    if noders.backward[id] == backwardID then
        return
    end
    local backwards = noders.backwards[id]
    if not backwards then
        backwards = {}
        noders.backwards[id] = backwards
    end
    if backwards[backwardID] ~= nil then
        return
    end
    backwards[backwardID] = info or false
    backwards[#backwards+1] = backwardID
end

---@class noder
local m = {}

m.SPLIT_CHAR     = SPLIT_CHAR
m.STRING_CHAR    = STRING_CHAR
m.STRING_FIELD   = STRING_FIELD
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

local dontPushSourceMap = util.arrayToHash {
    'str:', 'nil:', 'num:', 'int:', 'bool:'
}

---添加关联单元
---@param noders noders
---@param source parser.guide.object
function m.pushSource(noders, source, id)
    id = id or getID(source)
    if not id then
        return
    end
    if dontPushSourceMap[id] then
        return
    end
    if not noders.source[id] then
        noders.source[id] = source
        return
    end
    local sources = noders.sources[id]
    if not sources then
        sources = {}
        noders.sources[id] = sources
    end
    sources[#sources+1] = source
end

local DUMMY_FUNCTION = function () end

---遍历关联单元
---@param noders noders
---@param id node.id
---@return fun():parser.guide.object
function m.eachSource(noders, id)
    local source = noders.source[id]
    if not source then
        return DUMMY_FUNCTION
    end
    local index
    local sources = noders.sources[id]
    return function ()
        if not index then
            index = 0
            return source
        end
        if not sources then
            return nil
        end
        index = index + 1
        return sources[index]
    end
end

---遍历forward
---@param noders noders
---@param id node.id
---@return fun():string, node.info
function m.eachForward(noders, id)
    local forward = noders.forward[id]
    if not forward then
        return DUMMY_FUNCTION
    end
    local index
    local forwards = noders.forwards[id]
    return function ()
        if not index then
            index = 0
            return forward, noders.finfo[id]
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
---@param noders noders
---@param id node.id
---@return fun():string, node.info
function m.eachBackward(noders, id)
    local backward = noders.backward[id]
    if not backward then
        return DUMMY_FUNCTION
    end
    local index
    local backwards = noders.backwards[id]
    return function ()
        if not index then
            index = 0
            return backward, noders.binfo[id]
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

    local bindDocs = source.bindDocs
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        if not config.get 'Lua.IntelliSense.traceLocalSet' then
            return
        end
        bindDocs = source.node.bindDocs
    end
    if bindDocs and value.type ~= 'table' then
        for _, doc in ipairs(bindDocs) do
            if doc.type == 'doc.class'
            or doc.type == 'doc.type' then
                return
            end
        end
    end
    -- x = y : x -> y
    pushForward(noders, id, valueID, INFO_REJECT_SET)
    if  not config.get 'Lua.IntelliSense.traceBeSetted'
    and source.type ~= 'local' then
        return
    end
    -- 参数/call禁止反向查找赋值
    local valueType = smatch(valueID, '^(.-:).')
    if not valueType then
        return
    end
    pushBackward(noders, valueID, id, INFO_DEEP_AND_REJECT_SET)
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
    local methodIndex = 0
    if node.type == 'getmethod' then
        fixIndex = fixIndex + 1
        methodIndex = 1
    end
    local eventNodeID
    for firstIndex, callArg in ipairs(call.args) do
        firstIndex = firstIndex - fixIndex
        if firstIndex == 1 and callArg.type == 'string' then
            if callArg[1] then
                eventNodeID = sformat('%s%s%s'
                    , nodeID
                    , EVENT_ENUM
                    , callArg[1]
                )
            end
        end
        if firstIndex > 0 and callArg.type == 'function' then
            if callArg.args then
                for secondIndex, funcParam in ipairs(callArg.args) do
                    local paramID = sformat('%s%s%s%s%s'
                        , nodeID
                        , PARAM_INDEX
                        , firstIndex + methodIndex
                        , PARAM_INDEX
                        , secondIndex
                    )
                    pushForward(noders, getID(funcParam), paramID)
                    if eventNodeID then
                        local eventParamID = sformat('%s%s%s%s%s'
                            , eventNodeID
                            , PARAM_INDEX
                            , firstIndex + methodIndex
                            , PARAM_INDEX
                            , secondIndex
                        )
                        pushForward(noders, getID(funcParam), eventParamID)
                    end
                end
            end
        end
        if callArg.type == 'table' then
            local paramID = sformat('%s%s%s'
                , nodeID
                , PARAM_INDEX
                , firstIndex + methodIndex
            )
            pushForward(noders, getID(callArg), paramID)
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
            indexID = sformat('%s%s%s'
                , metaID
                , STRING_FIELD
                , '__index'
            )
        end
        pushForward(noders, sourceID, tblID)
        pushForward(noders, sourceID, indexID, INFO_META_INDEX)
        pushBackward(noders, tblID, sourceID)
        --pushBackward(noders, indexID, callID)
        return
    end
    if node.special == 'require' then
        local arg1 = call.args and call.args[1]
        if arg1 and arg1.type == 'string' then
            noders.require[sourceID] = arg1[1]
        end
        pushBackward(noders, callID, sourceID, INFO_DEEP)
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
        local pfuncXID = sformat('%s%s%s'
            , funcID
            , RETURN_INDEX
            , index
        )
        pushForward(noders, sourceID, pfuncXID)
        pushBackward(noders, pfuncXID, sourceID, INFO_DEEP)
        return
    end
    local funcXID = sformat('%s%s%s'
        , nodeID
        , RETURN_INDEX
        , returnIndex
    )
    noders.call[sourceID] = call
    pushForward(noders, sourceID, funcXID)
    pushBackward(noders, funcXID, sourceID, INFO_DEEP)
end

local specialMap = util.arrayToHash {
    'require', 'dofile', 'loadfile',
    'rawset', 'rawget', 'setmetatable',
}

local compileNodeMap
compileNodeMap = util.switch()
    : case 'string'
    : call(function (noders, id, source)
        pushForward(noders, id, 'str:')
    end)
    : case 'boolean'
    : call(function (noders, id, source)
        pushForward(noders, id, 'dn:boolean')
    end)
    : case 'number'
    : call(function (noders, id, source)
        pushForward(noders, id, 'dn:number')
    end)
    : case 'integer'
    : call(function (noders, id, source)
        pushForward(noders, id, 'dn:integer')
    end)
    : case 'nil'
    : call(function (noders, id, source)
        pushForward(noders, id, 'dn:nil')
    end)
    : case 'doc.type'
    : call(function (noders, id, source)
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                if  src.parent.type ~= 'funcargs'
                and not src.dummy then
                    pushForward(noders, getID(src), id)
                end
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
                    if  src.parent.type ~= 'funcargs'
                    and not src.dummy then
                        pushBackward(noders, unitID, getID(src))
                    end
                end
            end
        end
    end)
    : case 'doc.type.table'
    : call(function (noders, id, source)
        if source.node then
            pushForward(noders, id, getID(source.node), INFO_CLASS_TO_EXNTENDS)
        end
        if source.tkey then
            local keyID = id .. TABLE_KEY
            pushForward(noders, keyID, getID(source.tkey))
        end
        if source.tvalue then
            local valueID = id .. ANY_FIELD
            pushForward(noders, valueID, getID(source.tvalue))
        end
    end)
    : case 'doc.type.ltable'
    : call(function (noders, id, source)
        local firstField = source.fields[1]
        if not firstField then
            return
        end
        local keyID   = id .. WEAK_TABLE_KEY
        local valueID = id .. WEAK_ANY_FIELD
        pushForward(noders, keyID, 'dn:string')
        pushForward(noders, valueID, getID(firstField.extends))
        for _, field in ipairs(source.fields) do
            local fname = field.name[1]
            local extendsID
            if type(fname) == 'string' then
                extendsID = sformat('%s%s%s'
                    , id
                    , STRING_FIELD
                    , fname
                )
            else
                extendsID = sformat('%s%s%s'
                    , id
                    , SPLIT_CHAR
                    , fname
                )
            end
            pushForward(noders, extendsID, getID(field))
            pushForward(noders, extendsID, getID(field.extends))
        end
    end)
    : case 'doc.type.array'
    : call(function (noders, id, source)
        if source.node then
            local nodeID = id .. ANY_FIELD
            pushForward(noders, nodeID, getID(source.node))
        end
        local keyID = id .. TABLE_KEY
        pushForward(noders, keyID, 'dn:integer')
    end)
    : case 'doc.alias'
    : call(function (noders, id, source)
        pushForward(noders, getID(source.alias), getID(source.extends))
    end)
    : case 'doc.class'
    : call(function (noders, id, source)
        pushForward(noders, id, getID(source.class))
        pushForward(noders, getID(source.class), id)
        if source.extends then
            for _, ext in ipairs(source.extends) do
                pushForward(noders, id, getID(ext), INFO_CLASS_TO_EXNTENDS)
            end
        end
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                if  src.parent.type ~= 'funcargs'
                and src.type ~= 'setmethod'
                and not src.dummy then
                    pushForward(noders, getID(src), id)
                    pushForward(noders, id, getID(src))
                end
            end
        end
        for _, field in ipairs(source.fields) do
            local key = field.field[1]
            if key then
                local keyID
                if type(key) == 'string' then
                    keyID = sformat('%s%s%s'
                        , id
                        , STRING_FIELD
                        , key
                    )
                    local eventName = getFieldEventName(field)
                    if eventName then
                        keyID = sformat('%s%s%s'
                            , keyID
                            , EVENT_ENUM
                            , eventName
                        )
                    end
                else
                    keyID = sformat('%s%s%s'
                        , id
                        , SPLIT_CHAR
                        , key
                    )
                end
                pushForward(noders, keyID, getID(field.field))
                pushForward(noders, getID(field.field), keyID)
                pushForward(noders, keyID, getID(field.extends))
            end
        end
    end)
    : case 'doc.module'
    : call(function (noders, id, source)
        if not source.module then
            return
        end
        for _, src in ipairs(source.bindSources) do
            if guide.isSet(src) then
                local sourceID = getID(src)
                if sourceID then
                    noders.require[sourceID] = source.module
                end
            end
        end
    end)
    : case 'doc.param'
    : call(function (noders, id, source)
        pushForward(noders, id, getID(source.extends))
        for _, src in ipairs(source.bindSources) do
            if src.type == 'local' and src.parent.type == 'in' then
                pushForward(noders, getID(src), id)
            end
        end
        if source.bindSources then
            for _, src in ipairs(source.bindSources) do
                if src.type == 'function'
                or guide.isSet(src) then
                    local paramID = sformat('%s%s%s'
                        , getID(src)
                        , PARAM_NAME
                        , source.param[1]
                    )
                    pushForward(noders, paramID, id)
                end
            end
        end
    end)
    : case 'doc.vararg'
    : call(function (noders, id, source)
        pushForward(noders, getID(source), getID(source.vararg))
    end)
    : case 'doc.see'
    : call(function (noders, id, source)
        local nameID  = getID(source.name)
        local classID = sgsub(nameID, '^dsn:', 'dn:')
        pushForward(noders, nameID, classID)
        if source.field then
            local fieldID      = getID(source.field)
            local fieldClassID = sgsub(fieldID, '^dsn:', 'dn:')
            pushForward(noders, fieldID, fieldClassID)
        end
    end)
    : case 'call'
    : call(function (noders, id, source)
        if source.parent.type ~= 'select' then
            compileCallReturn(noders, source, id, 1)
        end
        compileCallParam(noders, source, id)
    end)
    : case 'select'
    : call(function (noders, id, source)
        if source.vararg.type == 'call' then
            local call = source.vararg
            compileCallReturn(noders, call, id, source.sindex)
        end
        if source.vararg.type == 'varargs' then
            pushForward(noders, id, getID(source.vararg))
        end
    end)
    : case 'doc.type.function'
    : call(function (noders, id, source)
        if source.args then
            for index, param in ipairs(source.args) do
                local paramID = sformat('%s%s%s'
                    , id
                    , PARAM_NAME
                    , param.name[1]
                )
                pushForward(noders, paramID, getID(param.extends))
                local indexID = sformat('%s%s%s'
                    , id
                    , PARAM_INDEX
                    , index
                )
                pushForward(noders, indexID, getID(param.extends))
            end
        end
        if source.returns then
            for index, rtn in ipairs(source.returns) do
                local returnID = sformat('%s%s%s'
                    , id
                    , RETURN_INDEX
                    , index
                )
                pushForward(noders, returnID, getID(rtn))
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
    end)
    : case 'doc.type.name'
    : call(function (noders, id, source)
        local uri = guide.getUri(source)
        collector.subscribe(uri, id, noders)
    end)
    : case 'doc.class.name'
    : case 'doc.alias.name'
    : call(function (noders, id, source)
        local uri = guide.getUri(source)
        collector.subscribe(uri, id, noders)

        local defID = 'def:' .. id
        collector.subscribe(uri, defID, noders)

        local defAnyID = 'def:dn:'
        collector.subscribe(uri, defAnyID, noders)
    end)
    : case 'function'
    : call(function (noders, id, source)
        local hasDocReturn
        -- 检查 luadoc
        if source.bindDocs then
            for _, doc in ipairs(source.bindDocs) do
                if doc.type == 'doc.return' then
                    hasDocReturn = true
                end
                if doc.type == 'doc.vararg' then
                    if source.args then
                        for _, param in ipairs(source.args) do
                            if param.type == '...' then
                                pushForward(noders, getID(param), getID(doc))
                            end
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
        if source.args then
            local parent = source.parent
            local parentID = guide.isSet(parent) and getID(parent)
            for i, arg in ipairs(source.args) do
                if arg[1] == 'self' then
                    goto CONTINUE
                end
                local indexID = sformat('%s%s%s'
                    , id
                    , PARAM_INDEX
                    , i
                )
                pushForward(noders, indexID, getID(arg))
                if arg.type == 'local' then
                    pushForward(noders, getID(arg), sformat('%s%s%s'
                        , id
                        , PARAM_NAME
                        , arg[1]
                    ))
                    if parentID then
                        pushForward(noders, getID(arg), sformat('%s%s%s'
                            , parentID
                            , PARAM_NAME
                            , arg[1]
                        ))
                    end
                else
                    pushForward(noders, getID(arg), sformat('%s%s%s'
                        , id
                        , PARAM_NAME
                        , '...'
                    ))
                    if parentID then
                        pushForward(noders, getID(arg), sformat('%s%s%s'
                            , parentID
                            , PARAM_NAME
                            , '...'
                        ))
                    end
                    for j = i + 1, i + 10 do
                        pushForward(noders, sformat('%s%s%s'
                            , id
                            , PARAM_INDEX
                            , j
                        ), getID(arg))
                    end
                end
                ::CONTINUE::
            end
        end
        -- 检查实体返回值
        if source.returns and not hasDocReturn then
            for _, rtn in ipairs(source.returns) do
                for index, rtnObj in ipairs(rtn) do
                    local returnID = sformat('%s%s%s'
                        , id
                        , RETURN_INDEX
                        , index
                    )
                    pushForward(noders, returnID, getID(rtnObj))
                    if config.get 'Lua.IntelliSense.traceReturn' then
                        pushBackward(noders, getID(rtnObj), returnID, INFO_DEEP_AND_DONT_CROSS)
                    end
                end
            end
        end
    end)
    : case 'table'
    : call(function (noders, id, source)
        local firstField = source[1]
        if firstField then
            if firstField.type == 'varargs' then
                local keyID   = id .. TABLE_KEY
                local valueID = id .. ANY_FIELD
                source.array = firstField
                pushForward(noders, keyID, 'dn:integer')
                pushForward(noders, valueID, getID(firstField))
            else
                local keyID   = id .. WEAK_TABLE_KEY
                local valueID = id .. WEAK_ANY_FIELD
                if firstField.type == 'tablefield' then
                    pushForward(noders, keyID, 'dn:string')
                    pushForward(noders, valueID, getID(firstField.value))
                elseif firstField.type == 'tableindex' then
                    pushForward(noders, keyID,   getID(firstField.index))
                    pushForward(noders, valueID, getID(firstField.value))
                elseif firstField.type == 'tableexp' then
                    pushForward(noders, keyID,   'dn:integer')
                    pushForward(noders, valueID, getID(firstField))
                end
            end
        end
        local parent = source.parent
        if guide.isSet(parent)  then
            pushForward(noders, id, getID(parent))
        end
    end)
    : case 'in'
    : call(function (noders, id, source)
        local keys = source.keys
        ---@type parser.guide.object[]
        local exps = source.exps
        if not keys or not exps then
            return
        end
        local node   = exps[1]
        local param1 = exps[2]
        local param2 = exps[3]
        if node.type == 'call' then
            if not param1 then
                param1 = {
                    type   = 'select',
                    dummy  = true,
                    sindex = 2,
                    start  = node.start,
                    finish = node.finish,
                    vararg = node,
                    parent = source,
                }
                compileCallReturn(noders, node, getID(param1), 2)
                if not param2 then
                    param2 = {
                        type   = 'select',
                        dummy  = true,
                        sindex = 3,
                        start  = node.start,
                        finish = node.finish,
                        vararg = node,
                        parent = source,
                    }
                    compileCallReturn(noders, node, getID(param2), 3)
                end
            end
        end
        local call = {
            type   = 'call',
            dummy  = true,
            start  = source.keyword[3],
            finish = exps[#exps].finish,
            node   = node,
            args   = { param1, param2 },
            parent = source,
        }
        for i = 1, #keys do
            compileCallReturn(noders, call, getID(keys[i]), i)
        end
    end)
    : case 'main'
    : call(function (noders, id, source)
        if source.returns then
            for _, rtn in ipairs(source.returns) do
                local rtnObj = rtn[1]
                if rtnObj then
                    pushForward(noders, 'mainreturn', getID(rtnObj), INFO_REJECT_SET)
                    pushBackward(noders, getID(rtnObj), 'mainreturn', INFO_DEEP_AND_REJECT_SET)
                end
            end
        end
    end)
    : case 'doc.return'
    : call(function (noders, id, source)
        if not source.bindSources then
            return
        end
        for _, rtn in ipairs(source.returns) do
            for _, src in ipairs(source.bindSources) do
                if src.type == 'function' then
                    local fullID = sformat('%s%s%s'
                        , getID(src)
                        , RETURN_INDEX
                        , rtn.returnIndex
                    )
                    pushForward(noders, fullID, getID(rtn))
                    for _, typeUnit in ipairs(rtn.types) do
                        pushBackward(noders, getID(typeUnit), fullID, INFO_DEEP_AND_DONT_CROSS)
                    end
                end
            end
        end
    end)
    : case 'generic.closure'
    : call(function (noders, id, source)
        for i, rtn in ipairs(source.returns) do
            local closureID = sformat('%s%s%s'
                , id
                , RETURN_INDEX
                , i
            )
            local returnID = getID(rtn)
            pushForward(noders, closureID, returnID)
        end
    end)
    : case 'generic.value'
    : call(function (noders, id, source)
        local proto    = source.proto
        local closure  = source.closure
        local upvalues = closure.upvalues
        if proto.type == 'doc.type.name' then
            local key = proto[1]
            if upvalues[key] then
                for _, paramID in ipairs(upvalues[key]) do
                    pushForward(noders, id, paramID)
                end
            end
        end
        local f = compileNodeMap[proto.type]
        if f then
            f(noders, id, source)
        end
    end)
    : getMap()

---@param noders noders
---@param source parser.guide.object
---@return parser.guide.object[]
function m.compileNode(noders, source)
    if source._noded then
        return
    end
    source._noded = true
    m.pushSource(noders, source)
    local id = getID(source)
    bindValue(noders, source, id)

    if id and specialMap[source.special] then
        noders.skip[id] = true
    end

    local f = compileNodeMap[source.type]
    if f then
        f(noders, id, source)
    end

    if id and ssub(id, 1, 2) == 'g:' then
        local uri = guide.getUri(source)
        collector.subscribe(uri, id, noders)
        if  guide.isSet(source)
        -- local t = Global --> t: g:.Global
        and source.type ~= 'local'
        and source.type ~= 'setlocal' then

            local defID = 'def:' .. id
            collector.subscribe(uri, defID, noders)

            local fieldID = m.getLastID(id)
            if fieldID then
                local defNodeID = 'field:' .. fieldID
                collector.subscribe(uri, defNodeID, noders)
            end

            if guide.isGlobal(source) then
                local defAnyID = 'def:g:'
                collector.subscribe(uri, defAnyID, noders)
            end
        end
    end
end

---根据ID来获取第一个节点的ID
---@param id string
---@return string
function m.getFirstID(id)
    local firstID, count = smatch(id, FIRST_REGEX)
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
    local headID, count = smatch(id, HEAD_REGEX)
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
    local lastID, count = sgsub(id, LAST_REGEX, '')
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
    local _, count = sgsub(id, SPLIT_CHAR, SPLIT_CHAR)
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
    local nextChar = ssub(id, #firstID + 1, #firstID + 1)
    if nextChar ~= SPLIT_CHAR then
        return false
    end
    local next2Char = ssub(id, #firstID + 2, #firstID + 2)
    if next2Char == RETURN_INDEX
    or next2Char == PARAM_NAME then
        return false
    end
    return true
end

---把形如 `@file:\\\XXXXX@gv:1|1`拆分成uri与id
---@param id string
---@return uri? string
---@return string id
function m.getUriAndID(id)
    local uri, newID = smatch(id, URI_REGEX)
    return uri, newID
end

---是否是普通的field，例如数字或字符串，而不是函数返回值等
---@param field any
function m.isCommonField(field)
    if not field then
        return false
    end
    if ssub(field, 1, #RETURN_INDEX) == RETURN_INDEX then
        return false
    end
    if ssub(field, 1, #PARAM_NAME) == PARAM_NAME then
        return false
    end
    return true
end

---是否是普通的field，例如数字或字符串，而不是函数返回值等
function m.hasCall(field)
    if not field then
        return false
    end
    if sfind(field, RETURN_INDEX, 1, true) then
        return true
    end
    return false
end

function m.isGlobalID(id)
    return ssub(id, 1, 2) == 'g:'
        or ssub(id, 1, 3) == 'dn:'
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
---@param noders noders
---@param id string
function m.removeID(noders, id)
    if not id then
        return
    end
    for _, t in next, noders do
        t[id] = nil
    end
end

---寻找doc的主体
---@param doc parser.guide.object
function m.getDocState(doc)
    return getDocStateWithoutCrossFunction(doc)
end

---@param noders noders
---@return fun():node.id
function m.eachID(noders)
    return next, noders.source
end

m.getFieldEventName = getFieldEventName

---获取对象的noders
---@param source parser.guide.object
---@return noders
function m.getNoders(source)
    local root = guide.getRoot(source)
    if not root._noders then
        ---@type noders
        root._noders = {
            source    = {},
            sources   = {},
            forward   = {},
            finfo     = {},
            forwards  = {},
            backward  = {},
            binfo     = {},
            backwards = {},
            call      = {},
            require   = {},
            skip      = {},
        }
    end
    return root._noders
end

---获取对象的noders
---@param uri uri
---@return noders
function m.getNodersByUri(uri)
    local state = files.getState(uri)
    if not state then
        return nil
    end
    return m.getNoders(state.ast)
end

---编译整个文件的node
---@param  source parser.guide.object
---@return table
function m.compileAllNodes(source)
    local root = guide.getRoot(source)
    local noders = m.getNoders(source)
    if root._initedNoders then
        return noders
    end
    root._initedNoders = true
    if not root._compiledGlobals then
        collector.dropUri(guide.getUri(root))
    end
    root._compiledGlobals = true
    --log.debug('compileNodes:', guide.getUri(root))
    guide.eachSource(root, function (src)
        m.compileNode(noders, src)
    end)
    --log.debug('compileNodes finish:', guide.getUri(root))
    return noders
end

local partNodersMap = util.switch()
    : case 'local'
    : call(function (noders, source)
        local refs = source.ref
        if refs then
            for i = 1, #refs do
                local ref = refs[i]
                m.compilePartNodes(noders, ref)
            end
        end
    end)
    : case 'setlocal'
    : case 'getlocal'
    : call(function (noders, source)
        m.compilePartNodes(noders, source.node)

        local nxt = source.next
        if nxt then
            m.compilePartNodes(noders, nxt)
        end

        local parent = source.parent
        if parent.value == source then
            m.compilePartNodes(noders, parent)
        end

        if parent.type == 'call' then
            local node = parent.node
            if node.special == 'rawset'
            or node.special == 'rawget' then
                m.compilePartNodes(noders, parent)
            end
        end
    end)
    : case 'setfield'
    : case 'getfield'
    : case 'setmethod'
    : case 'getmethod'
    : call(function (noders, source)
        local node = source.node
        m.compilePartNodes(noders, node)

        local nxt = source.next
        if nxt then
            m.compilePartNodes(noders, nxt)
        end

        local parent = source.parent
        if parent.value == source then
            m.compilePartNodes(noders, parent)
        end
    end)
    : case 'setglobal'
    : case 'getglobal'
    : call(function (noders, source)
        local nxt = source.next
        if nxt then
            m.compilePartNodes(noders, nxt)
        end

        local parent = source.parent
        if parent.value == source then
            m.compilePartNodes(noders, parent)
        end

        if parent.type == 'call' then
            local node = parent.node
            if node.special == 'rawset'
            or node.special == 'rawget' then
                m.compilePartNodes(noders, parent)
            end
        end
    end)
    : case 'label'
    : call(function (noders, source)
        local refs = source.ref
        if not refs then
            return
        end
        for i = 1, #refs do
            local ref = refs[i]
            m.compilePartNodes(noders, ref)
        end
    end)
    : case 'goto'
    : call(function (noders, source)
        m.compilePartNodes(noders, source.node)
    end)
    : case 'table'
    : call(function (noders, source)
        for i = 1, #source do
            local field = source[i]
            m.compilePartNodes(noders, field)
        end
    end)
    : case 'tablefield'
    : case 'tableindex'
    : call(function (noders, source)
        m.compilePartNodes(noders, source.parent)
    end)
    : getMap()

---编译Class的node
---@param noders noders
---@param  source parser.guide.object
---@return table
function m.compilePartNodes(noders, source)
    if not source then
        return
    end
    if source._noded then
        return
    end
    m.compileNode(noders, source)
    local f = partNodersMap[source.type]
    if f then
        f(noders, source)
    end
end

---编译全局变量的node
---@param  root parser.guide.object
---@return table
function m.compileGlobalNodes(root)
    if root._initedNoders then
        return
    end
    if not root._compiledGlobals then
        collector.dropUri(guide.getUri(root))
    end
    root._compiledGlobals = true
    local noders = m.getNoders(root)
    local env = guide.getENV(root)

    m.compilePartNodes(noders, env)

    local docs = root.docs
    guide.eachSourceTypes(docs, {
        'doc.class.name',
        'doc.alias.name',
        'doc.type.name',
    }, function (doc)
        m.compileNode(noders, doc)
    end)
end

files.watch(function (ev, uri)
    if ev == 'update' then
        local state = files.getState(uri)
        if state then
            --m.compileAllNodes(state.ast)
            m.compileGlobalNodes(state.ast)
        end
    end
    if ev == 'remove' then
        collector.dropUri(uri)
    end
end)

return m
