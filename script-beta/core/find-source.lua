local guide     = require 'parser.guide'

return function (ast, offset, accept)
    local len = 999
    local result
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.finish - source.start < len and accept[source.type] then
            result = source
            len = source.finish - source.start
        end
    end)
    return result
end
