TEST [[
local a
assert(a)

---@type boolean
local b
assert(b)

---@type any
local c
assert(c)

---@type unknown
local d
assert(d)

---@type boolean
local e
assert(e)

---@type number?
local f
assert(f)

assert(false)

assert(nil and 5)

---@return string?, string?
local function f() end

assert(f())
]]

TEST [[
<!assert!>(true)
]]

TEST [[
---@return integer
local function hi()
  return 1
end
<!assert!>(hi(1))
]]

TEST [[
<!assert!>({}, 'hi')
]]

TEST [[
---@return string, string?
local function f() end

<!assert!>(f())
]]
