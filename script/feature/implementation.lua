local providers = {}

---@class Feature.Implementation.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources? LuaParser.Node.Base[]

---@param uri Uri
---@param offset integer
---@return Location[]
function ls.feature.implementation(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 then
        return {}
    end

    local result = {}
    local function push(loc)
        result[#result+1] = loc
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
    }

    for _, provider in ipairs(providers) do
        xpcall(provider, log.error, param, push)
    end

    return result
end

---@param callback fun(param: Feature.Implementation.Param, push: fun(loc: Location))
---@return fun() disposable
function ls.feature.provider.implementation(callback)
    table.insert(providers, callback)
    return function ()
        ls.util.arrayRemove(providers, callback)
    end
end

-- 局部变量的实现位置
ls.feature.provider.implementation(function (param, push)
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
            ls.util.map(results, push)
        end
    end
    local originRange = { first.start, first.finish }
    push {
        uri = loc.ast.source,
        range = { loc.start, loc.finish },
        originRange = originRange,
    }

    for _, ref in ipairs(loc.refs) do
        if ref.value then
            push {
                uri = ref.ast.source,
                range = { ref.start, ref.finish },
                originRange = originRange,
            }
        end
    end
end)
