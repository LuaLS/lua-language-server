local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local word = util.getCompletionWord(param)
    if word == '' then
        return
    end

    if param.scope.config:get(param.uri, 'Lua.completion.showWord') ~= 'Enable' then
        return
    end
    if not param.scope.config:get(param.uri, 'Lua.completion.workspaceWord') then
        return
    end

    if not util.isStatementPosition(param) then
        return
    end

    local words = param.scope.wordIndex:match(word)
    for _, name in ipairs(words) do
        if action.hasWord(name) then
            goto continue
        end
        action.push {
            label = name,
            kind = ls.spec.CompletionItemKind.Text,
        }
        ::continue::
    end
end, -1000)
