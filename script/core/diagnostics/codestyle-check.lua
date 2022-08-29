local files       = require 'files'
local converter   = require 'proto.converter'
local log         = require 'log'
local pformatting = require 'provider.formatting'


---@async
return function(uri, callback)
    local text = files.getOriginText(uri)
    if not text then
        return
    end

    local suc, codeFormat  = pcall(require, 'code_format')
    if not suc then
        return
    end

    pformatting.updateConfig(uri)

    local status, diagnosticInfos = codeFormat.diagnose_file(uri, text)

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
                message = diagnosticInfo.message
            }
        end
    end
end
