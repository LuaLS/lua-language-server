---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function undefinedDocClassProvider(param, callback)
    local ast = param.ast
    local rt = param.scope.rt
    local delayer = ls.task.newThrottledDelayer(500)

    local defined = {}
    for _, cls in ipairs(ast.nodesMap['catstateclass']) do
        ---@cast cls LuaParser.Node.CatStateClass
        defined[cls.classID.id] = true
    end

    for _, cls in ipairs(ast.nodesMap['catstateclass']) do
        delayer:delay()
        ---@cast cls LuaParser.Node.CatStateClass
        if not cls.extends then
            goto continueCls
        end
        for _, extend in ipairs(cls.extends) do
            local id = extend
            if id.kind == 'catparen' then
                ---@cast id LuaParser.Node.CatParen
                id = id:trim()
            end
            if id.kind ~= 'catid' then
                goto continueExt
            end
            ---@cast id LuaParser.Node.CatID
            if id.var or id.generic or id.genericTemplate then
                goto continueExt
            end
            local name = id.id
            if defined[name] then
                goto continueExt
            end
            local t = rt.type(name)
            if t.isBasicType or t:isClassLike() or t:isAliasLike() then
                goto continueExt
            end
            callback {
                code    = 'undefined-doc-class',
                level   = 0,
                start   = id.start,
                finish  = id.finish,
                message = ('Undefined class `%s`.'):format(name),
            }
            ::continueExt::
        end
        ::continueCls::
    end
end

ls.feature.provider.diagnostic(undefinedDocClassProvider)
