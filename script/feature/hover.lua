local hoverUtil = require 'feature.hover-util'

---@type Feature.Provider<Feature.Hover.Param>
local providers = ls.feature.helper.providers()

---@class Feature.Hover.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources LuaParser.Node.Base[]
---@field source LuaParser.Node.Base
---@field node? Node

---@class Feature.Hover.Result
---@field source LuaParser.Node.Base
---@field items Feature.Hover.Item[]
---@field value string

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

    local source = hoverUtil.getTargetSource(sources)
    if not source then
        return nil
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
        source  = source,
        node    = hoverUtil.getSemanticNode(scope, source),
    }

    local items = providers.runner(param)
    local value = hoverUtil.concatHoverItems(items)
    if not value then
        return nil
    end

    return {
        source = source,
        items  = items,
        value  = value,
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

ls.feature.provider.hover(function (param, action)
    for _, item in ipairs(hoverUtil.buildHoverItems(param.scope, param.source, param.node)) do
        action.push(item)
    end
end)

return ls.feature.hover
