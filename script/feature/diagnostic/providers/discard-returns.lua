---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function discardReturnsProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, call in ipairs(ast.nodesMap['call']) do
        delayer:delay()
        ---@cast call LuaParser.Node.Call
        local parent = call.parent
        if not parent or not parent.isBlock then
            goto continue
        end
        if parent.condition == call then
            goto continue
        end
        if parent.kind == 'for' and ls.util.arrayHas(parent.exps, call) then
            goto continue
        end
        local func = vfile:getVariable(call.node)
        if not func or not func:hasAnnotation('nodiscard') then
            goto continue
        end
        callback {
            code    = 'discard-returns',
            level   = 0,
            start   = call.start,
            finish  = call.finish,
            message = 'The return values of this function are discarded, did you forget to use them?',
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(discardReturnsProvider)
