TEST [[
local <!function x()
end!>
]]

TEST [[
local x = <!function () end!>
]]

TEST [[
local x
x = <!function () end!>
]]

TEST [[
local <!function x()
end!>
local <!function y()
    x()
end!>
]]

TEST [[
local f = <!function () end!>
]]

TEST [[
local f;f = <!function () end!>
]]

TEST [[
local <!function f() end!>
]]

TEST [[
local <!function f()
    f()
end!>
]]


TEST [[
local <!function test()
end!>

local <!function foo ()
end!>
]]
