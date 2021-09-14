local guide     = require 'parser.guide'

local function isValidFunctionPos(source, offset)
    for i = 1, #source.keyword // 2 do
        local start  = source.keyword[i * 2 - 1]
        local finish = source.keyword[i * 2]
        if offset >= start and offset <= finish then
            return true
        end
    end
    return false
end

return function (ast, position, accept)
    local len = math.huge
    local result
    guide.eachSourceContain(ast.ast, position, function (source)
        if source.type == 'function' then
            if not isValidFunctionPos(source, position) then
                return
            end
        end
        local start, finish = guide.getStartFinish(source)
        if finish - start < len and accept[source.type] then
            result = source
            len = finish - start
        end
    end)
    return result
end
