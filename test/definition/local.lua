TEST [[
local <!x!>
<?x?>()
]]

TEST [[
local z, y, <!x!>
<?x?>()
]]

TEST [[
local <!x!> = 1
<?x?>()
]]

TEST [[
local z, y, <!x!> = 1
<?x?>()
]]

TEST [[
local x
local <!x!>
<?x?>()
]]

TEST [[
local <!x!>
do
    <?x?>()
end
]]

TEST [[
local <!x!>
do
    local x
end
<?x?>()
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
<?x?>()
]]

TEST [[
local <!x!>
if x then
    <?x?>()
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
<?x?>()
]]

TEST [[
local x
for <!x!> = 1, 10 do
    <?x?>()
end
]]

TEST [[
local <!x!>
for x in x do
end
<?x?>()
]]

TEST [[
local <!x!>
for x in <?x?> do
end
]]

TEST [[
local x
for <!x!> in x do
    <?x?>()
end
]]

TEST [[
local x
for z, y, <!x!> in x do
    <?x?>()
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
    <?x?>()
end
]]

TEST [[
local <!x!>
while x do
    local x
end
<?x?>()
]]

TEST [[
local <!x!>
repeat
    <?x?>()
until true
]]

TEST [[
local <!x!>
repeat
    local x
until true
<?x?>()
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
<?x?>()
]]

TEST [[
local <!x!>
return function ()
    <?x?>()
end
]]

TEST [[
local <!x!>
local x = function ()
    <?x?>()
end
]]

TEST [[
local <?<!x!>?>
]]
