---@param func LuaParser.Node.Function
---@return boolean
local function isGlobalFunction(func)
    local name = func.name
    if not name or name.kind ~= 'var' then
        return false
    end
    ---@cast name LuaParser.Node.Var
    return name.loc == nil
end

---@param cats LuaParser.Node.Cat[]
---@param func LuaParser.Node.Function
---@return table<string, boolean> paramDocs
---@return integer returnCount
---@return boolean hasDoc
local function collectDoc(cats, func)
    local paramDocs = {}
    local returnCount = 0
    local hasDoc = false
    if not cats then
        return paramDocs, returnCount, hasDoc
    end
    local expectRow = func.startRow - 1
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
            hasDoc = true
        elseif value.kind == 'catstatereturn' then
            ---@cast value LuaParser.Node.CatStateReturn
            if value.returns then
                returnCount = returnCount + #value.returns
            elseif value.value then
                returnCount = returnCount + 1
            end
            hasDoc = true
        end
        ::nextCat::
    end
    return paramDocs, returnCount, hasDoc
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function missingGlobalDocProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, func in ipairs(ast.nodesMap['function']) do
        delayer:delay()
        ---@cast func LuaParser.Node.Function
        if not isGlobalFunction(func) then
            goto continue
        end
        local parent = func.parent
        if not parent then
            goto continue
        end
        local paramDocs, returnCount, hasDoc = collectDoc(parent.cats, func)

        local hasParam = func.params and #func.params > 0 or false
        local hasReturn = false
        for _, child in ipairs(func.childs) do
            if child.kind == 'return' and #child.exps > 0 then
                hasReturn = true
                break
            end
        end

        if not hasDoc then
            if not hasParam and not hasReturn then
                callback {
                    code    = 'missing-global-doc',
                    level   = 0,
                    start   = func.start,
                    finish  = func.finish,
                    message = 'Missing documentation for global function.',
                }
                goto continue
            end
        end

        if hasParam then
            for _, p in ipairs(func.params) do
                if p.id ~= 'self' and p.id ~= '_' and not paramDocs[p.id] then
                    callback {
                        code    = 'missing-global-doc',
                        level   = 0,
                        start   = p.start,
                        finish  = p.finish,
                        message = ('Missing documentation for parameter `%s`.'):format(p.id),
                    }
                end
            end
        end

        if hasReturn then
            for _, ret in ipairs(func.childs) do
                ---@cast ret LuaParser.Node.Return
                if ret.kind ~= 'return' then
                    goto continueRet
                end
                for i, exp in ipairs(ret.exps) do
                    if i > returnCount then
                        callback {
                            code    = 'missing-global-doc',
                            level   = 0,
                            start   = exp.start,
                            finish  = exp.finish,
                            message = ('Missing documentation for return value #%d.'):format(i),
                        }
                    end
                end
                ::continueRet::
            end
        end
        ::continue::
    end
end

ls.feature.provider.diagnostic(missingGlobalDocProvider)
