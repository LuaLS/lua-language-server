TEST [[
local function f()
    <!return!>
end
f()
]]

TEST [[
local function f()
    return nil
end
f()
]]

TEST [[
local function f()
    local function x()
        <!return!>
    end
    x()
    return true
end
f()
]]

TEST [[
local function f()
    local function x()
        return true
    end
    return x()
end
f()
]]
