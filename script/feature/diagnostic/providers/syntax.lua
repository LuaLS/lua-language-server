local messages = {
    UNKNOWN_SYMBOL         = 'Unexpected symbol `{code}`.',
    ERR_EQ_AS_ASSIGN       = 'Should use `==` for equal.',
    ERR_NONSTANDARD_SYMBOL = 'Lua should use `{symbol}`.',
    UNSUPPORT_SYMBOL       = 'This grammar is not supported in the current Lua version.',
    ACTION_AFTER_RETURN    = '<eof> expected after `return`.',
    MISS_CAT_NAME          = '<doc name> expected.',
    UNEXPECT_CAT_CALL      = 'Unexpected annotation call.',
    UNDEFINED_GENERIC      = 'Undefined generic `{code}`.',
    MISS_SEP_IN_TABLE      = 'Miss symbol `,` or `;`.',
    ERR_COMMENT_PREFIX     = 'Lua should use `--` for annotations.',
    ERR_C_LONG_COMMENT     = 'Lua should use `--[[ ]]` for multi-line annotations.',
    MISS_SYMBOL            = 'Missed symbol `{symbol}`.',
    MISS_EXP               = '<exp> expected.',
    MISS_END               = 'Miss corresponding `end`.',
    ERR_THEN_AS_DO         = 'Should use `then`.',
    ERR_DO_AS_THEN         = 'Should use `do`.',
    UNEXPECT_EFUNC_NAME    = 'Function as expression cannot be named.',
    AMBIGUOUS_SYNTAX       = 'In Lua 5.1, the left brackets called by the function must be in the same line as the function.',
    NEED_PAREN             = 'Need to add a pair of parentheses.',
    MISS_NAME              = '<name> expected.',
    KEYWORD                = '<keyword> cannot be used as name.',
    RESERVED_WORD          = '`{code}` is a reserved word.',
    UNICODE_NAME           = 'Contains Unicode characters.',
    UNEXPECT_SYMBOL        = 'Unexpected symbol `{code}`.',
    MALFORMED_NUMBER       = 'Malformed number.',
    MISS_EXPONENT          = 'Missed digits for the exponent.',
    BREAK_OUTSIDE          = '<break> not inside a loop.',
    MISS_LOOP_MAX          = 'Missing limit value of the loop.',
    UNEXPECT_LFUNC_NAME    = 'Local function can only use identifiers as name.',
    INDEX_IN_FUNC_NAME     = 'The `[name]` form cannot be used in the name of a named function.',
    ARGS_AFTER_DOTS        = '`...` should be the last arg.',
    BLOCK_AFTER_ELSE       = 'Unexpected block after `else`.',
    REDEFINED_LABEL        = 'Label `{code}` already defined.',
    NO_VISIBLE_LABEL       = 'No visible label `{code}`.',
    JUMP_LOCAL_SCOPE       = 'Jump into the scope of local `{loc}`.',
    MULTI_ATTRIBUTE        = 'Does not support multi attributes.',
    UNKNOWN_ATTRIBUTE      = 'Local attribute should be `const` or `close`.',
    LOCAL_LIMIT            = 'Only 200 active local variables and upvalues can exist at the same time.',
    MISS_SPACE_BETWEEN     = 'Spaces must be left between symbols.',
    SET_CONST              = 'Assignment to const variable.',
    EXP_IN_ACTION          = 'Unexpected <exp>.',
    ERR_ESC_DEC            = 'Decimal escape must be between {min} and {max}.',
    MISS_ESC_X             = 'Should be 2 hexadecimal digits.',
    ERR_ESC                = 'Invalid escape sequence.',
    MUST_X16               = 'Should be hexadecimal digits.',
    UTF8_SMALL             = 'At least 1 hexadecimal digit.',
    UTF8_MAX               = 'Should be between {min} and {max}.',
    NESTING_LONG_MARK      = 'Nesting of `[[...]]` is not allowed in Lua 5.1.',
    GLOBAL_NOT_DECLARED    = 'Variable `{code}` is not declared.',
    UNEXPECT_DOTS          = 'Cannot use `...` outside a vararg function.',
}

---@param err LuaParser.Node.Error
---@return string
local function buildMessage(err)
    local message = messages[err.errorCode] or 'Unknown syntax error.'
    local context = { code = err.code }
    local extra = err.extra
    if extra then
        for k, v in pairs(extra) do
            if context[k] == nil then
                context[k] = v
            end
        end
    end
    if not context.symbol then
        context.symbol = err.code
    end
    return (message:gsub('{(%w+)}', function (key)
        local value = context[key]
        if value == nil then
            return ''
        end
        return tostring(value)
    end))
end

---@param err LuaParser.Node.Error
---@param uri Uri
---@param text string
---@return Feature.Diagnostic.Related[]?
local function buildRelated(err, uri, text)
    local extra = err.extra
    if not extra then
        return nil
    end
    local related = {}
    local function push(start, finish, message)
        related[#related+1] = {
            uri     = uri,
            start   = start,
            finish  = finish,
            message = message or text:sub(start + 1, finish),
        }
    end
    if err.errorCode == 'MISS_END' and extra.start then
        push(extra.start, extra.finish, '`end` expected')
    elseif extra.related and extra.related.start then
        push(extra.related.start, extra.related.finish)
    elseif err.errorCode == 'REDEFINED_LABEL' and extra.start then
        push(extra.start, extra.finish, 'previous definition')
    elseif err.errorCode == 'JUMP_LOCAL_SCOPE' and extra.start then
        push(extra.start, extra.finish)
    end
    if #related == 0 then
        return nil
    end
    return related
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function syntaxProvider(param, callback)
    local errors = param.errors
    if #errors == 0 then
        return
    end

    local uri  = param.uri
    local text = param.document.text

    local delayer = ls.task.newThrottledDelayer(500)
    for _, err in ipairs(errors) do
        delayer:delay()
        callback {
            code    = err.errorCode:lower():gsub('_', '-'),
            level   = ls.spec.DiagnosticSeverity.Error,
            start   = err.start,
            finish  = err.finish,
            message = buildMessage(err),
            data    = 'syntax',
            related = buildRelated(err, uri, text),
        }
    end
end

ls.feature.provider.diagnostic(syntaxProvider)

return {
    messages = messages,
}
