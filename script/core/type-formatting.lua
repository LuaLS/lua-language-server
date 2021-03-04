local files = require 'files'

local function checkEndAfterNL(results, uri, offset, ch)
    if ch ~= '\n' then
        return
    end
    local text = files.getText(uri)
    results[#results+1] = {
        start  = #text,
        finish = #text,
        text   = '\n',
    }
end

return function (uri, offset, ch)
    local ast  = files.getAst(uri)
    local text = files.getText(uri)
    if not ast or not text then
        return nil
    end

    local results = {}
    -- add `end` after `\n`
    checkEndAfterNL(results, uri, offset, ch)

    return results
end
