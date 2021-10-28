local files = require 'files'
local guide = require 'parser.guide'
local code_format = require "code_format"

return function(uri)
    local text = files.getText(uri)
    local state = files.getState(uri)

    local status, formatedText = code_format.format(text)
    local startPosition = guide.offsetToPosition(state, 0)
    local endPosition = guide.offsetToPosition(state, string.len(text))

    return status, {
        formatedText = formatedText,
        start = startPosition,
        finish = endPosition
    }
end
