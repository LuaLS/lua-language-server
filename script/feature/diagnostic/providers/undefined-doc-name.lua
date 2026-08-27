---@param rt Node.Runtime
---@param name string
---@return boolean
local function isDefined(rt, name)
    local t = rt.type(name)
    if t.isBasicType then
        return true
    end
    if t:isClassLike() or t:isAliasLike() then
        return true
    end
    return false
end

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function undefinedDocNameProvider(param)
    local ast = param.ast
    local rt = param.scope.rt
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)

    local defined = {}
    for _, cls in ipairs(ast.nodesMap['catstateclass']) do
        ---@cast cls LuaParser.Node.CatStateClass
        defined[cls.classID] = true
    end
    for _, al in ipairs(ast.nodesMap['catstatealias']) do
        ---@cast al LuaParser.Node.CatStateAlias
        defined[al.aliasID] = true
    end

    for _, id in ipairs(ast.nodesMap['catid']) do
        delayer:delay()
        ---@cast id LuaParser.Node.CatID
        local pkind = id.parent and id.parent.kind
        if pkind == 'catgeneric' or pkind == 'catstateclass' then
            goto continue
        end
        local ancestor = id.parent
        while ancestor do
            if ancestor.kind == 'catstatefield' then
                goto continue
            end
            ancestor = ancestor.parent
        end
        if defined[id] then
            goto continue
        end
        if id.var or id.generic or id.genericTemplate then
            goto continue
        end
        local name = id.id
        if name == '...' or name == '_' or name == 'self' then
            goto continue
        end
        if isDefined(rt, name) then
            goto continue
        end
        results[#results+1] = {
            code    = 'undefined-doc-name',
            level   = 0,
            start   = id.start,
            finish  = id.finish,
            message = ('Undefined type or alias `%s`.'):format(name),
        }
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(undefinedDocNameProvider)
