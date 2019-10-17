local guide    = require 'parser.guide'
local engineer = require 'core.engineer'

return function (ast, text, offset)
    local results = {}
    guide.eachSourceContain(ast.ast, offset, function (source)
        local searcher = engineer(ast)
        searcher:eachDef(source, function (src)
            if     src.type == 'setfield'
            or     src.type == 'getfield'
            or     src.type == 'tablefield' then
                src = src.field
            elseif src.type == 'setindex'
            or     src.type == 'getindex'
            or     src.type == 'tableindex' then
                src = src.index
            elseif src.type == 'getmethod'
            or     src.type == 'setmethod' then
                src = src.method
            end
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
