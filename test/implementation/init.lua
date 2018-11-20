local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(script)
    local start  = script:find('<!', 1, true) + 2
    local finish = script:find('!>', 1, true) - 1
    local pos    = script:find('<?', 1, true) + 2
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')

    local suc, a, b = matcher.implementation(new_script, pos)
    assert(suc)
    assert(a == start)
    assert(b == finish)
end

require 'implementation.set'
require 'implementation.local'
require 'implementation.arg'
require 'implementation.function'
--require 'implementation.table'
require 'implementation.bug'
