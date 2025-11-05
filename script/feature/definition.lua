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
    local var = param.sources[1]
    if  var.kind ~= 'var'
    and var.kind ~= 'local'
    and var.kind ~= 'param' then
        return
    end
    skip()
    local variable = param.scope.vm:getVariable(var)
    if not variable then
        return
    end

    for _, location in ipairs(variable:getEquivalentLocations()) do
        push {
            uri = location.uri,
            range = { location.offset, location.offset + location.length },
            originRange = { var.start, var.finish },
        }
    end
end)

-- 字段的赋值位置
ls.feature.provider.definition(function (param, push)
    local first = param.sources[1]
    if first.kind == 'fieldid'
    or first.kind == 'string'
    or first.kind == 'integer'
    or first.kind == 'boolean'
    or first.kind == 'float' then
        first = first.parent
    end
    if not first or first.kind ~= 'field' then
        return
    end
    ---@type Node.Variable?
    local variable = param.scope.vm:getVariable(first)

    if not variable then
        return
    end

    for _, location in ipairs(variable:getEquivalentLocations()) do
        push {
            uri = location.uri,
            range = { location.offset, location.offset + location.length },
            originRange = { first.start, first.finish },
        }
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
