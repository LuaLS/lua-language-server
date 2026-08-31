---@param node Node
---@return boolean
local function mayBeNil(node)
    if node.kind == 'type' then
        ---@cast node Node.Type
        return node.typeName == 'nil'
    end
    if node.kind == 'union' then
        ---@cast node Node.Union
        for _, v in ipairs(node.values) do
            if v.kind == 'type' and v.typeName == 'nil' then
                return true
            end
        end
    end
    return false
end

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function needCheckNilProvider(param)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return {}
    end
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, var in ipairs(ast.nodesMap['var']) do
        delayer:delay()
        ---@cast var LuaParser.Node.Var
        if not var.loc or var.value then
            goto continueVar
        end
        -- 仅检查「被调用」场景（x(...) 的 x 可能 nil，调用必然崩溃）。
        -- 链式访问中间环节（x.y.z 的 x / x.y）与索引 key（t[x] 的 x）默认不检查：
        -- Lua 没有非空断言，用户难以通过注解消除这类 nil
        local checkNil = false
        local parent = var.parent
        if parent and parent.kind == 'call' then
            ---@cast parent LuaParser.Node.Call
            if parent.node == var then
                checkNil = true
            end
        end
        if not checkNil then
            goto continueVar
        end
        local node = vfile:getNode(var)
        if not node then
            goto continueVar
        end
        if not mayBeNil(node) then
            goto continueVar
        end
        results[#results+1] = {
            code    = 'need-check-nil',
            level   = 0,
            start   = var.start,
            finish  = var.finish,
            message = 'Need check nil.',
        }
        ::continueVar::
    end
    return results
end

ls.feature.provider.diagnostic(needCheckNilProvider)
