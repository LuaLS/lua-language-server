TEST [[
do
    x = 1
end
]]

TEST [[
return nil, 1, true, 'xx'
]]

TEST [[
return a
]]

TEST [[
retrun a.b:c(1, 2, ...)[1][name]
]]

TEST [[
return 1 + 1
]]

TEST [[
return -1
]]

TEST [[
return ...
]]

TEST [[
return function (a, b, ...)
end
]]

TEST [[
return {
    a = 1,
    b = {
        c = d,
        e = f,
    },
    g,
    h,
    1,
}
]]

TEST [[
::LABEL::
goto LABEL
goto NEXT
::NEXT::
]]

TEST [[
a, b, c = 1, 2, ...
]]

TEST [[
local a, b, c = 1, 2, ...
]]

TEST [[
a[#a+1] = 1
]]

TEST [[
xx(a, b, 2, 3, ...)
]]

TEST [[
if a then
elseif b then
elseif c then
else
end
]]

TEST [[
for i = 1, 10, 1 do
end
]]

TEST [[
for a, b, c in pairs(t) do
end
]]

TEST [[
while true do
end
]]

TEST [[
repeat
until true
]]

TEST [[
function xx:yy(a, b, c, ...)
end
]]

TEST [[
local function xx(a, b, c, ...)
end
]]

TEST [[
local v = 1
local function xx()
    print(v)
end
local v = 2
xx()
]]

TEST [[
return {
    1, 2, 3
}
]]

TEST [[
return function ()
end
]]

TEST [[
t[...] = 1
]]

TEST [[
return {
    [...] = ...
}
]]

TEST [[
-- 选取单位
---@param center point
---@param radius number
---@param height number
---@return unit[]
function scene:selectByCylinder(center, radius, height)
end
]]

TEST [[
local x = ,
]]

TEST [[
---@type any|fun():nil
local t    
]]
