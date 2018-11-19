TEST [[
local <!x!>
<?x?> = 1
]]

TEST [[
local z, y, <!x!>
<?x?> = 1
]]

TEST [[
local <!x!> = 1
<?x?> = 1
]]

TEST [[
local z, y, <!x!> = 1
<?x?> = 1
]]

TEST [[
function <!x!> () end
<?x?> = 1
]]

TEST [[
local function <!x!> () end
<?x?> = 1
]]

TEST [[
local x
local <!x!>
<?x?> = 1
]]

TEST [[
local <!x!>
do
    <?x?> = 1
end
]]

TEST [[
local <!x!>
do
    local x
end
<?x?> = 1
]]

TEST [[
local <!x!>
if <?x?> then
    local x
end
]]

TEST [[
local <!x!>
if x then
    local x
elseif <?x?> then
    local x
end
]]

TEST [[
local <!x!>
if x then
    local x
elseif x then
    local x
else
    local x
end
<?x?> = 1
]]

TEST [[
local <!x!>
if x then
    <?x?> = 1
elseif x then
    local x
else
    local x
end
]]

TEST [[
local <!x!>
for x = 1, 10 do
end
<?x?> = 1
]]

TEST [[
local x
for <!x!> = 1, 10 do
    <?x?> = 1
end
]]

TEST [[
local <!x!>
for x in x do
end
<?x?> = 1
]]

TEST [[
local <!x!>
for x in <?x?> do
end
]]

TEST [[
local x
for <!x!> in x do
    <?x?> = 1
end
]]

TEST [[
local x
for z, y, <!x!> in x do
    <?x?> = 1
end
]]

TEST [[
local <!x!>
while <?x?> do
end
]]

TEST [[
local <!x!>
while x do
    <?x?> = 1
end
]]

TEST [[
local <!x!>
while x do
    local x
end
<?x?> = 1
]]

TEST [[
local <!x!>
repeat
    <?x?> = 1
until true
]]

TEST [[
local <!x!>
repeat
    local x
until true
<?x?> = 1
]]

TEST [[
local <!x!>
repeat
until <?x?>
]]

TEST [[
local x
repeat
    local <!x!>
until <?x?>
]]

TEST [[
local <!x!>
function _()
    local x
end
<?x?> = 1
]]

TEST [[
local <!x!>
return function ()
    <?x?> = 1
end
]]

TEST [[
local <!x!>
local x = function ()
    <?x?> = 1
end
]]

TEST [[
local x
local function <!x!> ()
    <?x?> = 1
end
]]
