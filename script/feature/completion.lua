local providers, runner = ls.feature.helper.providers()

---@class Feature.Completion.Param
---@field uri Uri
---@field offset integer
---@field scope Scope

---@param uri Uri
---@param offset integer
---@return LSP.CompletionItem[]
function ls.feature.completion(uri, offset)
    local scope = ls.scope.find(uri)
    if not scope then
        return {}
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
    }

    local results = runner(param)

    return results
end

---@param callback fun(param: Feature.Completion.Param, push: fun(item: LSP.CompletionItem), skip: fun(priority?: integer))
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.completion(callback, priority)
    providers:insert(callback, priority)
    return function ()
        providers:remove(callback)
    end
end

ls.feature.provider.completion(function (param, push, skip)
end)
