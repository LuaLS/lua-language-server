local searcher = require 'searcher.searcher'
local guide    = require 'parser.guide'

function searcher.isGlobal(source)
    local globals = searcher.getGlobals(source)
    return searcher.cache.isGlobal[source] == true
end
