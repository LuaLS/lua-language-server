---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function undefinedGlobalProvider(param, callback)
    local ast = param.ast
    local rt = param.scope.rt
    local delayer = ls.task.newThrottledDelayer(500)
    for _, var in ipairs(ast.nodesMap['var']) do
        delayer:delay()
        ---@cast var LuaParser.Node.Var
        if var.loc or var.global or var.value then
            goto continue
        end
        local g = rt:globalGet(var.id)
        if g:isDefined() then
            goto continue
        end
        callback {
            code    = 'undefined-global',
            level   = 0,
            start   = var.start,
            finish  = var.finish,
            message = ('Undefined global `%s`.'):format(var.id),
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(undefinedGlobalProvider)
