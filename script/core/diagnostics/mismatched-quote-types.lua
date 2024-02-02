local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local singleQuotedStrings = {}
    local doubleQuotedStrings = {}
    guide.eachSourceType(ast.ast, 'string', function (source)
        local str = source[1]
        local quoteType = source[2]
        if quoteType == "'" and not str:find('"') then
            singleQuotedStrings[#singleQuotedStrings+1] = source
        elseif quoteType == '"' and not str:find("'") then
            doubleQuotedStrings[#doubleQuotedStrings+1] = source
        end
    end)
    if #singleQuotedStrings == 0 or #doubleQuotedStrings == 0 then
        return
    end
    local minorityQuoteTypes
    if #singleQuotedStrings > #doubleQuotedStrings then
        minorityQuoteTypes = doubleQuotedStrings
    else
        minorityQuoteTypes = singleQuotedStrings
    end
    for _, source in ipairs(minorityQuoteTypes) do
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script.DIAG_MISMATCHED_QUOTE_TYPES,
        }
    end
end
