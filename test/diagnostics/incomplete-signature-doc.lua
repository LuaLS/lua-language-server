-- -------------------------------------
-- about the structure of these test cases
--
-- the following test cases are grouped by the number of parameters and return values of the functions
-- so first global functions with: 
-- no parameter and return value (FG), one parameter (FGP), two parameters (FGPP),
-- one return value (FGR), two return values (FGRR) and parameter and return value (FGPR)
-- after that, these groups are also done for local functions (FL, FLP, ...)
--
-- in these groups, different versions of documentation are tested:
-- no comment, simple comment, @async annotation (which is no signature doc),
-- incomplete signature doc (only part of the necessary @param or @return annotations, if possible) - the only cases that should generating warnings
-- and complete signature docs (all necessary @param and @return annotations)
-- -------------------------------------

-- global functions no parameter, no return value
-- no incomplete signature docs possible

TEST [[
function FG0()
end

---comment
function FG1()
end

---@async
function FG1_()
end
]]

-- global functions with single parameter, no return value
-- no incomplete signature docs possible
TEST [[
function FGP0(p)
  print(p)
end

---comment
function FGP1(p)
  print(p)
end

---@async
function FGP1_(p)
  print(p)
end

---comment
---@param p any
function FGP2(p)
  print(p)
end
]]

-- global functions with two parameters, no return value
-- incomplete signature docs when exactly one of the parameters is documented
TEST [[
function FGPP0(p0, p1)
  print(p0, p1)
end

---comment
function FGPP1(p0, p1)
  print(p0, p1)
end

---@async
function FGPP1_(p0, p1)
  print(p0, p1)
end

---comment
---@param p0 any
function FGPP2(p0, <!p1!>)
  print(p0, p1)
end

---comment
---@param p1 any
function FGPP2_(<!p0!>, p1)
  print(p0, p1)
end

---comment
---@param p0 any
---@param p1 any
function FGPP3(p0, p1)
  print(p0, p1)
end
]]

-- global functions with no parameter, single return value
-- no incomplete signature docs possible
TEST [[
function FGR0()
  return 0
end

---comment
function FGR1()
  return 0
end

---@async
function FGR1_()
  return 0
end

---comment
---@return integer
function FGR2()
  return 0
end
]]

-- global functions with no parameter, two return values
-- incomplete signature docs when exactly one of the return values is documented
TEST [[
function FGRR0()
  return 0, 1
end

---comment
function FGRR1()
  return 0, 1
end

---@async
function FGRR1_()
  return 0, 1
end

---comment
---@return integer
function FGRR2()
  return 0, <!1!>
end

---comment
---@return integer
---@return integer
function FGRR3()
  return 0, 1
end
]]

-- global functions with one parameter, one return value
-- incomplete signature docs when exactly one of parameter or return value is documented
TEST [[
function FGPR0(p)
  print(p)
  return 0
end

---comment
function FGPR1(p)
  print(p)
  return 0
end

---@async
function FGPR1_(p)
  print(p)
  return 0
end

---comment
---@param p any
function FGPR2(p)
  print(p)
  return <!0!>
end

---comment
---@return integer
function FGPR3(<!p!>)
  print(p)
  return 0
end

---comment
---@param p any
---@return integer
function FGPR4(p)
  print(p)
  return 0
end
]]

-- local functions with no parameter, no return value
-- no incomplete signature docs possible
TEST [[
local function FL0()
end

FL0()

---comment
local function FL1()
end

FL1()

---@async
local function FL1_()
]]

-- local functions with single parameter, no return value
-- no incomplete signature docs possible
TEST [[
local function FLP0(p)
  print(p)
end

FLP0(0)

---comment
local function FLP1(p)
  print(p)
end

FLP1(0)

---@async
local function FLP1_(p)
  print(p)
end

---comment
---@param p any
local function FLP2(p)
  print(p)
end

FLP2(0)
]]

-- local functions with two parameters, no return value
-- incomplete signature docs when exactly one of the parameters is documented
TEST [[
local function FLPP0(p0, p1)
  print(p0, p1)
end

FLPP0(0, 1)

---comment
local function FLPP1(p0, p1)
  print(p0, p1)
end

FLPP1(0, 1)

---@async
local function FLPP1_(p0, p1)
  print(p0, p1)
end

---comment
---@param p0 any
local function FLPP2(p0, <!p1!>)
  print(p0, p1)
end

FLPP2(0, 1)

---comment
---@param p0 any
---@param p1 any
local function FLPP3(p0, p1)
  print(p0, p1)
end

FLPP3(0, 1)
]]

-- local functions with no parameter, single return value
-- no incomplete signature docs possible
TEST [[
local function FLR0()
  return 0
end

local vr0 = FLR0()

---comment
local function FLR1()
  return 0
end

---@async
local function FLR1_()
  return 0
end

local vr1 = FLR1()

---comment
---@return integer
local function FLR2()
  return 0
end

local vr2 = FLR2()
]]

-- local functions with no parameter, two return values
-- incomplete signature docs when exactly one of the return values is documented
TEST [[
local function FLRR0()
  return 0, 1
end

local vrr0, _ = FLRR0()

---comment
local function FLRR1()
  return 0, 1
end

local vrr1, _ = FLRR1()

---@async
local function FLRR1_()
  return 0, 1
end

---comment
---@return integer
local function FLRR2()
  return 0, <!1!>
end

local vrr2, _ = FLRR2()

---comment
---@return integer
---@return integer
local function FLRR3()
  return 0, 1
end

local vrr3, _ = FLRR3()
]]

-- local functions with one parameter, one return value
-- incomplete signature docs when exactly one of parameter or return value is documented
TEST [[
local function FLPR0(p)
  print(p)
  return 0
end

local vpr0 = FLPR0(0)

---comment
local function FLPR1(p)
  print(p)
  return 0
end

---@async
local function FLPR1_(p)
  print(p)
  return 0
end

local vpr1 = FLPR1(0)

---comment
---@param p any
local function FLPR2(p)
  print(p)
  return <!0!>
end

local vpr2 = FLPR2(0)

---comment
---@return integer
local function FLPR3(<!p!>)
  print(p)
  return 0
end

local vpr3 = FLPR3(0)

---comment
---@param p any
---@return integer
local function FLPR4(p)
  print(p)
  return 0
end

local vpr4 = FLPR4(0)
]]
