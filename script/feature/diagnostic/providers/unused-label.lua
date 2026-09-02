local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function unusedLabelProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['label']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Label
        if #node.gotos > 0 then
            goto continue
        end
        pd.push(callback, 'unused-label', node.start, node.finish, 'Unused label.')
        ::continue::
    end
end

ls.feature.provider.diagnostic(unusedLabelProvider)
