TEST [[
---@type <!A!>
]]

TEST [[
---@class A
---@type A|<!B!>|<!C!>
]]

TEST [[
---@class AAA
---@alias B AAA

---@type B
]]

TEST [[
---@alias B <!AAA!>
]]
