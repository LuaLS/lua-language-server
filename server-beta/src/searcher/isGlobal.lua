local searcher = require 'searcher.searcher'

function searcher.isGlobal(source)
    local node = source.node
    if not node then
        return false
    end
    local isGlobal
    searcher.eachRef(node, function (info)
        if info.source.tag == '_ENV' then
            isGlobal = true
        end
    end)
    return isGlobal
end
