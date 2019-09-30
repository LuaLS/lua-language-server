local guide    = require 'parser.guide'
local engineer = require 'core.engineer'

return function (ast, text, offset)
    local results = {}
    guide.eachSourceContain(ast.ast, offset, function (source)
        local searcher = engineer(ast)
        searcher:eachRef(source, 'def', function (src, mode)
            results[#results+1] = {
                uri    = ast.uri,
                source = source,
                target = src,
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
