local core   = require 'core.diagnostics'
local files  = require 'files'
local config = require 'config'
local util   = require 'utility'
local catch  = require 'catch'

local status = config.get(nil, 'Lua.diagnostics.neededFileStatus')

for key in pairs(status) do
    status[key] = 'Any!'
end

config.set('nil', 'Lua.type.castNumberToInteger', false)
config.set('nil', 'Lua.type.weakUnionCheck', false)
config.set('nil', 'Lua.type.weakNilCheck', false)

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
function TEST(script)
    local newScript, catched = catch(script, '!')
    files.setText(TESTURI, newScript)
    files.open(TESTURI)
    local origins = {}
    local filteds = {}
    local results = {}
    core(TESTURI, false, function (result)
        if DIAG_CARE == result.code
        or DIAG_CARE == '*' then
            results[#results+1] = { result.start, result.finish }
            filteds[#filteds+1] = result
        end
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
        callback(filteds)
    end
end

local function check(name)
    DIAG_CARE = name
    require('diagnostics.' .. name)
end

check 'unused-local'
check 'unused-function'
check 'undefined-global'
check 'unused-label'
check 'trailing-space'
check 'redefined-local'
check 'global-in-nil-env'
check 'undefined-env-child'
check 'newline-call'
check 'newfield-call'
check 'redundant-parameter'
check 'cast-local-type'
check 'assign-type-mismatch'
check 'cast-type-mismatch'
check 'need-check-nil'
check 'return-type-mismatch'
check 'missing-return'
check 'missing-return-value'
check 'redundant-return-value'
check 'incomplete-signature-doc'
check 'missing-global-doc'
check 'missing-local-export-doc'
check 'global-element'
check 'missing-parameter'
check 'close-non-object'
check 'duplicate-doc-field'
check 'lowercase-global'
check 'deprecated'
check 'duplicate-index'
check 'empty-block'
check 'redundant-value'
check 'code-after-break'
check 'duplicate-doc-alias'
check 'circle-doc-class'
check 'undefined-doc-param'
check 'duplicate-doc-param'
check 'doc-field-no-class'
check 'undefined-field'
check 'count-down-loop'
check 'duplicate-set-field'
check 'redundant-return'
check 'discard-returns'

require 'diagnostics.common'
