---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function redundantReturnValueProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, ret in ipairs(ast.nodesMap['return']) do
        delayer:delay()
        ---@cast ret LuaParser.Node.Return
        if #ret.exps == 0 then
            goto continue
        end
        local parent = ret.parent
        if not parent or parent.kind ~= 'function' then
            goto continue
        end
        local funcNode = vfile:getNode(parent)
        if not funcNode or funcNode.kind ~= 'function' then
            goto continue
        end
        ---@cast funcNode Node.Function
        local max = funcNode:getReturnCount()
        if not max or #ret.exps <= max then
            goto continue
        end
        for i = max + 1, #ret.exps do
            local exp = ret.exps[i]
            callback {
                code    = 'redundant-return-value',
                level   = 0,
                start   = exp.start,
                finish  = exp.finish,
                message = ('This function can only return up to %d value(s) but instead it is returning %d.'):format(max, #ret.exps),
            }
        end
        ::continue::
    end
end

ls.feature.provider.diagnostic(redundantReturnValueProvider)
