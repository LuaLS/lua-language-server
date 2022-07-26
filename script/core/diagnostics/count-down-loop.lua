local files    = require "files"
local guide    = require "parser.guide"
local lang     = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state or not text then
        return
    end

    guide.eachSourceType(state.ast, 'loop', function (source)
        local maxNumber = source.max and tonumber(source.max[1])
        if not maxNumber then
            return
        end
        local minNumber = source.init and tonumber(source.init[1])
        if minNumber and maxNumber and minNumber <= maxNumber then
            return
        end
        if not minNumber and maxNumber ~= 1 then
            return
        end
        if not source.step then
            callback {
                start   = source.init.start,
                finish  = source.max.finish,
                message = lang.script('DIAG_COUNT_DOWN_LOOP'
                    , ('%s, %s'):format(text:sub(
                        guide.positionToOffset(state, source.init.start + 1),
                        guide.positionToOffset(state, source.max.finish)
                    ), '-1')
                )
            }
        else
            local stepNumber = tonumber(source.step[1])
            if stepNumber and stepNumber > 0 then
                callback {
                    start   = source.init.start,
                    finish  = source.step.finish,
                    message = lang.script('DIAG_COUNT_DOWN_LOOP'
                        , ('%s, -%s'):format(text:sub(
                            guide.positionToOffset(state, source.init.start + 1),
                            guide.positionToOffset(state, source.max.finish)
                        ), source.step[1])
                    )
                }
            end
        end
    end)
end
