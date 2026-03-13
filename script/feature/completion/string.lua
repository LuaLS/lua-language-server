local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local fnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not fnName then
        return
    end
    fnName = fnName:gsub(':', '.')

    local argIndex = 1
    for _ in argHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local params, paramTypes = util.findFunctionDocParamTypes(text, fnName)
    if not params or not paramTypes then
        return
    end
    local pName = params[argIndex]
    if not pName then
        return
    end

    local pType = paramTypes[pName]
    if not pType or not pType:match('^fun%s*%(') then
        return
    end

    local word = util.getCompletionWord(param)
    if word ~= '' and not (('function'):sub(1, #word) == word) then
        return
    end

    local args = pType:match('^fun%s*%((.-)%)') or ''
    local placeholders = {}
    local idx = 1
    for part in args:gmatch('[^,]+') do
        local name = util.trim(part):match('^([%w_]+)%s*:')
                  or util.trim(part):match('^([%w_]+)')
        if name and name ~= '...' then
            placeholders[#placeholders+1] = string.format('${%d:%s}', idx, name)
            idx = idx + 1
        end
    end

    local newText = string.format('function (%s)\n\t$0\nend', table.concat(placeholders, ', '))
    local editStart = util.toDisplayOffset(param, textOffset - #word)
    local editFinish = util.toDisplayOffset(param, textOffset)

    action.skip()

    ---@type any
    local functionTypeItem = {
        label = pType,
        kind = ls.spec.CompletionItemKind.Function,
        textEdit = {
            start = editStart,
            finish = editFinish,
            newText = newText,
        }
    }
    action.push(functionTypeItem)

    action.push {
        label = 'function',
        kind = ls.spec.CompletionItemKind.Keyword,
    }
    action.push {
        label = 'function ()',
        kind = ls.spec.CompletionItemKind.Snippet,
    }
end, 16)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local left = text:sub(1, param.offset)

    local fnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not fnName then
        return
    end
    fnName = fnName:gsub(':', '.')

    local argIndex = 1
    for _ in argHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local params, paramTypes = util.findFunctionDocParamTypes(text, fnName)
    if not params or not paramTypes then
        return
    end
    local pName = params[argIndex]
    if not pName then
        return
    end

    local pType = paramTypes[pName]
    if not pType then
        return
    end

    local aliases = util.collectAliases(text)
    if aliases[pType] then
        pType = aliases[pType]
    end

    local enums = util.extractEnumLiterals(pType)
    if #enums == 0 then
        return
    end

    action.skip()

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    for _, literal in ipairs(enums) do
        local label = literal
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        action.push {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
        }
    end
end, 15)
