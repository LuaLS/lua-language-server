---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function paramTypeMismatchProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, call in ipairs(ast.nodesMap['call']) do
        delayer:delay()
        ---@cast call LuaParser.Node.Call
        local args = call.args
        if not args or #args == 0 then
            goto continue
        end
        local fcall = vfile:getNode(call)
        if not fcall or fcall.kind ~= 'fcall' then
            goto continue
        end
        ---@cast fcall Node.FCall
        local matched = fcall.matchedFuncs
        if #matched == 0 then
            goto continue
        end
        local isMethod = call.node and call.node.kind == 'field' and call.node.subtype == 'method'
        for i, arg in ipairs(args) do
            local actual = vfile:getNode(arg)
            if not actual then
                goto continueArg
            end
            local paramIndex = isMethod and (i + 1) or i
            local ok = false
            for _, f in ipairs(matched) do
                local expect = f:getParam(paramIndex)
                if not expect then
                    ok = true
                    break
                end
                if expect.kind == 'type' and (expect.typeName == 'any' or expect.typeName == 'unknown') then
                    ok = true
                    break
                end
                if actual >> expect then
                    ok = true
                    break
                end
            end
            if ok then
                goto continueArg
            end
            local defView = ''
            for _, f in ipairs(matched) do
                local expect = f:getParam(paramIndex)
                if expect then
                    defView = expect:view()
                    break
                end
            end
            callback {
                code    = 'param-type-mismatch',
                level   = 0,
                start   = arg.start,
                finish  = arg.finish,
                message = ('Cannot assign `%s` to parameter `%s`.'):format(actual:view(), defView),
            }
            ::continueArg::
        end
        ::continue::
    end
end

ls.feature.provider.diagnostic(paramTypeMismatchProvider)
