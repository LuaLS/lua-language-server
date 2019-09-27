local guide    = require 'parser.guide'
local engineer = require 'core.engineer'

return function (ast, text, offset)
    local results = {}
    local searcher = engineer(ast)
    guide.eachSource(offset, function (source)
        searcher:eachRef(source, function (src, mode)
            if src.start == 0 then
                return
            end
            if mode == 'local' or mode == 'set' then
                results[#results+1] = {
                    uri    = ast.uri,
                    source = source,
                    target = src,
                }
            end
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
