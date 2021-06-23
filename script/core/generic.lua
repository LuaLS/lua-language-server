local guide = require 'parser.guide'
local noder = require "core.noder"

---@class generic.value
---@field type string
---@field closure generic.closure
---@field proto parser.guide.object
---@field parent parser.guide.object

---@class generic.closure
---@field type string
---@field proto parser.guide.object
---@field upvalues table<string, generic.value[]>
---@field params generic.value[]
---@field returns generic.value[]

local m = {}

---@param closure generic.closure
---@param proto parser.guide.object
local function instantValue(closure, proto)
    ---@type generic.value
    local value = {
        type    = 'generic.value',
        closure = closure,
        proto   = proto,
        parent  = proto.parent,
    }
    closure.values[#closure.values+1] = value
    return value
end

---递归实例化对象
---@param proto parser.guide.object
---@return generic.value
local function createValue(closure, proto, callback, road)
    if callback then
        road = road or {}
    end
    if proto.type == 'doc.type' then
        local types = {}
        local hasGeneric
        for i, tp in ipairs(proto.types) do
            local genericValue = createValue(closure, tp, callback, road)
            if genericValue then
                hasGeneric = true
                types[i] = genericValue
            else
                types[i] = tp
            end
        end
        if not hasGeneric then
            return nil
        end
        local value = instantValue(closure, proto)
        value.types = types
        noder.compileNode(noder.getNoders(proto), value)
        return value
    end
    if proto.type == 'doc.type.name' then
        if not proto.typeGeneric then
            return nil
        end
        local key = proto[1]
        local value = instantValue(closure, proto)
        if callback then
            callback(road, key, proto)
        end
        noder.compileNode(noder.getNoders(proto), value)
        return value
    end
    if proto.type == 'doc.type.function' then
        local hasGeneric
        local args = {}
        local returns = {}
        for i, arg in ipairs(proto.args) do
            local value = createValue(closure, arg, callback, road)
            if value then
                hasGeneric = true
            end
            args[i] = value or arg
        end
        for i, rtn in ipairs(proto.returns) do
            local value = createValue(closure, rtn, callback, road)
            if value then
                hasGeneric = true
            end
            returns[i] = value or rtn
        end
        if not hasGeneric then
            return nil
        end
        local value = instantValue(closure, proto)
        value.args = args
        value.returns = returns
        value.isGeneric = true
        noder.pushSource(noder.getNoders(proto), value)
        return value
    end
    if proto.type == 'doc.type.array' then
        if road then
            road[#road+1] = noder.WEAK_ANY_FIELD
        end
        local node = createValue(closure, proto.node, callback, road)
        if road then
            road[#road] = nil
        end
        if not node then
            return nil
        end
        local value = instantValue(closure, proto)
        value.node = node
        return value
    end
    if proto.type == 'doc.type.table' then
        road[#road+1] = noder.WEAK_TABLE_KEY
        local tkey = createValue(closure, proto.tkey, callback, road)
        road[#road] = nil

        road[#road+1] = noder.WEAK_ANY_FIELD
        local tvalue = createValue(closure, proto.tvalue, callback, road)
        road[#road] = nil

        if not tkey and not tvalue then
            return nil
        end
        local value = instantValue(closure, proto)
        value.tkey   = tkey   or proto.tkey
        value.tvalue = tvalue or proto.tvalue
        return value
    end
end

local function buildValue(road, key, proto, param, upvalues)
    local paramID
    if proto.literal then
        local str = param.type == 'string' and param[1]
        if not str then
            return
        end
        paramID = 'dn:' .. str
    else
        paramID = noder.getID(param)
    end
    if not paramID then
        return
    end
    local myUri = guide.getUri(param)
    local myHead = noder.URI_CHAR .. myUri .. noder.URI_CHAR
    paramID = myHead .. paramID
    if not upvalues[key] then
        upvalues[key] = {}
    end
    upvalues[key][#upvalues[key]+1] = paramID .. table.concat(road)
end

-- 为所有的 param 与 return 创建副本
---@param closure generic.closure
local function buildValues(closure)
    local protoFunction = closure.proto
    local upvalues      = closure.upvalues
    local params        = closure.call.args

    if protoFunction.type == 'function' then
        for _, doc in ipairs(protoFunction.bindDocs) do
            if doc.type == 'doc.param' then
                local extends = doc.extends
                local index   = extends.paramIndex
                if index then
                    local param   = params and params[index]
                    closure.params[index] = param and createValue(closure, extends, function (road, key, proto)
                        buildValue(road, key, proto, param, upvalues)
                    end) or extends
                end
            end
        end
        for _, doc in ipairs(protoFunction.bindDocs) do
            if doc.type == 'doc.return' then
                for _, rtn in ipairs(doc.returns) do
                    closure.returns[rtn.returnIndex] = createValue(closure, rtn) or rtn
                end
            end
        end
    end
    if protoFunction.type == 'doc.type.function' then
        for index, arg in ipairs(protoFunction.args) do
            local extends = arg.extends
            local param   = params and params[index]
            closure.params[index] = param and createValue(closure, extends, function (road, key, proto)
                buildValue(road, key, proto, param, upvalues)
            end) or extends
        end
        for index, rtn in ipairs(protoFunction.returns) do
            closure.returns[index] = createValue(closure, rtn) or rtn
        end
    end
end

---创建一个闭包
---@param proto parser.guide.object|generic.value # 原型函数|泛型值
---@return generic.closure
function m.createClosure(proto, call)
    local protoFunction, parentClosure
    if proto.type == 'function' then
        protoFunction = proto
    elseif proto.type == 'doc.type.function' then
        protoFunction = proto
    elseif proto.type == 'generic.value' then
        protoFunction = proto.proto
        parentClosure = proto.closure
    end
    ---@type generic.closure
    local closure = {
        type     = 'generic.closure',
        parent   = protoFunction.parent,
        proto    = protoFunction,
        call     = call,
        upvalues = parentClosure and parentClosure.upvalues or {},
        params   = {},
        returns  = {},
        values   = {},
    }
    buildValues(closure)

    if #closure.returns == 0 then
        return nil
    end

    noder.compileNode(noder.getNoders(proto), closure)

    return closure
end

return m
