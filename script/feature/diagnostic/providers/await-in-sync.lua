--- 作为实参传给 `async fun()` 形参的函数字面量，其函数体执行在异步上下文中
---@param func LuaParser.Node.Function
---@param vfile VM.Vfile
---@return boolean
local function isAsyncArgument(func, vfile)
    local call = func.parent
    if not call or call.kind ~= 'call' then
        return false
    end
    ---@cast call LuaParser.Node.Call
    local index
    for i, arg in ipairs(call.args or {}) do
        if arg == func then
            index = i
            break
        end
    end
    if not index then
        return false
    end
    if  call.node
    and call.node.kind == 'field'
    and call.node.subtype == 'method' then
        index = index + 1
    end
    local fcall = vfile:getNode(call)
    if not fcall or fcall.kind ~= 'fcall' then
        return false
    end
    ---@cast fcall Node.FCall
    for _, matched in ipairs(fcall.matchedFuncs) do
        local param = matched:getParam(index)
        if param then
            local isAsync = false
            param:each('function', function (fn)
                ---@cast fn Node.Function
                if fn.async then
                    isAsync = true
                end
            end)
            if isAsync then
                return true
            end
        end
    end
    return false
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function awaitInSyncProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, call in ipairs(ast.nodesMap['call']) do
        delayer:delay()
        ---@cast call LuaParser.Node.Call
        local currentFunc
        local parent = call.parent
        while parent do
            if parent.isMain then
                break
            end
            if parent.isFunction then
                currentFunc = parent
                break
            end
            parent = parent.parent
        end
        if not currentFunc then
            goto continue
        end
        local funcNode = vfile:getNode(currentFunc)
        if not funcNode or funcNode.kind ~= 'function' then
            goto continue
        end
        ---@cast funcNode Node.Function
        if funcNode.async then
            goto continue
        end
        if isAsyncArgument(currentFunc, vfile) then
            goto continue
        end
        local callee = vfile:getNode(call.node)
        if not callee then
            goto continue
        end
        local isAsync
        local variable = vfile:getVariable(call.node)
        if variable and variable:hasAnnotation('async') then
            isAsync = true
        end
        if not isAsync then
            callee:each('function', function (func)
                ---@cast func Node.Function
                if func.async then
                    isAsync = true
                end
            end)
        end
        if not isAsync then
            goto continue
        end
        callback {
            code    = 'await-in-sync',
            level   = 0,
            start   = call.node.start,
            finish  = call.node.finish,
            message = 'Async function can only be called in async function.',
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(awaitInSyncProvider)
