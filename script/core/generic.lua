local linker = require "core.linker"
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
    return value
end

---递归实例化对象
---@param obj parser.guide.object
---@return generic.value
local function createValue(closure, obj, callback, road)
    if callback then
        road = road or {}
    end
    if obj.type == 'doc.type' then
        local types = {}
        local hasGeneric
        for i, tp in ipairs(obj.types) do
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
        local value = instantValue(closure, obj)
        value.types = types
        linker.compileLink(value)
        return value
    end
    if obj.type == 'doc.type.name' then
        if not obj.typeGeneric then
            return nil
        end
        local key = obj[1]
        local value = instantValue(closure, obj)
        if callback then
            callback(road, key, obj)
        end
        linker.compileLink(value)
        return value
    end
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
                closure.params[index] = createValue(closure, extends, function (road, key, proto)
                    local param = params[index]
                    if not param then
                        return
                    end
                    local paramID
                    if proto.literal then
                        local str = param.type == 'string' and param[1]
                        if not str then
                            return
                        end
                        paramID = 'dn:' .. str
                    else
                        paramID = linker.getID(param)
                    end
                    if not paramID then
                        return
                    end
                    if not upvalues[key] then
                        upvalues[key] = {}
                    end
                    -- TODO
                    upvalues[key][#upvalues[key]+1] = paramID
                end)
            end
        end
        for _, doc in ipairs(protoFunction.bindDocs) do
            if doc.type == 'doc.return' then
                for _, rtn in ipairs(doc.returns) do
                    closure.returns[rtn.returnIndex] = createValue(closure, rtn)
                end
            end
        end
    end
    if protoFunction.type == 'doc.function' then
        
    end
end

---创建一个闭包
---@param protoFunction parser.guide.object # 原型函数
---@param parentClosure? generic.closure
---@return generic.closure
function m.createClosure(protoFunction, call, parentClosure)
    ---@type generic.closure
    local closure = {
        type     = 'generic.closure',
        parent   = protoFunction.parent,
        proto    = protoFunction,
        call     = call,
        upvalues = parentClosure and parentClosure.upvalues or {},
        params   = {},
        returns  = {},
    }
    buildValues(closure)

    if #closure.returns == 0 then
        return nil
    end

    linker.compileLink(closure)

    return closure
end

return m
