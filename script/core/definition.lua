local providers = {}

---@param uri Uri
---@param offset integer
---@return Location[]
function ls.core.definition(uri, offset)
    local sources = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 then
        return {}
    end

    local result = {}
    local function push(loc)
        result[#result+1] = loc
    end

    for _, provider in ipairs(providers) do
        xpcall(provider, log.error, uri, offset, push, sources)
    end

    return result
end

---@param callback fun(uri: Uri, offset: integer, push: fun(loc: Location), sources?: LuaParser.Node.Base[])
---@return fun() disposable
function ls.core.provider.definition(callback)
    table.insert(providers, callback)
    return function ()
        ls.util.arrayRemove(providers, callback)
    end
end

ls.core.provider.definition(function (uri, offset, push, sources)
    local first = sources[1]
    if first.kind == 'var' then
        ---@cast first LuaParser.Node.Var
        if first.loc then
            push {
                uri = first.ast.source,
                range = { first.loc.start, first.loc.finish },
                originRange = { first.start, first.finish },
            }
        end
    end
end)
