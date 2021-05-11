local util = require 'utility'

local counter = util.counter()

---@class generic.value
---@field type string
---@field closure generic.closure
---@field types parser.guide.object[]|generic.value[]

---递归实例化对象
---@param obj parser.guide.object
---@param callback fun(docName: parser.guide.object)
local function instantValue(obj, callback)
end

---@class generic.closure
---@field type string
---@field proto parser.guide.object
---@field upvalues table<string, generic.value[]>
---@field params generic.value[]
---@field returns generic.value[]

local m = {}

---给闭包设置调用信息
---@param closure generic.closure
---@param params parser.guide.object[]
function m.setCallParams(closure, params)
    -- 立刻解决所有的泛型
    -- 对每个参数进行核对，存入泛型表
    -- 为所有的 param 与 return 创建副本
    -- 如果return中有function，也要递归创建闭包
end

---创建一个闭包
---@param protoFunction parser.guide.object # 原型函数
---@param parentClosure? generic.closure
---@return generic.closure
function m.createClosure(protoFunction, parentClosure)
    ---@type generic.closure
    local closure = {
        type     = 'generic.closure',
        id       = counter(),
        proto    = protoFunction,
        upvalues = {},
        params   = {},
        returns  = {},
    }
    return closure
end

return m
