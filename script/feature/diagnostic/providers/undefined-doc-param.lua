---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function undefinedDocParamProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, func in ipairs(ast.nodesMap['function']) do
        delayer:delay()
        ---@cast func LuaParser.Node.Function
        local paramSet = {}
        if func.params then
            for _, p in ipairs(func.params) do
                paramSet[p.id] = true
            end
        end
        local parent = func.parent
        if not parent or not parent.cats then
            goto continue
        end
        local cats = parent.cats
        local expectRow = func.startRow - 1
        for i = #cats, 1, -1 do
            local cat = cats[i]
            ---@cast cat LuaParser.Node.Cat
            if cat.finishRow ~= expectRow then
                break
            end
            expectRow = cat.startRow - 1
            local value = cat.value
            if not value or value.kind ~= 'catstateparam' then
                goto nextCat
            end
            ---@cast value LuaParser.Node.CatStateParam
            local name = value.key.id
            if not paramSet[name] then
                results[#results+1] = {
                    code    = 'undefined-doc-param',
                    level   = 0,
                    start   = value.key.start,
                    finish  = value.key.finish,
                    message = ('Undefined param `%s`.'):format(name),
                }
            end
            ::nextCat::
        end
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(undefinedDocParamProvider)
