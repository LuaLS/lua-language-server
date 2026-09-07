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
