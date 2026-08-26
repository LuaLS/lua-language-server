local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function redundantReturnProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, ret in ipairs(ast.nodesMap['return']) do
        delayer:delay()
        ---@cast ret LuaParser.Node.Return
        if #ret.exps > 0 then
            goto continue
        end
        local parent = ret.parent
        if not parent or parent.kind ~= 'function' then
            goto continue
        end
        pd.push(results, 'redundant-return', ret.start, ret.finish, 'Redundant return.')
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(redundantReturnProvider)
