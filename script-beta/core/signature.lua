local files = require 'files'
local guide = require 'parser.guide'

local function findNearCall(ast, pos)
    local nearCall
    guide.eachSourceContain(ast.ast, pos, function (src)
        if src.type == 'call' then
            if not nearCall or nearCall.start < src.start then
                nearCall = src
            end
        end
    end)
    return nearCall
end

return function (uri, pos)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local call = findNearCall(ast, pos)
    if not call then
        return nil
    end
    
end
