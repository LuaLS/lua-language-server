TEST [[
---@type number
local a
if <!a!> then end

---@type number
local b
if <!not b!> then end

---@type number
local c
local x = <!c!> or "3"

---@type false
local d
local y = <!d!> and "4"

---@type boolean
local e
if e then end

---@type boolean|nil
local g
if <!g!> then end

---@type number
local h
if <!h!> and true then end

---@type any
local f
local z = f or "3"
]]
