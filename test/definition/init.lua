local matcher = require 'matcher'

local function test(script)
    local start  = script:find('<!', 1, true) + 2
    local finish = script:find('!>', 1, true) - 1
    local pos    = script:find('<?', 1, true) + 2
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')

    local a, b = matcher.definition(new_script, pos)
    assert(a == start)
    assert(b == finish)
end

test [[
local <!a!>
<?a?> = 1
]]
