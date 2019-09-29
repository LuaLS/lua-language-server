local guide    = require 'parser.guide'
local engineer = require 'core.engineer'

return function (ast, text, offset)
    local results = {}
    local searcher = engineer(ast)
    guide.eachSource(ast.ast, offset, function (source)
        searcher:eachRef(source, function (src, mode)
            if mode == 'set' or mode == 'local' then
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
