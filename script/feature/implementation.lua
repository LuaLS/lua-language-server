---@type Feature.Provider<Feature.Implementation.Param>
local providers = ls.feature.helper.providers()

---@class Feature.Implementation.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field vm VM
---@field sources LuaParser.Node.Base[]

---@async
---@param uri Uri
---@param offset integer
---@return Location[]
function ls.feature.implementation(uri, offset)
    ls.scope.waitIndexing(uri)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 or not scope then
        return {}
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        vm      = scope.vm,
        sources = sources,
    }

    local results = providers.runner(param)

    return ls.feature.helper.organizeResultsByRange(results)
end

---@param callback fun(param: Feature.Implementation.Param, action: Feature.ProviderActions<Location>)
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.implementation(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

---@param key Node.Key
---@return string | number | boolean?
local function keyLiteral(key)
    if type(key) ~= 'table' then
        ---@cast key string | number | boolean
        return key
    end
    ---@cast key Node.Value
    return key.literal
end

---@param rt Node.Runtime
---@param target Node.Type
---@return Node.Class[]
local function collectSubclasses(rt, target)
    local results = {}
    for name in rt:eachTypeName() do
        local t = rt.type(name)
        if t ~= target and t.classes then
            for _, ext in ipairs(t.fullExtends) do
                if ext.kind == 'type' and ext == target then
                    for _, cls in ipairs(t.classes) do
                        results[#results+1] = cls
                    end
                    break
                end
            end
        end
    end
    return results
end

---@param rt Node.Runtime
---@param fieldNode Node.Field
---@return Node.Class[]
local function collectOwnerClasses(rt, fieldNode)
    local results = {}
    for name in rt:eachTypeName() do
        local t = rt.type(name)
        if t.classes then
            for _, cls in ipairs(t.classes) do
                if cls.fields then
                    for field in cls.fields.fields:pairsFast() do
                        if field == fieldNode then
                            results[#results+1] = cls
                            break
                        end
                    end
                end
            end
        end
    end
    return results
end

---@param action Feature.ProviderActions<Location>
---@param origin LuaParser.Node.Base
---@param variable Node.Variable
---@param fieldName string | number | boolean
local function collectFieldAssigns(action, origin, variable, fieldName)
    local child = variable.childs and variable.childs[fieldName]
    if child then
        ---@cast child Node.Variable
        for assign in child:eachAssign() do
            if assign.location then
                action.push(ls.feature.helper.convertLocation(assign.location, origin))
            end
        end
    end
    for assign in variable:eachAssign() do
        local t = assign.value
               and assign.value:findValue(ls.node.kind['table'])
        if t and t.kind == 'table' then
            ---@cast t Node.Table
            if t.fields then
                for field in t.fields:pairsFast() do
                    if keyLiteral(field.key) == fieldName and field.location then
                        action.push(ls.feature.helper.convertLocation(field.location, origin))
                    end
                end
            end
        end
    end
end

-- 变量与参数的赋值位置
ls.feature.provider.implementation(function (param, action)
    local first = param.sources[1]
    if  first.kind ~= 'local'
    and first.kind ~= 'param'
    and first.kind ~= 'var' then
        return
    end
    local variable = param.vm:getVariable(first)
    if not variable then
        return
    end
    if first.kind == 'param' and variable:isSelfLike() then
        local master = variable.masterVariable
        if not master then
            return
        end
        variable = master
    elseif first.kind == 'var' then
        ---@cast first LuaParser.Node.Var
        local p = first.loc
        if p and p.kind == 'param' then
            local paramVariable = param.vm:getVariable(p)
            if paramVariable and paramVariable:isSelfLike() then
                local master = paramVariable.masterVariable
                if not master then
                    return
                end
                variable = master
            end
        end
    end
    for assign in variable:eachAssign() do
        if assign.location then
            action.push(ls.feature.helper.convertLocation(assign.location, first))
        end
    end
end)

-- 字段与方法的赋值位置
ls.feature.provider.implementation(function (param, action)
    local first = param.sources[1]
    local field = param.sources[2]
    if not field or field.kind ~= 'field' then
        return
    end
    ---@cast field LuaParser.Node.Field
    if field.key ~= first then
        return
    end
    local variable = param.vm:getVariable(field)
    if not variable then
        return
    end
    local key = keyLiteral(variable.key)
    for _, eq in ipairs(variable.allEquivalents) do
        if eq.kind == 'variable' then
            ---@cast eq Node.Variable
            if keyLiteral(eq.key) == key then
                for assign in eq:eachAssign() do
                    if assign.location then
                        action.push(ls.feature.helper.convertLocation(assign.location, first))
                    end
                end
            end
        else
            ---@cast eq Node.Field
            if eq.location then
                action.push(ls.feature.helper.convertLocation(eq.location, first))
            end
        end
    end
end)

-- 表构造器中字段的赋值位置
ls.feature.provider.implementation(function (param, action)
    local first = param.sources[1]
    if first.kind ~= 'tablefieldid' then
        return
    end
    local node = param.vm:getNode(first)
    if not node then
        return
    end
    ---@param field Node.Field
    node:each('field', function (field)
        if field.location and field.value ~= first then
            action.push(ls.feature.helper.convertLocation(field.location, first))
        end
    end)
end)

-- 函数与表值的位置
ls.feature.provider.implementation(function (param, action)
    local first = param.sources[1]
    local node = param.vm:getNode(first)
    if not node then
        return
    end
    ---@param func Node.Function
    node:each('function', function (func)
        if func.location then
            action.push(ls.feature.helper.convertLocation(func.location, first))
        end
    end)
    ---@param table Node.Table
    node:each('table', function (table)
        if table.locations then
            for _, location in ipairs(table.locations) do
                action.push(ls.feature.helper.convertLocation(location, first))
            end
        end
    end)
end)

-- LuaCats 类与类字段的实现
ls.feature.provider.implementation(function (param, action)
    local first = param.sources[1]
    if  first.kind ~= 'catid'
    and first.kind ~= 'catstatefield'
    and first.kind ~= 'catfieldname' then
        return
    end

    local rt = param.scope.rt

    if first.kind == 'catid' then
        ---@cast first LuaParser.Node.CatID
        local target = rt.type(first.id)
        if not target then
            return
        end
        for _, cls in ipairs(collectSubclasses(rt, target)) do
            if cls.location then
                action.push(ls.feature.helper.convertLocation(cls.location, first))
            end
        end
        return
    end

    local source = first.kind == 'catfieldname' and first.parent or first
    local fieldNode = param.vm:getNode(source)
    if not fieldNode or fieldNode.kind ~= 'field' then
        return
    end
    ---@cast fieldNode Node.Field
    local fieldName = keyLiteral(fieldNode.key)
    if not fieldName then
        return
    end

    local classes = {}
    local seen = {}
    for _, owner in ipairs(collectOwnerClasses(rt, fieldNode)) do
        if not seen[owner] then
            seen[owner] = true
            classes[#classes+1] = owner
        end
        if owner.masterType then
            for _, cls in ipairs(collectSubclasses(rt, owner.masterType)) do
                if not seen[cls] then
                    seen[cls] = true
                    classes[#classes+1] = cls
                end
            end
        end
    end

    for _, cls in ipairs(classes) do
        if cls.variables then
            for _, variable in ipairs(cls.variables) do
                local effective = variable.masterVariable or variable
                collectFieldAssigns(action, first, effective, fieldName)
            end
        end
    end
end)
