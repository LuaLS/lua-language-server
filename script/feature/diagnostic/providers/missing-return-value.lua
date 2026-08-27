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
            count = count + 1
        end
    end
    return count
end

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function missingReturnValueProvider(param)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return {}
    end
    local results = {}
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
        local rmin = #ret.exps
        if rmin >= min then
            goto continue
        end
        results[#results+1] = {
            code    = 'missing-return-value',
            level   = 0,
            start   = ret.start,
            finish  = ret.start + #'return',
            message = ('This function must return %d value(s) but instead it is returning %d.'):format(min, rmin),
        }
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(missingReturnValueProvider)
