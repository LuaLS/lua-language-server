---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function duplicateDocParamProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, block in ipairs(ast.blockList) do
        delayer:delay()
        local cats = block.cats
        if not cats then
            goto continueBlock
        end
        local seen = {}
        local lastRow
        for _, cat in ipairs(cats) do
            if lastRow and lastRow + 1 ~= cat.startRow then
                seen = {}
            end
            lastRow = cat.finishRow
            local value = cat.value
            if not value or value.kind ~= 'catstateparam' then
                goto continueCat
            end
            ---@cast value LuaParser.Node.CatStateParam
            local name = value.key.id
            if seen[name] then
                callback {
                    code    = 'duplicate-doc-param',
                    level   = 0,
                    start   = value.key.start,
                    finish  = value.key.finish,
                    message = ('Duplicate params `%s`.'):format(name),
                }
            else
                seen[name] = true
            end
            ::continueCat::
        end
        ::continueBlock::
    end
end

ls.feature.provider.diagnostic(duplicateDocParamProvider)
