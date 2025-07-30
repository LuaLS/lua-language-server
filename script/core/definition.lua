local providers = {}

---@param uri Uri
---@param offset integer
---@return Location[]
function ls.core.definition(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 then
        return {}
    end

    local result = {}
    local function push(loc)
        result[#result+1] = loc
    end

    for _, provider in ipairs(providers) do
        xpcall(provider, log.error, scope, offset, push, sources)
    end

    return result
end

---@param callback fun(scope: Scope, offset: integer, push: fun(loc: Location), sources?: LuaParser.Node.Base[])
---@return fun() disposable
function ls.core.provider.definition(callback)
    table.insert(providers, callback)
    return function ()
        ls.util.arrayRemove(providers, callback)
    end
end

-- 局部变量的定义位置
ls.core.provider.definition(function (scope, offset, push, sources)
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

-- 全局变量的赋值位置
ls.core.provider.definition(function (scope, offset, push, sources)
    local first = sources[1]
    ---@type Node.Variable?
    local variable
    if first.kind == 'var' then
        ---@cast first LuaParser.Node.Var
        if not first.loc then
            variable = scope.vm:getVariable(first)
        end
    end

    if not variable or not variable.assigns then
        return
    end

    ---@param field Node.Field
    for field in variable.assigns:pairsFast() do
        if field.location then
            push {
                uri = field.location.uri,
                range = { field.location.offset, field.location.offset + field.location.length },
                originRange = { first.start, first.finish },
            }
        end
    end
end)
