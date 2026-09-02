local TAG_UNNECESSARY = ls.spec.DiagnosticTag.Unnecessary

---@param targets LuaParser.Node.Base[]
---@param values LuaParser.Node.Exp[]
---@param callback fun(diag: Feature.Diagnostic)
local function pushRedundant(targets, values, callback)
    for i = #targets + 1, #values do
        local value = values[i]
        callback {
            code    = 'redundant-value',
            level   = 0,
            start   = value.start,
            finish  = value.finish,
            message = ('Only has %d variables, but you set %d values.'):format(#targets, #values),
            tags    = { TAG_UNNECESSARY },
        }
    end
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function redundantValueProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['localdef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.LocalDef
        if node.values then
            pushRedundant(node.vars, node.values, callback)
        end
    end
    for _, node in ipairs(ast.nodesMap['globaldef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.GlobalDef
        if node.values then
            pushRedundant(node.vars, node.values, callback)
        end
    end
    for _, node in ipairs(ast.nodesMap['assign']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Assign
        if node.values then
            pushRedundant(node.exps, node.values, callback)
        end
    end
end

ls.feature.provider.diagnostic(redundantValueProvider)
