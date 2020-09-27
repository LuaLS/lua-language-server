local files    = require 'files'
local symbol   = require 'core.symbol'
local guide    = require 'parser.guide'
local matchKey = require 'core.matchkey'

local function searchFile(uri, key, results)
    local symbols = symbol(uri)
    if not symbols then
        return
    end

    for _, res in ipairs(symbols) do
        if res.name ~= '' and matchKey(key, res.name) then
            res.uri = uri
            results[#results+1] = res
        end
    end
end

return function (key)
    local results = {}

    for uri in files.eachFile() do
        searchFile(files.getOriginUri(uri), key, results)
    end

    return results
end
