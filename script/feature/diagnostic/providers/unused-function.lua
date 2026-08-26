local pd = require 'feature.diagnostic.parser-diagnostics'

---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function unusedFunctionProvider(param)
    local ast = param.ast
    local results = {}
    for _, node in ipairs(ast.nodesMap['function']) do
        ---@cast node LuaParser.Node.Function
        local name = node.name
        if not name or name.kind ~= 'local' then
            goto continue
        end
        ---@cast name LuaParser.Node.Local
        if name.id == '_' then
            goto continue
        end
        if #name.gets > 0 then
            goto continue
        end
        pd.push(results, 'unused-function', name.start, name.finish, ('Unused function `%s`.'):format(name.id))
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(unusedFunctionProvider)
