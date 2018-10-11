local matcher = require 'matcher'

local function test(script)
    local start  = script:find('<!', 1, true) + 2
    local finish = script:find('!>', 1, true) - 1
    local pos    = script:find('<?', 1, true) + 2
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')

    local suc, a, b = matcher.definition(new_script, pos)
    assert(suc)
    assert(a == start)
    assert(b == finish)
end

test [[
local <!x!>
<?x?> = 1
]]

test [[
local z, y, <!x!>
<?x?> = 1
]]

test [[
local <!x!> = 1
<?x?> = 1
]]

test [[
local z, y, <!x!> = 1
<?x?> = 1
]]

test [[
function <!x!> () end
<?x?> = 1
]]

test [[
local function <!x!> () end
<?x?> = 1
]]

test [[
local x
local <!x!>
<?x?> = 1
]]

test [[
local <!x!>
do
    <?x?> = 1
end
]]

test [[
local <!x!>
do
    local x
end
<?x?> = 1
]]

test [[
local <!x!>
if <?x?> then
    local x
end
]]

test [[
local <!x!>
if x then
    local x
elseif <?x?> then
    local x
end
]]

test [[
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

test [[
local <!x!>
if x then
    <?x?> = 1
elseif x then
    local x
else
    local x
end
]]

test [[
local <!x!>
for x = 1, 10 do
end
<?x?> = 1
]]

test [[
local x
for <!x!> = 1, 10 do
    <?x?> = 1
end
]]

test [[
local <!x!>
for x in x do
end
<?x?> = 1
]]

test [[
local <!x!>
for x in <?x?> do
end
]]

test [[
local x
for <!x!> in x do
    <?x?> = 1
end
]]

test [[
local x
for z, y, <!x!> in x do
    <?x?> = 1
end
]]

test [[
local <!x!>
while <?x?> do
end
]]

test [[
local <!x!>
while x do
    <?x?> = 1
end
]]

test [[
local <!x!>
while x do
    local x
end
<?x?> = 1
]]

test [[
local <!x!>
repeat
    <?x?> = 1
until true
]]

test [[
local <!x!>
repeat
    local x
until true
<?x?> = 1
]]

test [[
local <!x!>
repeat
until <?x?>
]]

test [[
local x
repeat
    local <!x!>
until <?x?>
]]

test [[
local <!x!>
function _()
    local x
end
<?x?> = 1
]]

test [[
local <!x!>
return function ()
    <?x?> = 1
end
]]

test [[
local <!x!>
local x = function ()
    <?x?> = 1
end
]]

test [[
local x
local function <!x!> ()
    <?x?> = 1
end
]]
