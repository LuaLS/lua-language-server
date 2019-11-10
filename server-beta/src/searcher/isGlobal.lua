local searcher = require 'searcher.searcher'
local guide    = require 'parser.guide'

function searcher.isGlobal(source)
    source = guide.getRoot(source)
    if not searcher.cache.eachGlobal[source] then
        searcher.eachGlobal(source, function () end)
    end
    return searcher.cache.isGlobal[source] == true
end
