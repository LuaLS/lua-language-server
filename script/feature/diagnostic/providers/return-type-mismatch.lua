---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function returnTypeMismatchProvider(param)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return {}
    end
    local results = {}
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
        if #funcNode.returnsDef == 0 then
            goto continue
        end
        for i, exp in ipairs(ret.exps) do
            local actual = vfile:getNode(exp)
            if not actual then
                goto continueExp
            end
            if actual.kind == 'value' then
                ---@cast actual Node.Value
                actual = actual.nodeType
            end
            if actual.kind == 'select' then
                ---@cast actual Node.Select
                actual = actual.value
            end
            local expect = funcNode:getReturn(i)
            if not expect then
                goto continueExp
            end
            if expect.kind == 'type' and (expect.typeName == 'any' or expect.typeName == 'unknown') then
                goto continueExp
            end
            if actual >> expect then
                goto continueExp
            end
            results[#results+1] = {
                code    = 'return-type-mismatch',
                level   = 0,
                start   = exp.start,
                finish  = exp.finish,
                message = ('Annotations specify that return value #%d has a type of `%s`, returning value of type `%s` here instead.'):format(i, expect:view(), actual:view()),
            }
            ::continueExp::
        end
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(returnTypeMismatchProvider)
