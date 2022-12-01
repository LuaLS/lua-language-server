local files = require("files")
local log = require("log")
local converter = require("proto.converter")

return function(uri, range, options)
    local state = files.getState(uri)
    if not state then
        return
    end
    local suc, codeFormat = pcall(require, "code_format")
    if not suc then
        return
    end
    local text = state.originText
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
            start = converter.unpackPosition(state, { line = startLine, character = 0 }),
            finish = converter.unpackPosition(state, { line = endLine + 1, character = 0 }),
            text = formattedText,
        }
    }
end
