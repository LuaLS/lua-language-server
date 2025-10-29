local providers = ls.tools.pqueue.create()

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
    local skipPriorty = -1

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
    }

    for provider, priority in providers:pairs() do
        if priority <= skipPriorty then
            break
        end
        xpcall(provider, log.error, param, function (loc)
            results[#results+1] = loc
        end, function (p)
            p = p or priority
            if skipPriorty < p then
                skipPriorty = p
            end
        end)
    end

    return ls.feature.organizeResults(results)
end

---@param callback fun(param: Feature.Definition.Param, push: fun(loc: Location), skip: fun(priority?: integer))
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.definition(callback, priority)
    providers:insert(callback, priority)
    return function ()
        providers:remove(callback)
    end
end

-- 函数值的位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    local node = param.scope.vm:getNode(first)
    if not node then
        return
    end
    node = node:findValue { 'function' }
    if not node then
        return
    end
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

-- 局部变量的定义位置
ls.feature.provider.definition(function (param, push, skip)
    local first = param.sources[1]
    if first.kind ~= 'var' then
        return
    end
    ---@cast first LuaParser.Node.Var
    local loc = first.loc
    if not loc then
        return
    end
    skip()
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

-- 变量的赋值位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    if first.kind == 'fieldid' then
        first = first.parent
    end
    if not first then
        return
    end
    ---@type Node.Variable?
    local variable = param.scope.vm:getVariable(first)

    if not variable then
        return
    end

    ---@param var Node.Variable
    local function collect(var)
        if not var.assigns then
            return
        end
        ---@param assign Node.Field
        for assign in var.assigns:pairsFast() do
            if assign.location then
                push {
                    uri = assign.location.uri,
                    range = { assign.location.offset, assign.location.offset + assign.location.length },
                    originRange = { first.start, first.finish },
                }
            end
        end
    end

    collect(variable)

    if variable.foreignVariables then
        for _, var in ipairs(variable.foreignVariables) do
            collect(var)
        end
    end
end)

-- 标签
ls.feature.provider.definition(function (param, push, skip)
    local source = param.sources[2]
    if not source or source.kind ~= 'goto' then
        return
    end
    skip()
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
