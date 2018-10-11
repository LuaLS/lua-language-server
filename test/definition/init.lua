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
local <!x!> = 1
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

test[[
local <!x!>
if x then
    local x
elseif <?x?> then
    local x
end
]]

test[[
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

test[[
local <!x!>
if x then
    <?x?> = 1
elseif x then
    local x
else
    local x
end
]]
