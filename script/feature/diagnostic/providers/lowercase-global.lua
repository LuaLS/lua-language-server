---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function lowercaseGlobalProvider(param)
    local ast = param.ast
    local scope = param.scope
    local uri = param.uri
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)

    local globals = scope.config:get(uri, 'Lua.diagnostics.globals') or {}
    local globalsSet = {}
    for _, g in ipairs(globals) do
        globalsSet[g] = true
    end
    local globalsRegex = scope.config:get(uri, 'Lua.diagnostics.globalsRegex') or {}

    for _, node in ipairs(ast.nodesMap['assign']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Assign
        for _, exp in ipairs(node.exps) do
            if exp.kind ~= 'var' then
                goto continueExp
            end
            ---@cast exp LuaParser.Node.Var
            if exp.loc or exp.global then
                goto continueExp
            end
            local name = exp.id
            if globalsSet[name] then
                goto continueExp
            end
            local first = name:match '%w'
            if not first or not first:match '%l' then
                goto continueExp
            end
            local matched = false
            for _, pattern in ipairs(globalsRegex) do
                if name:match(pattern) then
                    matched = true
                    break
                end
            end
            if matched then
                goto continueExp
            end
            results[#results+1] = {
                code    = 'lowercase-global',
                level   = 0,
                start   = exp.start,
                finish  = exp.finish,
                message = 'Global variable in lowercase initial, Did you miss `local` or misspell it?',
            }
            ::continueExp::
        end
    end
    return results
end

ls.feature.provider.diagnostic(lowercaseGlobalProvider)
