TEST [[
local <!function fl0()
end!>

---comment
local function fl1()
end
]]

TEST [[
local function fl0(<!p!>)
end

---@param p integer
local function fl1(p)
end
]]

TEST [[
local function fl0()
    return <!42!>
end

---@return integer
local function fl1()
    return 42
end
]]
