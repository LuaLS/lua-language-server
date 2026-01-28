TEST [[
---@type number
local a
if <!a!> then end

---@type number
local b
if <!b!> then end

---@type boolean
local e
if e then end

---@type true
local t
if t then end

---@type boolean|nil
local g
if <!g!> then end

---@type number
local h
if <!h!> and true then end

---@type number
local i
if true and <!i!> then end
]]
