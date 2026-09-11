---@param f Node.Function
---@return integer|false min
local function getRequiredReturnCount(f)
    if #f.returnsDef == 0 then
        return false
    end
    local count = 0
    for _, r in ipairs(f.returnsDef) do
        if not r.optional then
            if r.value:findValue(ls.node.kind['spread']) then
                return false
            end
            if r.value.typeName == '...' then
                return false
            end
            local rt = f.scope.rt
            if rt.NIL:canCast(r.value) then
                goto continue
            end
            count = count + 1
        end
        ::continue::
    end
    return count
end

---@param ret LuaParser.Node.Return
---@param vfile VM.Vfile
---@return integer? count
local function getReturnedCount(ret, vfile)
    local n = #ret.exps
    if n == 0 then
        return 0
    end
    local last = vfile:getNode(ret.exps[n])
    if not last then
        return nil
    end
    local list = last:findValue(ls.node.kind['list'])
    if not list then
        return n
    end
    ---@cast list Node.List
    if not list.max then
        return nil
    end
    return n - 1 + list.min
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function missingReturnValueProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, ret in ipairs(ast.nodesMap['return']) do
        delayer:delay()
        ---@cast ret LuaParser.Node.Return
        local parent = ret.parent
        if not parent or parent.kind ~= 'function' then
            goto continue
        end
        local funcNode = vfile:getNode(parent)
        if not funcNode or funcNode.kind ~= 'function' then
            goto continue
        end
        ---@cast funcNode Node.Function
        local min = getRequiredReturnCount(funcNode)
        if not min or min == 0 then
            goto continue
        end
        local rmin = getReturnedCount(ret, vfile)
        if not rmin or rmin >= min then
            goto continue
        end
        callback {
            code    = 'missing-return-value',
            level   = 0,
            start   = ret.start,
            finish  = ret.start + #'return',
            message = ('This function must return %d value(s) but instead it is returning %d.'):format(min, rmin),
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(missingReturnValueProvider)
