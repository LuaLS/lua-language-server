local files = require("files")
local log = require("log")

return function (uri, options)
    local suc, rust = pcall(require, "rust")
    if not suc then
        return
    end
    local text = files.getOriginText(uri)
    local state = files.getState(uri)
    if not state then
        return
    end
    local status, formattedText = rust.luafmt.format(text, uri, options)

    if not status then
        if formattedText ~= nil then
            log.error(formattedText)
        end

        return
    end

    if text == formattedText then
        return
    end

    return {
        {
            start = state.ast.start,
            finish = state.ast.finish,
            text = formattedText
        }
    }
end
