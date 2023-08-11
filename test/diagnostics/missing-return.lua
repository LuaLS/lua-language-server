TEST [[
---@type fun():number
local function f()
<!!>end
]]

TEST [[
---@type fun():number?
local function f()
end
]]

TEST [[
---@type fun():...
local function f()
end
]]

TEST [[
---@return number
function F()
    X = 1<!!>
end
]]
TEST [[
local A
---@return number
function F()
    if A then
        return 1
    end<!!>
end
]]

TEST [[
local A, B
---@return number
function F()
    if A then
        return 1
    elseif B then
        return 2
    end<!!>
end
]]

TEST [[
local A, B
---@return number
function F()
    if A then
        return 1
    elseif B then
        return 2
    else
        return 3
    end
end
]]

TEST [[
local A, B
---@return number
function F()
    if A then
    elseif B then
        return 2
    else
        return 3
    end<!!>
end
]]

TEST [[
---@return any
function F()
    X = 1
end
]]

TEST [[
---@return any, number
function F()
    X = 1<!!>
end
]]

TEST [[
---@return number, any
function F()
    X = 1<!!>
end
]]

TEST [[
---@return any, any
function F()
    X = 1
end
]]

TEST [[
local A
---@return number
function F()
    for _ = 1, 10 do
        if A then
            return 1
        end
    end
    error('should not be here')
end
]]

TEST [[
local A
---@return number
function F()
    while true do
        if A then
            return 1
        end
    end
end
]]

TEST [[
local A
---@return number
function F()
    while A do
        if A then
            return 1
        end
    end<!!>
end
]]

TEST [[
local A
---@return number
function F()
    while A do
        if A then
            return 1
        else
            return 2
        end
    end
end
]]

TEST [[
---@return number?
function F()

end
]]
