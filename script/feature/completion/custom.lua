-- 自定义 alias 的补全：字符串参数的期望类型关联了 onCompletion 的 custom alias 时，
-- 追加 customCompletion 回调返回的补全项。期望类型经 Node:getExpectValue() 反推。
local util = ls.feature.completionUtil

--- 在类型节点上查找注册了 customCompletion 的 alias（递归处理 union）
---@param node? Node
---@return Node.Alias?
local function findCustomCompletionAlias(node)
    if not node then
        return nil
    end
    if node.kind == 'union' then
        ---@cast node Node.Union
        for _, v in ipairs(node.values) do
            local alias = findCustomCompletionAlias(v)
            if alias then
                return alias
            end
        end
        return nil
    end
    if node.kind ~= 'type' then
        return nil
    end
    ---@cast node Node.Type
    if not node.aliases then
        return nil
    end
    for _, alias in ipairs(node.aliases) do
        if alias.customCompletion then
            return alias
        end
    end
    return nil
end

--- 查找节点的 custom completion alias：优先实际值，再兜底期望类型（rt.getExpectValue）
---@param node Node?
---@param source LuaParser.Node.Base?
---@return Node.Alias?
local function findCustomCompletionAliasFromNode(node, source)
    if not node then
        return nil
    end
    local alias = findCustomCompletionAlias(node.value)
    if alias then
        return alias
    end
    if source then
        return findCustomCompletionAlias(node.scope.rt:getExpectValue(source))
    end
    return nil
end

ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end
    if not param.inString then
        return
    end
    local source = param.sources[1]
    if not source or source.kind ~= 'string' then
        return
    end
    ---@cast source LuaParser.Node.String
    local node = param.scope.vm:getVariable(source) or param.scope.vm:getNode(source)
    if not node then
        return
    end
    local alias = findCustomCompletionAliasFromNode(node, source)
    if not alias then
        return
    end
    local results = alias.customCompletion(alias, {
        uri    = param.uri,
        offset = param.offset,
    }, source)
    if not results or #results == 0 then
        return
    end

    action.skip()

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset)
    local left = text:sub(1, textOffset)
    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local inDoubleQuote = left:match('"[^"\n]*$') ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and (inSingleQuote or inDoubleQuote) then
        editStartOffset = textOffset
        editFinishOffset = textOffset
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)

    local used = {}
    for _, item in ipairs(results) do
        if not used[item.label] then
            used[item.label] = true
            local documentation
            if item.description then
                documentation = {
                    kind  = ls.spec.MarkupKind.Markdown,
                    value = item.description,
                }
            end
            action.push {
                label = item.label,
                detail = item.detail,
                documentation = documentation,
                kind = item.kind or ls.spec.CompletionItemKind.Module,
                textEdit = {
                    start   = editStart,
                    finish  = editFinish,
                    newText = item.label,
                },
            }
        end
    end
end, 27)
