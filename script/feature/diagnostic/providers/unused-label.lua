local pd = require 'feature.diagnostic.parser-diagnostics'

---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function unusedLabelProvider(param)
    local ast = param.ast
    local results = {}
    for _, node in ipairs(ast.nodesMap['label']) do
        ---@cast node LuaParser.Node.Label
        if #node.gotos > 0 then
            goto continue
        end
        pd.push(results, 'unused-label', node.start, node.finish, 'Unused label.')
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(unusedLabelProvider)
