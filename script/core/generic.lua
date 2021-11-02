local guide = require 'parser.guide'
local noder = require "core.noder"

---@class generic.value: parser.guide.object
---@field type string
---@field closure generic.closure
---@field proto parser.guide.object
---@field parent parser.guide.object

---@class generic.closure: parser.guide.object
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
    road = road or {}
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
        value.enums = proto.enums
        value.resumes = proto.resumes
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
        road[#road+1] = noder.WEAK_ANY_FIELD
        local node = createValue(closure, proto.node, callback, road)
        road[#road] = nil
        if not node then
            return nil
        end
        local value = instantValue(closure, proto)
        value.node = node
        noder.compileNode(noder.getNoders(proto), value)
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
        noder.compileNode(noder.getNoders(proto), value)
        return value
    end
    if proto.type == 'doc.type.ltable' then
        local fields = {}
        for i, field in ipairs(proto.fields) do
            fields[i] = createValue(closure, field, callback, road) or field
        end
        if #fields == 0 then
            return nil
        end
        local value = instantValue(closure, proto)
        value.fields = fields
        noder.compileNode(noder.getNoders(proto), value)
        return value
    end
    if proto.type == 'doc.type.field' then
        local name = proto.name[1]
        if type(name) == 'string' then
            road[#road+1] = ('%s%s'):format(
                noder.STRING_FIELD,
                name
            )
        else
            road[#road+1] = ('%s%s'):format(
                noder.SPLIT_CHAR,
                name
            )
        end
        local typeUnit = createValue(closure, proto.extends, callback, road)
        road[#road] = nil
        if not typeUnit then
            return nil
        end
        local value = instantValue(closure, proto)
        value.name = proto.name
        value.extends = typeUnit
        noder.compileNode(noder.getNoders(proto), value)
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
    local args          = protoFunction.args
    local paramMap      = {}
    if params then
        for i, param in ipairs(params) do
            local arg = args and args[i]
            if arg then
                if arg.type == 'local' then
                    paramMap[arg[1]] = param
                elseif arg.type == 'doc.type.arg' then
                    paramMap[arg.name[1]] = param
                end
            end
        end
    end

    if protoFunction.type == 'function' then
        for _, doc in ipairs(protoFunction.bindDocs) do
            if doc.type == 'doc.param' then
                local name    = doc.param[1]
                local extends = doc.extends
                if name and extends then
                    local param = paramMap[name]
                    closure.params[name] = param and createValue(closure, extends, function (road, key, proto)
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
            local name    = arg.name[1]
            local extends = arg.extends
            local param   = paramMap[name]
            closure.params[name] = param and createValue(closure, extends, function (road, key, proto)
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
