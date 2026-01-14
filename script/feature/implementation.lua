---@type Feature.Provider<Feature.Implementation.Param>
local providers = ls.feature.helper.providers()

---@class Feature.Implementation.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources LuaParser.Node.Base[]

---@async
---@param uri Uri
---@param offset integer
---@return Location[]
function ls.feature.implementation(uri, offset)
    ls.scope.waitIndexing(uri)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 then
        return {}
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
    }

    local results = providers.runner(param)

    return ls.feature.helper.organizeResultsByRange(results)
end

---@param callback async fun(param: Feature.Implementation.Param, action: Feature.ProviderActions<Location>)
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.implementation(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

---@async
-- 局部变量的实现位置
ls.feature.provider.implementation(function (param, action)
    local first = param.sources[1]
    ---@type LuaParser.Node.Local?
    local loc
    if first.kind == 'var' then
        ---@cast first LuaParser.Node.Var
        loc = first.loc
    elseif first.kind == 'local' then
        ---@cast first LuaParser.Node.Local
        loc = first
    end
    if not loc then
        return
    end

    if loc.kind == 'param' then
        ---@cast loc LuaParser.Node.Param
        if loc.isSelf then
            local results = ls.feature.implementation(param.uri, loc.parent.name.last.finish)
            ls.util.map(results, action.push)
        end
    end
    local originRange = { first.start, first.finish }
    action.push {
        uri = loc.ast.source,
        range = { loc.start, loc.finish },
        originRange = originRange,
    }

    for _, ref in ipairs(loc.refs) do
        if ref.value then
            action.push {
                uri = ref.ast.source,
                range = { ref.start, ref.finish },
                originRange = originRange,
            }
        end
    end
end)
