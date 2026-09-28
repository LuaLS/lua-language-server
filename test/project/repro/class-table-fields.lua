-- `---@class X` + 多次声明/多次绑定字面量（含经 `setmetatable` 的装配写法）：
-- 绑定值推断出来的字段只算「读取可见性」，不是赋值要求 —— 既不该报未定义字段，
-- 也不该把「缺了另一次绑定的字段」算成赋值不匹配。
-- 同族 = 目标工程 `script/plugins/ffi/init.lua` 的 85 / 88 / 340 / 348

---@class repro.builder
local builder = { switch_ast = 1 }

function builder:getAsts()
    print(self.globalAsts)
end

---@param codes string
local function compile(codes)
    ---@class repro.builder
    local b = setmetatable({ globalAsts = {}, cacheEnums = {} }, { __index = builder })
    print(b.globalAsts)
    print(b.cacheEnums)
end

---@class repro.D1
local d1 = { a = 1 }

---@class repro.D1
local d2 = { b = 2 }

return compile, builder, d1, d2
