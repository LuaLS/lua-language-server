---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function globalInNilEnvProvider(param)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return {}
    end
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    for _, var in ipairs(ast.nodesMap['var']) do
        delayer:delay()
        ---@cast var LuaParser.Node.Var
        if var.loc or not var.env then
            goto continue
        end
        if var.id == var.env.id then
            goto continue
        end
        local envNode = vfile:getNode(var.env)
        if not envNode then
            goto continue
        end
        if not (envNode.kind == 'type' and envNode.typeName == 'nil') then
            goto continue
        end
        results[#results+1] = {
            code    = 'global-in-nil-env',
            level   = 0,
            start   = var.start,
            finish  = var.finish,
            message = 'Invalid global (`_ENV` is `nil`).',
            related = {
                {
                    uri    = param.uri,
                    start  = var.env.start,
                    finish = var.env.finish,
                },
            },
        }
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(globalInNilEnvProvider)
