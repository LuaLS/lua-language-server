local files     = require 'files'
local converter = require 'proto.converter'
local log       = require 'log'
local spell     = require 'provider.spell'


---@async
return function(uri, callback)
    local text = files.getOriginText(uri)
    if not text then
        return
    end

    local status, diagnosticInfos = spell.spellCheck(uri, text)

    if not status then
        if diagnosticInfos ~= nil then
            log.error(diagnosticInfos)
        end

        return
    end

    if diagnosticInfos then
        for _, diagnosticInfo in ipairs(diagnosticInfos) do
            callback {
                start   = converter.unpackPosition(uri, diagnosticInfo.range.start),
                finish  = converter.unpackPosition(uri, diagnosticInfo.range["end"]),
                message = diagnosticInfo.message,
                data    = diagnosticInfo.data
            }
        end
    end
end
