---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function duplicateDocAliasProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)

    ---@type table<string, {start: integer, finish: integer}[]>
    local aliasDefs = {}
    ---@type table<string, integer>
    local defCount = {}
    ---@type table<string, boolean>
    local partial = {}

    for _, cat in ipairs(ast.nodesMap['cat']) do
        delayer:delay()
        ---@cast cat LuaParser.Node.Cat
        if cat.subtype ~= 'alias' and cat.subtype ~= 'class' then
            goto continueCat
        end
        local value = cat.value
        if not value then
            goto continueCat
        end
        local name
        local start, finish
        local isAlias = false
        if value.kind == 'catstatealias' then
            ---@cast value LuaParser.Node.CatStateAlias
            name = value.aliasID.id
            start = value.aliasID.start
            finish = value.aliasID.finish
            isAlias = true
        elseif value.kind == 'catstateclass' then
            ---@cast value LuaParser.Node.CatStateClass
            name = value.classID.id
            start = value.classID.start
            finish = value.classID.finish
        else
            goto continueCat
        end
        if cat.attrs then
            for _, attr in ipairs(cat.attrs) do
                if attr.id == 'partial' then
                    partial[name] = true
                    break
                end
            end
        end
        defCount[name] = (defCount[name] or 0) + 1
        if isAlias then
            local group = aliasDefs[name]
            if not group then
                group = {}
                aliasDefs[name] = group
            end
            group[#group+1] = {
                start  = start,
                finish = finish,
            }
        end
        ::continueCat::
    end

    for name, group in pairs(aliasDefs) do
        delayer:delay()
        if partial[name] then
            goto continueGroup
        end
        if (defCount[name] or 0) < 2 then
            goto continueGroup
        end
        for _, pos in ipairs(group) do
            callback {
                code    = 'duplicate-doc-alias',
                level   = 0,
                start   = pos.start,
                finish  = pos.finish,
                message = ('Duplicate alias `%s`.'):format(name),
            }
        end
        ::continueGroup::
    end
end

ls.feature.provider.diagnostic(duplicateDocAliasProvider)
