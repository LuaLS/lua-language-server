local core   = require 'core.diagnostics'
local files  = require 'files'
local config = require 'config'
local util   = require 'utility'
local catch  = require 'catch'

config.get(nil, 'Lua.diagnostics.neededFileStatus')['deprecated']    = 'Any'
config.get(nil, 'Lua.diagnostics.neededFileStatus')['type-check']    = 'Any'
config.get(nil, 'Lua.diagnostics.neededFileStatus')['await-in-sync'] = 'Any'

rawset(_G, 'TEST', true)

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

---@diagnostic disable: await-in-sync
function TEST(script, ...)
    local newScript, catched = catch(script, '!')
    files.setText(TESTURI, newScript)
    files.open(TESTURI)
    local origins = {}
    local results = {}
    core(TESTURI, false, function (result)
        results[#results+1] = { result.start, result.finish }
        origins[#origins+1] = result
    end)

    if results[1] then
        if not founded(catched['!'] or {}, results) then
            error(('%s\n%s'):format(util.dump(catched['!']), util.dump(results)))
        end
    else
        assert(#catched['!'] == 0)
    end

    files.remove(TESTURI)

    return function (callback)
        callback(origins)
    end
end

require 'diagnostics.common'
require 'diagnostics.type-check'
