---@type Feature.Provider<Feature.References.Param>
local providers = ls.feature.helper.providers()

---@class Feature.References.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field vm VM
---@field sources LuaParser.Node.Base[]
---@field includeDeclaration boolean

---@async
---@param uri Uri
---@param offset integer
---@param includeDeclaration boolean?
---@return Location[]
function ls.feature.references(uri, offset, includeDeclaration)
    ls.scope.waitReady(uri)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not sources or #sources == 0 or not scope then
        return {}
    end

    local param = {
        uri                = uri,
        offset             = offset,
        scope              = scope,
        vm                 = scope.vm,
        sources            = sources,
        includeDeclaration = includeDeclaration ~= false,
    }

    local results = providers.runner(param)

    return ls.feature.helper.organizeResultsByRange(results)
end

---@param callback async fun(param: Feature.References.Param, action: Feature.ProviderActions<Location>)
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.references(callback, priority)
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

---@param action Feature.ProviderActions<Location>
---@param param Feature.References.Param
---@param variable Node.Variable
local function collectRefs(action, param, variable)
    local effective = variable.masterVariable or variable
    local key = keyLiteral(effective.key)
    for _, eq in ipairs(effective.allEquivalents) do
        if eq.kind == 'variable' then
            ---@cast eq Node.Variable
            if keyLiteral(eq.key) == key then
                if param.includeDeclaration then
                    local location = eq:getLocation()
                    if location then
                        action.push(ls.feature.helper.convertLocation(location))
                    end
                    for assign in eq:eachAssign() do
                        if assign.location then
                            action.push(ls.feature.helper.convertLocation(assign.location))
                        end
                    end
                end
                for usage in eq:eachUsage() do
                    action.push(ls.feature.helper.convertLocation(usage))
                end
            end
        else
            ---@cast eq Node.Field
            if param.includeDeclaration and eq.location then
                action.push(ls.feature.helper.convertLocation(eq.location))
            end
        end
    end
end

-- 变量与参数的引用
ls.feature.provider.references(function (param, action)
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
    collectRefs(action, param, variable)
end)

---@param uri Uri
---@return boolean
local function isMetaUri(uri)
    return uri:sub(1, #ls.env.META_URI) == ls.env.META_URI
end

---@async
local function delay()
    ls.task.getCurrentTask()?:delay()
end

---@async
---@param action Feature.ProviderActions<Location>
---@param param Feature.References.Param
---@param func Node.Function
local function collectCallRefs(action, param, func)
    local vfiles = {}
    for _, vfile in pairs(param.vm.vfiles) do
        vfiles[#vfiles+1] = vfile
    end
    for _, vfile in ipairs(vfiles) do
        delay()
        local map = vfile.coder and vfile.coder.map
        if map and not isMetaUri(vfile.uri) then
            for _, node in pairs(map) do
                if node.kind == 'fcall' and node.location then
                    local suc, funcs = pcall(function ()
                        return node.matchedFuncs
                    end)
                    if suc then
                        for _, f in ipairs(funcs) do
                            if f == func then
                                action.push(ls.feature.helper.convertLocation(node.location))
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

---@async
---@param param Feature.References.Param
---@param action Feature.ProviderActions<Location>
local function fieldRefs(param, action)
    local first = param.sources[1]
    if first.kind == 'function' then
        ---@cast first LuaParser.Node.Function
        local func = param.vm:getNode(first)
        if func and func.kind == 'function' then
            ---@cast func Node.Function
            collectCallRefs(action, param, func)
            if first.name then
                local variable = param.vm:getVariable(first.name)
                if variable then
                    collectRefs(action, param, variable)
                end
            end
        end
        return
    end
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
    collectRefs(action, param, variable)
end

-- 字段、方法与函数的引用
ls.feature.provider.references(fieldRefs)
