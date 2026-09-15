--- 最小参数数：从右往左找第一个"不能为 nil"的参数（其左侧参数都必须实参占位）
--- 例如 (any, boolean, any) 的最小参数数为 2。
---@param rt Node.Runtime
---@param f Node.Function
---@return integer
local function getRequiredParams(rt, f)
    local params = f.paramsDef
    local min = 0
    for i = #params, 1, -1 do
        local p = params[i]
        if not p.optional then
            local t = p.value
            if t and not rt.NIL:canCast(t) then
                min = i
                break
            end
        end
    end
    return min
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function missingParameterProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, call in ipairs(ast.nodesMap['call']) do
        delayer:delay()
        ---@cast call LuaParser.Node.Call
        local fcall = vfile:getNode(call)
        if not fcall or fcall.kind ~= 'fcall' then
            goto continue
        end
        ---@cast fcall Node.FCall
        local matched = fcall.matchedFuncs
        if #matched == 0 then
            goto continue
        end
        local rt = param.scope.rt
        local minParams
        for _, f in ipairs(matched) do
            local m = getRequiredParams(rt, f)
            if not minParams or m < minParams then
                minParams = m
            end
        end
        local callArgs = call.args and #call.args or 0
        if call.node and call.node.kind == 'field' and call.node.subtype == 'method' then
            callArgs = callArgs + 1
        end
        -- 末位实参是多返回值调用时会展开：`f(g())` 实际收到 g 的全部返回值
        local lastArg = fcall.args and fcall.args[#fcall.args]
        if lastArg and lastArg.kind == 'fcall' then
            ---@cast lastArg Node.FCall
            local returns = lastArg.returns
            if returns and returns.kind == 'list' then
                ---@cast returns Node.List
                if returns.min > 1 then
                    callArgs = callArgs + returns.min - 1
                end
            end
        end
        if callArgs >= minParams then
            goto continue
        end
        callback {
            code    = 'missing-parameter',
            level   = 0,
            start   = call.start,
            finish  = call.finish,
            message = ('This function requires %d argument(s) but instead it is receiving %d.'):format(minParams, callArgs),
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(missingParameterProvider)
