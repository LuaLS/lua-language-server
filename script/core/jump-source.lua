local guide = require 'parser.guide'

---@param results table
return function (results)
    for _, result in ipairs(results) do
        if result.target.type == 'doc.field.name' then
            local doc = result.target.parent.source
            if doc then
                result.uri           = doc.source
                result.target.uri    = doc.source
                result.target.start  = guide.positionOf(doc.line - 1, 0)
                result.target.finish = guide.positionOf(doc.line - 1, 0)
            end
        else
            local target = result.target
            if target.type == 'method'
            or target.type == 'field' then
                target = target.parent
            end
            if target.bindDocs then
                for _, doc in ipairs(target.bindDocs) do
                    if  doc.type == 'doc.source'
                    and doc.bindSource == target then
                        result.uri           = doc.source
                        result.target.uri    = doc.source
                        result.target.start  = guide.positionOf(doc.line - 1, 0)
                        result.target.finish = guide.positionOf(doc.line - 1, 0)
                    end
                end
            end
        end
    end
end
