---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function redundantParameterProvider(param)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return {}
    end
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, call in ipairs(ast.nodesMap['call']) do
        delayer:delay()
        ---@cast call LuaParser.Node.Call
        local args = call.args
        if not args or #args == 0 then
            goto continue
        end
        local fcall = vfile:getNode(call)
        if not fcall or fcall.kind ~= 'fcall' then
            goto continue
        end
        ---@cast fcall Node.FCall
        local matched = fcall.matchedFuncs
        if #matched == 0 then
            goto continue
        end
        local maxParams = 0
        for _, f in ipairs(matched) do
            local m = f.paramsPack.max
            if m == false then
                maxParams = 0
                break
            end
            if m and m > maxParams then
                maxParams = m
            end
        end
        if maxParams == 0 then
            goto continue
        end
        local isMethod = call.node and call.node.kind == 'field' and call.node.subtype == 'method'
        local callArgs = #args
        if isMethod then
            callArgs = callArgs + 1
        end
        if callArgs <= maxParams then
            goto continue
        end
        local startIndex = isMethod and maxParams or (maxParams + 1)
        for i = startIndex, #args do
            local arg = args[i]
            results[#results+1] = {
                code    = 'redundant-parameter',
                level   = 0,
                start   = arg.start,
                finish  = arg.finish,
                message = ('This function expects a maximum of %d argument(s) but instead it is receiving %d.'):format(maxParams, callArgs),
            }
        end
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(redundantParameterProvider)
