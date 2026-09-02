local TAG_DEPRECATED = ls.spec.DiagnosticTag.Deprecated

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function deprecatedProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, var in ipairs(ast.nodesMap['var']) do
        delayer:delay()
        ---@cast var LuaParser.Node.Var
        if var.value then
            goto continueVar
        end
        local variable = vfile:getVariable(var)
        if not variable then
            goto continueVar
        end
        if not variable:hasAnnotation('deprecated') then
            goto continueVar
        end
        callback {
            code    = 'deprecated',
            level   = 0,
            start   = var.start,
            finish  = var.finish,
            message = 'Deprecated.',
            tags    = { TAG_DEPRECATED },
        }
        ::continueVar::
    end
end

ls.feature.provider.diagnostic(deprecatedProvider)
