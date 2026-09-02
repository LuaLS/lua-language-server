---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function newlineCallProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, call in ipairs(ast.nodesMap['call']) do
        delayer:delay()
        ---@cast call LuaParser.Node.Call
        if not call.next then
            goto continue
        end
        local node = call.node
        if not node then
            goto continue
        end
        local args = call.args
        if not args or #args ~= 1 then
            goto continue
        end
        if ast.code:sub(call.argPos + 1, call.argPos + 1) ~= '(' then
            goto continue
        end
        if node.finishRow == ast.lexer:rowcol(call.argPos) then
            goto continue
        end
        local nodeText = ast.code:sub(node.start + 1, node.finish)
        local argsText = ast.code:sub(call.argPos + 1, call.finish)
        callback {
            code    = 'newline-call',
            level   = 0,
            start   = node.start,
            finish  = call.finish,
            message = ('Will be interpreted as `%s%s`. It may be necessary to add a `,`.'):format(nodeText, argsText),
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(newlineCallProvider)
