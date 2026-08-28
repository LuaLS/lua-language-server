---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function incompleteSignatureDocProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, func in ipairs(ast.nodesMap['function']) do
        delayer:delay()
        ---@cast func LuaParser.Node.Function
        local parent = func.parent
        if not parent or not parent.cats then
            goto continue
        end
        local paramDocs = {}
        local returnCount = 0
        local hasSignature = false
        local expectRow = func.startRow - 1
        local cats = parent.cats
        for i = #cats, 1, -1 do
            local cat = cats[i]
            ---@cast cat LuaParser.Node.Cat
            if cat.finishRow ~= expectRow then
                break
            end
            expectRow = cat.startRow - 1
            local value = cat.value
            if not value then
                goto nextCat
            end
            if value.kind == 'catstateparam' then
                ---@cast value LuaParser.Node.CatStateParam
                paramDocs[value.key.id] = true
                hasSignature = true
            elseif value.kind == 'catstatereturn' then
                ---@cast value LuaParser.Node.CatStateReturn
                if value.returns then
                    returnCount = returnCount + #value.returns
                elseif value.value then
                    returnCount = returnCount + 1
                end
                hasSignature = true
            end
            ::nextCat::
        end
        if not hasSignature then
            goto continue
        end
        if func.params then
            for _, p in ipairs(func.params) do
                if p.id ~= 'self' and p.id ~= '_' and not paramDocs[p.id] then
                    results[#results+1] = {
                        code    = 'incomplete-signature-doc',
                        level   = 0,
                        start   = p.start,
                        finish  = p.finish,
                        message = ('Missing documentation for parameter `%s`.'):format(p.id),
                    }
                end
            end
        end
        for _, ret in ipairs(func.childs) do
            ---@cast ret LuaParser.Node.Return
            if ret.kind ~= 'return' then
                goto continueRet
            end
            for i, exp in ipairs(ret.exps) do
                if i > returnCount then
                    results[#results+1] = {
                        code    = 'incomplete-signature-doc',
                        level   = 0,
                        start   = exp.start,
                        finish  = exp.finish,
                        message = ('Missing documentation for return value #%d.'):format(i),
                    }
                end
            end
            ::continueRet::
        end
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(incompleteSignatureDocProvider)
