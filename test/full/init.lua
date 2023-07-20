local parser  = require 'parser'
local config  = require 'config'
local util    = require 'utility'

rawset(_G, 'TEST', true)

function TEST(script)
    local clock = os.clock()
    local state = parser.compile(script, 'Lua', 'Lua 5.4')
    state.compileClock = os.clock() - clock
    return state
end

local function startCollectDiagTimes()
    for name in pairs(config.get(nil, 'Lua.diagnostics.neededFileStatus')) do
        if name ~= 'no-implicit-any' then
            --config.get(nil, 'Lua.diagnostics.neededFileStatus')[name] = 'Any'
        end
    end
    DIAGTIMES = {}
end

startCollectDiagTimes()
require 'full.normal'
require 'full.example'
require 'full.dirty'
require 'full.projects'
require 'full.self'

local times = {}
for name, time in util.sortPairs(DIAGTIMES, function (k1, k2)
    return DIAGTIMES[k1] > DIAGTIMES[k2]
end) do
    times[#times+1] = ('诊断任务耗时：%05.3f [%s]'):format(time, name)
    if #times >= 10 then
        break
    end
end

util.revertArray(times)
for _, time in ipairs(times) do
    print(time)
end
