local util    = require 'utility'
local guide   = require 'parser.guide'

local LastIDCache    = {}
local FirstIDCache   = {}
local SPLIT_CHAR     = '\x1F'
local LAST_REGEX     = SPLIT_CHAR .. '[^' .. SPLIT_CHAR .. ']*$'
local FIRST_REGEX    = '^[^' .. SPLIT_CHAR .. ']*'
local ANY_FIELD_CHAR = '*'
local RETURN_INDEX   = SPLIT_CHAR .. '#'
local PARAM_INDEX    = SPLIT_CHAR .. '&'
local TABLE_KEY      = SPLIT_CHAR .. '<'
local ANY_FIELD      = SPLIT_CHAR .. ANY_FIELD_CHAR
local URI_CHAR       = '@'
local URI_REGEX      = URI_CHAR .. '([^' .. URI_CHAR .. ']*)' .. URI_CHAR .. '(.*)'

---@class node
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
            return ANY_FIELD_CHAR, source.node
        end
        if index.type == 'string'
        or index.type == 'boolean'
        or index.type == 'number' then
            return ('%q'):format(index[1] or ''), source.node
        elseif index.type ~= 'function'
        and    index.type ~= 'table' then
            return ANY_FIELD_CHAR, source.node
        end
    elseif source.type == 'tableindex' then
        local index = source.index
        if not index then
            return ANY_FIELD_CHAR, source.parent
        end
        if index.type == 'string'
        or index.type == 'boolean'
        or index.type == 'number' then
            return ('%q'):format(index[1] or ''), source.parent
        elseif index.type ~= 'function'
        and    index.type ~= 'table' then
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
    elseif source.type == 'varargs' then
        if source.node then
            return source.node.start, nil
        end
    elseif source.type == 'select' then
        return ('%d%s%d'):format(source.start, RETURN_INDEX, source.sindex)
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
        return source.finish, nil
    elseif source.type == 'doc.class.name'
    or     source.type == 'doc.alias.name'
    or     source.type == 'doc.extends.name'
    or     source.type == 'doc.see.name' then
        local name = source[1]
        return name, nil
    elseif source.type == 'doc.type.name' then
        local name = source[1]
        if source.typeGeneric then
            return source.typeGeneric[name][1].start, nil
        else
            return name, nil
        end
    elseif source.type == 'doc.class'
    or     source.type == 'doc.type'
    or     source.type == 'doc.param'
    or     source.type == 'doc.vararg'
    or     source.type == 'doc.field.name'
    or     source.type == 'doc.type.enum'
    or     source.type == 'doc.resume'
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
        return 'i:'
    end
    if source.type == 'call' then
        return 'c:'
    end
    if source.type == '...'
    or source.type == 'varargs' then
        return 'va:'
    end
    if source.type == 'doc.class.name'
    or source.type == 'doc.type.name'
    or source.type == 'doc.alias.name'
    or source.type == 'doc.extends.name' then
        if source.typeGeneric then
            return 'dg:'
        end
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
    if source.type == 'doc.type.enum'
    or source.type == 'doc.resume' then
        return 'de:'
    end
    if source.type == 'generic.closure' then
        return 'gc:'
    end
    if source.type == 'generic.value' then
        local id = 'gv:'
        if guide.getUri(source.closure.call) ~= guide.getUri(source.proto) then
            id = id .. URI_CHAR .. guide.getUri(source.closure.call)
        end
        return id
    end
    if guide.isGlobal(source) then
        return 'g:'
    end
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        source = source.node
    end
    if source.parent.type == 'funcargs' then
        return 'p:'
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
            for i = index, 2, -1 do
                if IDList[i] == '"_G"' then
                    IDList[i] = nil
                end
            end
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
        node.forward = {}
    end
    if node.forward[forwardID] ~= nil then
        return
    end
    node.forward[forwardID] = tag or false
    node.forward[#node.forward+1] = forwardID
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
        node.backward = {}
    end
    if node.backward[backwardID] ~= nil then
        return
    end
    node.backward[backwardID] = tag or false
    node.backward[#node.backward+1] = backwardID
end

local m = {}

m.SPLIT_CHAR   = SPLIT_CHAR
m.RETURN_INDEX = RETURN_INDEX
m.PARAM_INDEX  = PARAM_INDEX
m.TABLE_KEY    = TABLE_KEY
m.ANY_FIELD    = ANY_FIELD
m.URI_CHAR     = URI_CHAR

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
function m.pushSource(noders, source)
    local id = m.getID(source)
    if not id then
        return
    end
    local node = getNode(noders, id)
    if not node.sources then
        node.sources = {}
    end
    node.sources[#node.sources+1] = source
end

---@param noders noders
---@param source parser.guide.object
---@return parser.guide.object[]
function m.compileNode(noders, source)
    local id = getID(source)
    local value = source.value
    if value then
        local valueID = getID(value)
        if valueID then
            -- x = y : x -> y
            pushForward(noders, id, valueID, 'set')
            -- 参数禁止反向查找赋值
            if valueID:sub(1, 2) ~= 'p:' then
                pushBackward(noders, valueID, id, 'set')
            end
        end
    end
    -- self -> mt:xx
    if source.type == 'local' and source[1] == 'self' then
        local func = guide.getParentFunction(source)
        if func.isGeneric then
            return
        end
        local setmethod = func.parent
        -- guess `self`
        if setmethod and ( setmethod.type == 'setmethod'
                        or setmethod.type == 'setfield'
                        or setmethod.type == 'setindex') then
            pushForward(noders, id, getID(setmethod.node), 'method')
            pushBackward(noders, getID(setmethod.node), id, 'method')
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
        local node = source.node
        local nodeID = getID(node)
        if not nodeID then
            return
        end
        getNode(noders, id).call = source
        -- 将 call 映射到 node#1 上
        local callID = ('%s%s%s'):format(
            nodeID,
            RETURN_INDEX,
            1
        )
        pushForward(noders, id, callID)
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
            pushForward(noders, id, callID)
            pushBackward(noders, callID, id)
            pushForward(noders, callID, tblID)
            pushForward(noders, callID, indexID)
            pushBackward(noders, tblID, callID)
            --pushBackward(noders, indexID, callID)
        end
        if node.special == 'require' then
            local arg1 = source.args and source.args[1]
            if arg1 and arg1.type == 'string' then
                getNode(noders, callID).require = arg1[1]
            end
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
                source.sindex
            )
            pushForward(noders, id, callXID)
            pushBackward(noders, callXID, id)
            getNode(noders, id).call = call
            if node.special == 'pcall'
            or node.special == 'xpcall' then
                local index = source.sindex - 1
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
                pushForward(noders, id, funcXID)
                pushBackward(noders, funcXID, id)
            end
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
                    if rtnObj.type == 'function'
                    or rtnObj.type == 'call' then
                        pushBackward(noders, getID(rtnObj), returnID)
                    end
                end
            end
        end
    end
    if source.type == 'table' then
        if #source == 1 and source[1].type == 'varargs' then
            source.array = source[1]
            local nodeID = ('%s%s'):format(
                id,
                ANY_FIELD
            )
            pushForward(noders, nodeID, getID(source[1]))
        end
    end
    if source.type == 'main' then
        if source.returns then
            for _, rtn in ipairs(source.returns) do
                local rtnObj = rtn[1]
                if rtnObj then
                    pushForward(noders, 'mainreturn', getID(rtnObj))
                    pushBackward(noders, getID(rtnObj), 'mainreturn')
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

---测试id是否包含field，如果遇到函数调用则中断
---@param id string
---@return boolean
function m.hasField(id)
    local firstID = m.getFirstID(id)
    if firstID == id then
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
    guide.eachSource(root, function (src)
        m.pushSource(noders, src)
        m.compileNode(noders, src)
    end)
    -- Special rule: ('').XX -> stringlib.XX
    pushBackward(noders, 'str:', 'dn:stringlib')
    pushBackward(noders, 'dn:string', 'dn:stringlib')
    log.debug('compileNodes finish:', guide.getUri(root))
    return noders
end

return m
