local providers = {}

---@param uri Uri
---@param offset integer
---@return Range[]?
function ls.core.definition(uri, offset)
    local sources = ls.scope.findSources(uri, offset)
    if not sources then
        return nil
    end

    local result = {}
    for _, provider in ipairs(providers) do
        local suc, res = xpcall(provider, log.error, uri, offset, sources)
        if suc and res then
            ls.util.arrayMerge(result, res)
        end
    end

    return result
end

---@param callback fun(uri: Uri, offset: integer, sources?: LuaParser.Node.Base[]):Range[]?
---@return fun() disposable
function ls.core.provider.definition(callback)
    table.insert(providers, callback)
    return function ()
        ls.util.arrayRemove(providers, callback)
    end
end
