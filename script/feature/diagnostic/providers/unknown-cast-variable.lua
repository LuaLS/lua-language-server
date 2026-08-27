---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function unknownCastVariableProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)

    for _, cast in ipairs(ast.nodesMap['catstatecast']) do
        delayer:delay()
        ---@cast cast LuaParser.Node.CatStateCast
        local var = cast.var
        if not var then
            goto continue
        end
        if var.kind ~= 'var' then
            goto continue
        end
        ---@cast var LuaParser.Node.Var
        if var.loc or var.global then
            goto continue
        end
        results[#results+1] = {
            code    = 'unknown-cast-variable',
            level   = 0,
            start   = var.start,
            finish  = var.finish,
            message = ('Undefined variable `%s`.'):format(var.id),
        }
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(unknownCastVariableProvider)
