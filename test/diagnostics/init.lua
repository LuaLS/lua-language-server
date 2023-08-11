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

check 'ambiguity-1'
check 'assign-type-mismatch'
check 'await-in-sync'
check 'cast-local-type'
check 'cast-type-mismatch'
check 'circle-doc-class'
check 'close-non-object'
check 'code-after-break'
check 'count-down-loop'
check 'deprecated'
check 'discard-returns'
check 'doc-field-no-class'
check 'duplicate-doc-alias'
check 'duplicate-doc-field'
check 'duplicate-doc-param'
check 'duplicate-index'
check 'duplicate-set-field'
check 'empty-block'
check 'global-element'
check 'global-in-nil-env'
check 'incomplete-signature-doc'
check 'inject-field'
check 'invisible'
check 'lowercase-global'
check 'missing-fields'
check 'missing-global-doc'
check 'missing-local-export-doc'
check 'missing-parameter'
check 'missing-return-value'
check 'missing-return'
check 'need-check-nil'
check 'newfield-call'
check 'newline-call'
check 'not-yieldable'
check 'param-type-mismatch'
check 'redefined-local'
check 'redundant-parameter'
check 'redundant-return-value'
check 'redundant-return'
check 'redundant-value'
check 'return-type-mismatch'
check 'trailing-space'
check 'unbalanced-assignments'
check 'undefined-doc-class'
check 'undefined-doc-name'
check 'undefined-doc-param'
check 'undefined-env-child'
check 'undefined-field'
check 'undefined-global'
check 'unknown-cast-variable'
check 'unknown-diag-code'
check 'unknown-operator'
check 'unreachable-code'
check 'unused-function'
check 'unused-label'
check 'unused-local'
check 'unused-vararg'
