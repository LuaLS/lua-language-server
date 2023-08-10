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
