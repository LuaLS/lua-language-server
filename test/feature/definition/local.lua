TEST_DEF [[
local <!x!>
<?x?>()
]]

TEST_DEF [[
local z, y, <!x!>
<?x?>()
]]

TEST_DEF [[
local <!x!> = 1
<?x?>()
]]

TEST_DEF [[
local z, y, <!x!> = 1
<?x?>()
]]

TEST_DEF [[
local x
local <!x!>
<?x?>()
]]

TEST_DEF [[
local <!x!>
do
    <?x?>()
end
]]

TEST_DEF [[
local <!x!>
do
    local x
end
<?x?>()
]]

TEST_DEF [[
local <!x!>
if <?x?> then
    local x
end
]]

TEST_DEF [[
local <!x!>
if x then
    local x
elseif <?x?> then
    local x
end
]]

TEST_DEF [[
local <!x!>
if x then
    local x
elseif x then
    local x
else
    local x
end
<?x?>()
]]

TEST_DEF [[
local <!x!>
if x then
    <?x?>()
elseif x then
    local x
else
    local x
end
]]

TEST_DEF [[
local <!x!>
for x = 1, 10 do
end
<?x?>()
]]

TEST_DEF [[
local x
for <!x!> = 1, 10 do
    <?x?>()
end
]]

TEST_DEF [[
local <!x!>
for x in x do
end
<?x?>()
]]

TEST_DEF [[
local <!x!>
for x in <?x?> do
end
]]

TEST_DEF [[
local x
for <!x!> in x do
    <?x?>()
end
]]

TEST_DEF [[
local x
for z, y, <!x!> in x do
    <?x?>()
end
]]

TEST_DEF [[
local <!x!>
while <?x?> do
end
]]

TEST_DEF [[
local <!x!>
while x do
    <?x?>()
end
]]

TEST_DEF [[
local <!x!>
while x do
    local x
end
<?x?>()
]]

TEST_DEF [[
local <!x!>
repeat
    <?x?>()
until true
]]

TEST_DEF [[
local <!x!>
repeat
    local x
until true
<?x?>()
]]

TEST_DEF [[
local <!x!>
repeat
until <?x?>
]]

TEST_DEF [[
local x
repeat
    local <!x!>
until <?x?>
]]

TEST_DEF [[
local <!x!>
function _()
    local x
end
<?x?>()
]]

TEST_DEF [[
local <!x!>
return function ()
    <?x?>()
end
]]

TEST_DEF [[
local <!x!>
local x = function ()
    <?x?>()
end
]]

TEST_DEF [[
local <?<!x!>?>
]]
