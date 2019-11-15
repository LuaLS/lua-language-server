local searcher = require 'searcher.searcher'

function searcher.getGlobal(source)
    searcher.getGlobals(source)
    return searcher.cache.getGlobal[source]
end
