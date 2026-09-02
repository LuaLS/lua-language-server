local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function unusedLocalProvider(param, callback)
    local ast = param.ast
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
        pd.push(callback, 'unused-local', loc.start, loc.finish, ('Unused local `%s`.'):format(loc.id))
        ::continue::
    end
end

ls.feature.provider.diagnostic(unusedLocalProvider)
