local files  = require 'files'
local config = require 'config'

local function typeFormat(results, uri, position, ch, options)
    if ch ~= '\n' then
        return
    end
    local suc, codeFormat = pcall(require, "code_format")
    if not suc then
        return
    end
    local text = files.getOriginText(uri)
    local state = files.getState(uri)
    if not state then
        return
    end
    local converter = require("proto.converter")
    local pos = converter.packPosition(state, position)
    local typeFormatOptions = config.get(uri, 'Lua.typeFormat.config')
    local success, result = codeFormat.type_format(uri, text, pos.line, pos.character, options, typeFormatOptions)
    if success then
        local range = result.range
        results[#results+1] = {
            text   = result.newText,
            start  = converter.unpackPosition(state, { line = range.start.line, character = range.start.character }),
            finish = converter.unpackPosition(state, { line = range["end"].line, character = range["end"].character }),
        }
    end
end

return function (uri, position, ch, options)
    local state = files.getState(uri)
    if not state then
        return nil
    end

    if TEST then
        return nil
    end

    local results = {}

    typeFormat(results, uri, position, ch, options)
    if #results > 0 then
        return results
    end

    return nil
end
