---@type Feature.Provider<Feature.Completion.Param>
local providers = ls.feature.helper.providers()

---@class Feature.Completion.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources LuaParser.Node.Base[]

---@param uri Uri
---@param offset integer
---@return LSP.CompletionItem[]
function ls.feature.completion(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not scope then
        return {}
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
    }

    local results = providers.runner(param)

    return results
end

---@param callback fun(param: Feature.Completion.Param, action: Feature.ProviderActions<LSP.CompletionItem>)
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.completion(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

ls.feature.provider.completion(function (param, action)
end)
