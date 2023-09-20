TEST [[
local _
print(_)
local _
print(_)
local _ENV
<!print!>(_ENV) -- 由于重定义了_ENV，因此print变为了未定义全局变量
]]

TEST [[
_ENV = nil
<!print!>(<!A!>) -- `print` and `A` should warning 
]]

TEST [[
local _ENV = nil
<!print!>(<!A!>) -- `print` and `A` should warning 
]]

TEST [[
_ENV = {}
print(A) -- no warning
]]

TEST [[
local _ENV = {}
print(A) -- no warning
]]

TEST [[
_ENV = nil
<!GLOBAL!> = 1 --> _ENV.GLOBAL = 1
]]

TEST [[
_ENV = nil
local _ = <!print!> --> local _ = _ENV.print
]]

TEST [[
local function foo(_ENV)
    Joe = "human"
end
]]
