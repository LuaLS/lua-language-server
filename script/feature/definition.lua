local providers = {}

---@class Feature.Definition.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources? LuaParser.Node.Base[]

---@param uri Uri
---@param offset integer
---@return Location[]
function ls.feature.definition(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 then
        return {}
    end

    local results = {}
    local function push(loc)
        results[#results+1] = loc
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

    return ls.feature.organizeResults(results)
end

---@param callback fun(param: Feature.Definition.Param, push: fun(loc: Location))
---@return fun() disposable
function ls.feature.provider.definition(callback)
    table.insert(providers, callback)
    return function ()
        ls.util.arrayRemove(providers, callback)
    end
end

-- 局部变量的定义位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    if first.kind ~= 'var' then
        return
    end
    ---@cast first LuaParser.Node.Var
    local loc = first.loc
    if not loc then
        return
    end
    if not loc.value and loc.kind ~= 'param' then
        local results = ls.feature.implementation(param.uri, loc.start)
        ls.util.map(results, push)
        return
    end
    if loc.kind == 'param' then
        ---@cast loc LuaParser.Node.Param
        if loc.isSelf then
            local results = ls.feature.definition(param.uri, loc.parent.name.last.finish)
            ls.util.map(results, push)
            return
        end
    end
    push {
        uri = first.ast.source,
        range = { first.loc.start, first.loc.finish },
        originRange = { first.start, first.finish },
    }
end)

-- 全局变量的赋值位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    ---@type Node.Variable?
    local variable
    if first.kind == 'var' then
        ---@cast first LuaParser.Node.Var
        if not first.loc then
            variable = param.scope.vm:getVariable(first)
        end
    end

    if not variable or not variable.assigns then
        return
    end

    ---@param assign Node.Field
    for assign in variable.assigns:pairsFast() do
        if assign.location then
            push {
                uri = assign.location.uri,
                range = { assign.location.offset, assign.location.offset + assign.location.length },
                originRange = { first.start, first.finish },
            }
        end
    end
end)

-- 字段的赋值位置
ls.feature.provider.definition(function (param, push)
    local key   = param.sources[1]
    local field = param.sources[2]
    if not key
    or not field
    or field.kind ~= 'field'
    ---@cast field LuaParser.Node.Field
    or field.key ~= key then
        return
    end

    ---@cast field LuaParser.Node.Field
    local results = param.scope.vm:findFields(field.last, param.scope.vm:getKey(field))
    if not results then
        return
    end
    for _, result in ipairs(results) do
        if result.location then
            push {
                uri = result.location.uri,
                range = { result.location.offset, result.location.offset + result.location.length },
                originRange = { field.start, field.finish },
            }
        end
    end
end)

-- 函数值的位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    local node = param.scope.vm:getNode(first)
    if not node then
        return
    end
    node = node.solve
    if node.kind == 'function' then
        ---@cast node Node.Function
        if node.location then
            push {
                uri = node.location.uri,
                range = { node.location.offset, node.location.offset + node.location.length },
                originRange = { first.start, first.finish },
            }
        end
    end
end)

-- 标签
ls.feature.provider.definition(function (param, push)
    local source = param.sources[2]
    if not source or source.kind ~= 'goto' then
        return
    end
    ---@cast source LuaParser.Node.Goto
    local label = source.label
    if not label then
        return
    end

    push {
        uri = label.ast.source,
        range = { label.name.start, label.name.finish },
        originRange = { source.name.start, source.name.finish },
    }
end)
