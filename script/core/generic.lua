---@class generic.value
---@field type string
---@field closure generic.closure
---@field proto parser.guide.object

---@class generic.closure
---@field type string
---@field proto parser.guide.object
---@field upvalues table<string, generic.value[]>
---@field params generic.value[]
---@field returns generic.value[]

local m = {}

local function instantValue(closure, proto)
    ---@type generic.value
    local value = {
        type    = 'generic.value',
        closure = closure,
        proto   = proto,
    }
    return value
end

---递归实例化对象
---@param obj parser.guide.object
---@return generic.value
local function createValue(closure, obj)
    if obj.type == 'doc.type' then
        local types = {}
        local hasGeneric
        for i, tp in ipairs(obj.types) do
            local genericValue = createValue(tp)
            if genericValue then
                hasGeneric = true
                types[i] = genericValue
            else
                types[i] = tp
            end
        end
        if hasGeneric then
            local value = instantValue(closure, obj)
            value.types = types
            return value
        else
            return nil
        end
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
        parent   = parentClosure,
        proto    = protoFunction,
        call     = call,
        upvalues = parentClosure and parentClosure.upvalues or {},
        params   = {},
        returns  = {},
    }

    -- 立刻解决所有的泛型
    -- 对每个参数进行核对，存入泛型表
    -- 为所有的 param 与 return 创建副本
    -- 如果return中有function，也要递归创建闭包
    if protoFunction.type == 'function' then
        for _, doc in ipairs(protoFunction.bindDocs) do
            if doc.type == 'doc.param' then
                local extends = doc.extends
                closure.params[extends.paramIndex] = createValue(closure, extends)
            elseif doc.type == 'doc.return' then
                for _, rtn in ipairs(doc.returns) do
                    closure.returns[rtn.returnIndex] = createValue(closure, rtn)
                end
            end
        end
    end
    if protoFunction.type == 'doc.function' then
        
    end

    return closure
end

return m
