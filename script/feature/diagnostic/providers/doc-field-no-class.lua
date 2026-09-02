---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function docFieldNoClassProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)

    for _, field in ipairs(ast.nodesMap['catstatefield']) do
        delayer:delay()
        ---@cast field LuaParser.Node.CatStateField
        if vfile:getNode(field) then
            goto continue
        end
        callback {
            code    = 'doc-field-no-class',
            level   = 0,
            start   = field.start,
            finish  = field.finish,
            message = 'Doc field must belong to a class.',
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(docFieldNoClassProvider)
