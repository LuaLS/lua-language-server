-- check global functions
TEST [[
local mod = {}

local <!function fl0()
end!>
  
---comment
local function fl1()
end
  
local function fl2()
end
  
function FG0()
end
  
mod.fl0 = fl0
mod.fl1 = fl1
return mod
]]

TEST [[
local mod = {}
  
local function flp0(<!p!>)
  print(p)
end

---comment
local function flp1(<!p!>)
  print(p)
end

---comment
---@param p any
local function flp2(p)
  print(p)
end

mod.flp0 = flp0
mod.flp1 = flp1
return mod
]]

TEST [[
local mod = {}

local function flpp0(<!p0!>, <!p1!>)
  print(p0, p1)
end

---comment
local function flpp1(<!p0!>, <!p1!>)
  print(p0, p1)
end

---comment
---@param p0 any
local function flpp2(p0, <!p1!>)
  print(p0, p1)
end

---comment
---@param p0 any
---@param p1 any
local function flpp3(p0, p1)
  print(p0, p1)
end

mod.flpp0 = flpp0
mod.flpp1 = flpp1
mod.flpp2 = flpp2
mod.flpp3 = flpp3
return mod
]]

TEST [[
local mod = {}

local function flr0()
  return <!0!>
end

---comment
local function flr1()
  return <!0!>
end

---comment
---@return integer
local function flr2()
  return 0
end

mod.flr0 = flr0
mod.flr1 = flr1
mod.flr2 = flr2
return mod
]]

TEST [[
local mod = {}

local function flrr0()
  return <!0!>, <!1!>
end

---comment
local function flrr1()
  return <!0!>, <!1!>
end

---comment
---@return integer
local function flrr2()
  return 0, <!1!>
end

---comment
---@return integer
---@return integer
local function flrr3()
  return 0, 1
end

mod.flrr0 = flrr0
mod.flrr1 = flrr1
mod.flrr2 = flrr2
return mod
]]

TEST [[
local mod = {}

local function flpr0(<!p!>)
  print(p)
  return <!0!>
end

---comment
local function flpr1(<!p!>)
  print(p)
  return <!0!>
end

---comment
---@param p any
local function flpr2(p)
  print(p)
  return <!0!>
end

---comment
---@return integer
local function flpr3(<!p!>)
  print(p)
  return 0
end

---comment
---@param p any
---@return integer
local function flpr4(p)
  print(p)
  return 0
end

mod.flpr0 = flpr0
mod.flpr1 = flpr1
mod.flpr2 = flpr2
mod.flpr3 = flpr3
mod.flpr4 = flpr4
return mod
]]
