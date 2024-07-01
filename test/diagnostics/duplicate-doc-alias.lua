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
---@alias(partial) A integer

---@enum B
---@enum(partial) B

---@enum(key) C
---@enum(key, partial) C
]]
