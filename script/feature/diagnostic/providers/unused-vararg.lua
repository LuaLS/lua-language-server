local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function unusedVarargProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, p in ipairs(ast.nodesMap['param']) do
        delayer:delay()
        ---@cast p LuaParser.Node.Param
        if p.dummy or p.id ~= '...' then
            goto continue
        end
        local used = false
        for _, varargs in ipairs(ast.nodesMap['varargs']) do
            ---@cast varargs LuaParser.Node.Varargs
            if varargs.loc == p then
                used = true
                break
            end
        end
        if used then
            goto continue
        end
        pd.push(callback, 'unused-vararg', p.start, p.finish, 'Unused vararg.')
        ::continue::
    end
end

ls.feature.provider.diagnostic(unusedVarargProvider)
