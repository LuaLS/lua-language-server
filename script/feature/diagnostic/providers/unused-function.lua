local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function unusedFunctionProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['function']) do
        delayer:delay()
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
        pd.push(callback, 'unused-function', name.start, name.finish, ('Unused function `%s`.'):format(name.id))
        ::continue::
    end
end

ls.feature.provider.diagnostic(unusedFunctionProvider)
