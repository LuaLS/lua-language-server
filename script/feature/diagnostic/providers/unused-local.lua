local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function unusedLocalProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, loc in ipairs(ast.nodesMap['local']) do
        delayer:delay()
        ---@cast loc LuaParser.Node.Local
        if pd.isExcludedLocal(loc, ast.envMode) then
            goto continue
        end
        if #loc.gets > 0 then
            goto continue
        end
        pd.push(results, 'unused-local', loc.start, loc.finish, ('Unused local `%s`.'):format(loc.id))
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(unusedLocalProvider)
