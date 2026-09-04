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

    -- union 参数需被候选 overload 集合整体覆盖：每个成员都至少被一个 matched func 接受；
    -- matched 只含最佳匹配（union 实参时可能漏掉可覆盖个别成员的其它重载），失败时再回退检查全部重载
    ---@param actual Node
    ---@param matched Node.Function[]
    ---@param allFuncs Node.Function[]
    ---@param paramIndex integer
    ---@return boolean
    local function canAssign(actual, matched, allFuncs, paramIndex)
        -- 取实参的真实类型（调用会解析到返回值），再对其 union 逐成员判断
        local t = actual:simplify()
        local values
        if t.kind == 'union' then
            ---@cast t Node.Union
            values = t.values
        else
            values = { t }
        end
        for _, v in ipairs(values) do
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
                if v >> expect then
                    ok = true
                    break
                end
            end
            if not ok then
                for _, f in ipairs(allFuncs) do
                    local expect = f:getParam(paramIndex)
                    if expect and (v >> expect) then
                        ok = true
                        break
                    end
                end
            end
            if not ok then
                return false
            end
        end
        return true
    end

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
        -- 全部重载（原始定义）：union 成员可能由未入选 matched 的重载覆盖
        local allFuncs = {}
        fcall.head:each('function', function (f)
            ---@cast f Node.Function
            if not f:isDummy() then
                allFuncs[#allFuncs+1] = f
            end
        end)
        local isMethod = call.node and call.node.kind == 'field' and call.node.subtype == 'method'
        for i, arg in ipairs(args) do
            local actual = vfile:getNode(arg)
            if not actual then
                goto continueArg
            end
            local paramIndex = isMethod and (i + 1) or i
            if canAssign(actual, matched, allFuncs, paramIndex) then
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
