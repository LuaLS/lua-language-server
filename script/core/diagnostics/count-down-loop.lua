local files = require "files"
local guide = require "parser.guide"
local lang  = require 'language'

return function (uri, callback)
    local state = files.getAst(uri)
    local text  = files.getText(uri)
    if not state or not text then
        return
    end

    guide.eachSourceType(state.ast, 'loop', function (source)
        if not source.loc or not source.loc.value then
            return
        end
        local maxNumer = source.max and source.max.type == 'number' and tonumber(source.max[1])
        if maxNumer ~= 1 then
            return
        end
        local minNumber = source.loc and source.loc.value and source.loc.value.type == 'number' and tonumber(source.loc.value[1])
        if minNumber and minNumber <= 1 then
            return
        end
        if not source.step then
            callback {
                start  = source.loc.value.start,
                finish = source.max.finish,
                message = lang.script('DIAG_COUNT_DOWN_LOOP', ('%s, %s'):format(text:sub(source.loc.value.start, source.max.finish), '-1'))
            }
        else
            local stepNumber = source.step.type == 'number' and tonumber(source.step[1])
            if stepNumber and stepNumber > 0 then
                callback {
                    start  = source.loc.value.start,
                    finish = source.step.finish,
                    message = lang.script('DIAG_COUNT_DOWN_LOOP', ('%s, -%s'):format(text:sub(source.loc.value.start, source.max.finish), source.step[1]))
                }
            end
        end
    end)
end
