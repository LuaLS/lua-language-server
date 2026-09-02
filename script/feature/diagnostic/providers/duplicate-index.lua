local TAG_UNNECESSARY = ls.spec.DiagnosticTag.Unnecessary

---@param field LuaParser.Node.TableField
---@return string | number | boolean | nil
local function getKeyName(field)
    if field.subtype == 'field' then
        local key = field.key
        ---@cast key LuaParser.Node.TableFieldID
        return key.id
    elseif field.subtype == 'index' then
        local key = field.key
        ---@cast key LuaParser.Node.Exp
        if key and key.isLiteral then
            ---@cast key LuaParser.Node.Literal
            return key.value
        end
        return nil
    elseif field.subtype == 'exp' then
        local key = field.key
        ---@cast key LuaParser.Node.Integer
        if key then
            return key.value
        end
    end
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function duplicateIndexProvider(param, callback)
    local ast = param.ast
    local delayer = ls.task.newThrottledDelayer(500)
    for _, tbl in ipairs(ast.nodesMap['table']) do
        delayer:delay()
        ---@cast tbl LuaParser.Node.Table
        local mark = {}
        for _, field in ipairs(tbl.fields) do
            ---@cast field LuaParser.Node.TableField
            local name = getKeyName(field)
            if name ~= nil then
                if not mark[name] then
                    mark[name] = {}
                end
                local def
                if field.subtype == 'exp' then
                    def = field.value
                else
                    def = field.key
                end
                if def then
                    mark[name][#mark[name]+1] = def
                end
            end
        end
        for name, defs in pairs(mark) do
            if #defs > 1 then
                local related = {}
                for i, def in ipairs(defs) do
                    related[i] = {
                        uri     = param.uri,
                        start   = def.start,
                        finish  = def.finish,
                        message = 'Also defined here.',
                    }
                end
                local message = ('Duplicate index `%s`.'):format(tostring(name))
                for i = 1, #defs - 1 do
                    local def = defs[i]
                    callback {
                        code    = 'duplicate-index',
                        level   = 0,
                        start   = def.start,
                        finish  = def.finish,
                        message = message,
                        tags    = { TAG_UNNECESSARY },
                        related = related,
                    }
                end
                local def = defs[#defs]
                callback {
                    code    = 'duplicate-index',
                    level   = 0,
                    start   = def.start,
                    finish  = def.finish,
                    message = message,
                    related = related,
                }
            end
        end
    end
end

ls.feature.provider.diagnostic(duplicateIndexProvider)
