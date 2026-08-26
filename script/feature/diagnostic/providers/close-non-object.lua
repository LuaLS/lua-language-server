---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function closeNonObjectProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['localdef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.LocalDef
        for _, loc in ipairs(node.vars) do
            if loc.attr and loc.attr.name and loc.attr.name.id == 'close' then
                if not loc.value then
                    results[#results+1] = {
                        code    = 'close-non-object',
                        level   = 0,
                        start   = loc.start,
                        finish  = loc.finish,
                        message = 'Cannot close a value of this type. (Unless set `__close` meta method)',
                    }
                end
            end
        end
    end
    return results
end

ls.feature.provider.diagnostic(closeNonObjectProvider)
