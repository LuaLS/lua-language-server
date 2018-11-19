local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(script)
    local start  = script:find('<!', 1, true) + 2
    local finish = script:find('!>', 1, true) - 1
    local pos    = script:find('<?', 1, true) + 2
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')

    local suc, a, b = matcher.definition(new_script, pos)
    assert(suc)
    assert(a == start)
    assert(b == finish)
end

require 'definition.set'
require 'definition.local'
require 'definition.arg'
require 'definition.function'
--require 'definition.table'
require 'definition.bug'
