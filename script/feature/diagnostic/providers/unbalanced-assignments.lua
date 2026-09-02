---@param targets LuaParser.Node.Base[]
---@param values LuaParser.Node.Exp[]
---@param callback fun(diag: Feature.Diagnostic)
local function pushUnbalanced(targets, values, callback)
    if #values == 0 then
        return
    end
    for i = #values + 1, #targets do
        local target = targets[i]
        callback {
            code    = 'unbalanced-assignments',
            level   = 0,
            start   = target.start,
            finish  = target.finish,
            message = 'The value is assigned as `nil` because the number of values is not enough.',
        }
    end
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function unbalancedAssignmentsProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['localdef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.LocalDef
        if node.values then
            pushUnbalanced(node.vars, node.values, callback)
        end
    end
    for _, node in ipairs(ast.nodesMap['globaldef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.GlobalDef
        if node.values then
            pushUnbalanced(node.vars, node.values, callback)
        end
    end
    for _, node in ipairs(ast.nodesMap['assign']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Assign
        if node.values then
            pushUnbalanced(node.exps, node.values, callback)
        end
    end
end

ls.feature.provider.diagnostic(unbalancedAssignmentsProvider)
