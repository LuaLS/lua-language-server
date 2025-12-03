TEST [[
local function f(<!...!>)
    return 'something'
end
f()
]]

TEST [[
local function f(...args)
    return 'something'
end
]]
