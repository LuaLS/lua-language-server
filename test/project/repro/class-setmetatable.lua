-- 目标工程 `test/diagnostics/assign-type-mismatch.lua` 里的「类 + setmetatable」期望（master 测试基线）：
--   B1/B2 无诊断；B3 报 assign-type-mismatch；MyClass:new 里的 myObject.initialField 无诊断

---@class reproA1
local a1 = {}

---@class reproB1: reproA1
local b1 = setmetatable({}, a1)

---@class reproA2
local a2 = {}

---@class reproB2: reproA2
local b2 = setmetatable({}, { __index = a2 })

---@class reproA3
local a3 = {}

---@class reproB3
--- B3 与 A3 无继承关系，`__index` 的类接不上 B3 ⇒ 这里**应当**报 assign-type-mismatch
---@diagnostic disable-next-line: assign-type-mismatch
local b3 = setmetatable({}, { __index = a3 })

---@class reproMyClass
local MyClass = {}

function MyClass:new()
    ---@class reproMyClass
    local myObject = setmetatable({
        initialField = true,
    }, self)

    print(myObject.initialField)
end

return b1, b2, b3, MyClass
