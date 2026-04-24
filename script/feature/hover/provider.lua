---@type Feature.Provider<Feature.Hover.Param>
local providers = ls.feature.helper.providers()

---@class Feature.Hover.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field vm VM
---@field sources LuaParser.Node.Base[]
---@field source LuaParser.Node.Base
---@field node? Node

---@class Feature.Hover.Result
---@field source LuaParser.Node.Base
---@field items Feature.Hover.Item[]
---@field value string

---@class Feature.Hover.Item
---@field label string
---@field description? string

---@async
---@param uri Uri
---@param offset integer
---@return Feature.Hover.Result?
function ls.feature.hover(uri, offset)
    ls.scope.waitIndexing(uri)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 or not scope then
        return nil
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        vm      = scope.vm,
        sources = sources,
        source  = sources[1],
    }

    ---@type Feature.Hover.Item[]
    local items = providers.runner(param)

    if #items == 0 then
        return nil
    end

    local result = ls.tools.markdown.create()
    for _, item in ipairs(items) do
        result:append('lua', item.label)
        if item.description then
            result:appendText(item.description)
        end
        result:appendText('---')
    end

    return {
        source = sources[1],
        items  = items,
        value  = result:string(),
    }
end

---@param callback fun(param: Feature.Hover.Param, action: Feature.ProviderActions<Feature.Hover.Item>)
---@param priority integer?
---@return fun() disposable
function ls.feature.provider.hover(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end
