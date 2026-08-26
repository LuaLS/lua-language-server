---@param targets LuaParser.Node.Base[]
---@param values LuaParser.Node.Exp[]
---@param results Feature.Diagnostic[]
local function pushUnbalanced(targets, values, results)
    if #values == 0 then
        return
    end
    for i = #values + 1, #targets do
        local target = targets[i]
        results[#results+1] = {
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
---@return Feature.Diagnostic[]
local function unbalancedAssignmentsProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['localdef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.LocalDef
        if node.values then
            pushUnbalanced(node.vars, node.values, results)
        end
    end
    for _, node in ipairs(ast.nodesMap['globaldef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.GlobalDef
        if node.values then
            pushUnbalanced(node.vars, node.values, results)
        end
    end
    for _, node in ipairs(ast.nodesMap['assign']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Assign
        if node.values then
            pushUnbalanced(node.exps, node.values, results)
        end
    end
    return results
end

ls.feature.provider.diagnostic(unbalancedAssignmentsProvider)
