TEST [[
---@alias <!A!> integer
---@alias <!A!> integer
]]

TEST [[
---@class A
---@class B
---@alias <!A!> B
]]

TEST [[
---@alias A integer
---@alias(merge) A integer

---@enum B
---@enum(merge) B

---@enum(key) C
---@enum(key, merge) C
]]
