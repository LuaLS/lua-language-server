---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function newfieldCallProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, tbl in ipairs(ast.nodesMap['table']) do
        delayer:delay()
        ---@cast tbl LuaParser.Node.Table
        for _, field in ipairs(tbl.fields) do
            if field.subtype ~= 'exp' then
                goto continueField
            end
            local call = field.value
            if not call or call.kind ~= 'call' then
                goto continueField
            end
            ---@cast call LuaParser.Node.Call
            local node = call.node
            if not node then
                goto continueField
            end
            if node.finishRow == ast.lexer:rowcol(call.argPos) then
                goto continueField
            end
            local nodeText = ast.code:sub(node.start + 1, node.finish)
            local argsText = ast.code:sub(call.argPos + 1, call.finish)
            results[#results+1] = {
                code    = 'newfield-call',
                level   = 0,
                start   = call.start,
                finish  = call.finish,
                message = ('Will be interpreted as `%s%s`. It may be necessary to add a `,` or `;`.'):format(nodeText, argsText),
            }
            ::continueField::
        end
    end
    return results
end

ls.feature.provider.diagnostic(newfieldCallProvider)
