---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function undefinedFieldProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile or not vfile.coder or not vfile.coder.map then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, field in ipairs(ast.nodesMap['field']) do
        delayer:delay()
        ---@cast field LuaParser.Node.Field
        if field.subtype ~= 'field' and field.subtype ~= 'method' then
            goto continue
        end
        local key = field.key
        if not key or key.kind ~= 'fieldid' then
            goto continue
        end
        ---@cast key LuaParser.Node.FieldID
        if field.value or (field.parent and field.parent.kind == 'assign') then
            goto continue
        end
        local node = vfile:getNode(field.last)
        if not node then
            goto continue
        end
        if node.kind == 'type' then
            ---@cast node Node.Type
            if node.typeName == 'nil' or node.typeName == 'never' then
                goto continue
            end
        end
        local _, exists = node:get(key.id)
        if exists then
            goto continue
        end
        callback {
            code    = 'undefined-field',
            level   = 0,
            start   = key.start,
            finish  = key.finish,
            message = ('Undefined field `%s`.'):format(key.id),
        }
        ::continue::
    end
end

ls.feature.provider.diagnostic(undefinedFieldProvider)
