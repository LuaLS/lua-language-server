local files = require("files")
local log = require("log")
local converter = require("proto.converter")

return function(uri, range, options)
    local suc, codeFormat = pcall(require, "code_format")
    if not suc then
        return
    end
    local text = files.getOriginText(uri)
    local status, formattedText, startLine, endLine = codeFormat.range_format(
        uri, text, range.start.line, range["end"].line, options)

    if not status then
        if formattedText ~= nil then
            log.error(formattedText)
        end

        return
    end

    return {
        {
            start = converter.unpackPosition(uri, { line = startLine, character = 0 }),
            finish = converter.unpackPosition(uri, { line = endLine, character = 999999 }),
            text = formattedText,
        }
    }
end
