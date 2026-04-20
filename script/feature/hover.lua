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

    local blocks = providers.runner(param)
    local value = hoverUtil.concatMarkdownBlocks(blocks)
    if not value then
        return nil
    end

    return {
        source = source,
        value  = value,
    }
end

---@param callback fun(param: Feature.Hover.Param, action: Feature.ProviderActions<string>)
---@param priority integer?
---@return fun() disposable
function ls.feature.provider.hover(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

ls.feature.provider.hover(function (param, action)
    for _, block in ipairs(hoverUtil.buildMarkdownBlocks(param.node, param.source)) do
        action.push(block)
    end
end)

return ls.feature.hover
