local guide     = require 'parser.guide'

return function (ast, offset, accept)
    local len = math.huge
    local result
    guide.eachSourceContain(ast.ast, offset, function (source)
        local start, finish = guide.getStartFinish(source)
        if finish - start < len and accept[source.type] then
            result = source
            len = finish - start
        end
    end)
    return result
end
