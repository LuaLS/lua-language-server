local util = ls.feature.completionUtil

---@param expr string
---@return string
local function normalizeTypeExpr(expr)
    return util.trim(expr:gsub('%?$', ''))
end

---@param aliases table<string, string>
---@param typeExpr string
---@param inTableArg boolean
---@return string
local function resolveEnumTypeExpr(aliases, typeExpr, inTableArg)
    local expr = normalizeTypeExpr(typeExpr)
    if inTableArg then
        expr = normalizeTypeExpr(expr:gsub('%[%]$', ''))
    end
    local visited = {}
    while aliases[expr] and not visited[expr] do
        visited[expr] = true
        expr = normalizeTypeExpr(aliases[expr])
    end
    return expr
end

---@param text string
---@param aliasName string
---@return string?
local function findAliasExprInText(text, aliasName)
    local lines = {}
    local inAlias = false
    for line in text:gmatch('[^\r\n]+') do
        local name, def = line:match('^%s*%-%-%-%s*@alias%s+([%w_%.]+)%s*(.-)%s*$')
        if name then
            inAlias = (name == aliasName)
            if inAlias and def and util.trim(def) ~= '' then
                return util.trim(def)
            end
        elseif inAlias then
            local item = line:match('^%s*%-%-%-%s*|%s*(.-)%s*$')
            if item then
                item = util.trim((item:gsub('%s*#.*$', '')))
                if item ~= '' then
                    lines[#lines+1] = item
                end
            else
                break
            end
        end
    end
    if #lines > 0 then
        return table.concat(lines, ' | ')
    end
    return nil
end

---@param text string
---@param aliases table<string, string>
---@param typeExpr string
---@param inTableArg boolean
---@return string
local function resolveEnumTypeExprFromText(text, aliases, typeExpr, inTableArg)
    local expr = normalizeTypeExpr(typeExpr)
    if inTableArg then
        expr = normalizeTypeExpr(expr:gsub('%[%]$', ''))
    end
    local visited = {}
    while not visited[expr] do
        visited[expr] = true
        local nextExpr = aliases[expr] or findAliasExprInText(text, expr)
        if not nextExpr then
            break
        end
        expr = normalizeTypeExpr(nextExpr)
    end
    return expr
end

---@param text string
---@param textOffset integer
---@return string?
local function inferEnumTypeFromTypedTableLiteral(text, textOffset)
    local left = text:sub(1, textOffset)
    local varName = left:match('local%s+([%w_]+)%s*=%s*{[^{}]*$')
    if not varName then
        return nil
    end
    local escapedName = varName:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
    local typeExpr
    for t in left:gmatch('%-%-%-@type%s+([^\r\n]+)%s*\r?\n%s*local%s+' .. escapedName .. '%s*=') do
        typeExpr = util.trim(t)
    end
    if not typeExpr then
        return nil
    end
    local elem = typeExpr:match('^(.-)%s*%[%]$')
    if elem then
        return util.trim(elem)
    end
    elem = typeExpr:match('^table%s*<%s*string%s*,%s*(.-)%s*>$')
    if elem then
        return util.trim(elem)
    end
    return nil
end

local parseFunParams
local extractParamType

---@param funType string
---@return string[]
parseFunParams = function (funType)
    local s = funType:match('^fun%s*%((.*)%)')
    if not s then
        return {}
    end
    local params = {}
    local depth = 0
    local startPos = 1
    for i = 1, #s do
        local ch = s:sub(i, i)
        if ch == '(' then
            depth = depth + 1
        elseif ch == ')' then
            if depth > 0 then
                depth = depth - 1
            end
        elseif ch == ',' and depth == 0 then
            params[#params+1] = util.trim(s:sub(startPos, i - 1))
            startPos = i + 1
        end
    end
    local tail = util.trim(s:sub(startPos))
    if tail ~= '' then
        params[#params+1] = tail
    end
    return params
end

---@param paramDef string
---@return string?
extractParamType = function (paramDef)
    return util.trim((paramDef:match('^[%w_%.]+%s*:%s*(.+)$') or paramDef))
end

---@param text string
---@param rawFnName string
---@param argIndex integer
---@param isMethodCall boolean
---@return string?
local function inferArgTypeFromOverloads(text, rawFnName, argIndex, isMethodCall)
    local methodName = rawFnName:match('([%w_]+)$')
    if not methodName then
        return nil
    end
    local mappedArgIndex = isMethodCall and (argIndex + 1) or argIndex

    local pos = 1
    while true do
        local fnPos, fnEnd, fnDecl = text:find('()function%s+([%w_%.:]+)%s*%(', pos)
        if not fnPos then
            break
        end
        if fnDecl and fnDecl:match('[%.:]' .. methodName .. '$') then
            local near = text:sub(math.max(1, fnPos - 600), fnPos)
            local lastOverload
            for typeExpr in near:gmatch('%-%-%-@overload%s+(fun%b())') do
                lastOverload = typeExpr
            end
            if lastOverload then
                local params = parseFunParams(lastOverload)
                local pType = extractParamType(params[mappedArgIndex])
                if pType and pType ~= '' then
                    return pType
                end
            end
        end
        pos = fnEnd + 1
    end

    return nil
end

---@param text string
---@param rawFnName string
---@param argIndex integer
---@param isMethodCall boolean
---@return string?
local function inferArgTypeFromTypedFunctionVar(text, rawFnName, argIndex, isMethodCall)
    local varName = rawFnName:match('([%w_]+)$')
    if not varName then
        return nil
    end
    local mappedArgIndex = isMethodCall and (argIndex + 1) or argIndex
    for funType, localName in text:gmatch('%-%-%-@type%s+(fun%b())%s*\r?\n%s*local%s+([%w_]+)') do
        if localName == varName then
            local params = parseFunParams(funType)
            local pType = extractParamType(params[mappedArgIndex])
            if pType and pType ~= '' then
                return pType
            end
        end
    end
    return nil
end

---@param t string?
---@return string?
local function normalizeQuotedLiteralType(t)
    if not t or t == '' then
        return nil
    end
    t = util.trim(t)
    if #t >= 2 then
        local first = t:sub(1, 1)
        local last = t:sub(-1)
        if (first == '"' and last == '"') or (first == '\'' and last == '\'') then
            t = t:sub(2, -2)
        end
    end
    if #t >= 2 and t:sub(1, 1) == '"' and t:sub(-1) == '"' then
        t = t:sub(2, -2)
    end
    return t
end

---@param text string
---@param typeExpr string?
---@return string?
local function resolveEventLiteral(text, typeExpr)
    if not typeExpr or typeExpr == '' then
        return nil
    end
    local aliasExpr = findAliasExprInText(text, normalizeTypeExpr(typeExpr))
    if aliasExpr then
        local literals = util.extractEnumLiterals(aliasExpr)
        if #literals > 0 then
            return normalizeQuotedLiteralType(literals[1])
        end
    end
    return normalizeQuotedLiteralType(typeExpr)
end

---@param literal string
---@return string
local function normalizeEnumLiteral(literal)
    if literal:match('^"\'.+\'"$') then
        return literal:sub(2, -2)
    end
    return literal
end

---@param text string
---@param fnName string
---@param argHead string
---@param argIndex integer
---@param isMethodCall boolean
---@return string?
local function inferFunctionArgTypeFromFieldOverloads(text, fnName, argHead, argIndex, isMethodCall)
    local mappedArgIndex = isMethodCall and (argIndex + 1) or argIndex
    if mappedArgIndex < 2 then
        return nil
    end
    local fieldName = fnName:match('[%.:]([%w_]+)$')
    if not fieldName then
        return nil
    end
    local firstArg = normalizeQuotedLiteralType(argHead:match('["\'](.-)["\']'))

    local fallback
    for line in text:gmatch('[^\r\n]+') do
        local typeExpr = line:match('^%s*%-%-%-%s*@field%s+' .. fieldName .. '%s+(.+)$')
        if typeExpr and typeExpr:match('^fun%s*%(') then
            local params = parseFunParams(typeExpr)
            local hasSelfParam = params[1] and params[1]:match('^%s*self%s*:') ~= nil
            local eventArgIndex = (isMethodCall or hasSelfParam) and 2 or 1
            local p1Type = extractParamType(params[eventArgIndex])
            local pNType = extractParamType(params[mappedArgIndex])
            if pNType and pNType:match('^fun%s*%(') then
                fallback = fallback or pNType
                if firstArg and resolveEventLiteral(text, p1Type) == firstArg then
                    return pNType
                end
            end
        end
    end
    return fallback
end

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local rawFnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not rawFnName then
        return
    end
    local isMethodCall = rawFnName:find(':', 1, true) ~= nil
    local fnName = rawFnName
    fnName = fnName:gsub(':', '.')

    local argIndex = 1
    for _ in argHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local pType
    local fromFieldOverload = false

    local params, paramTypes = util.findFunctionDocParamTypes(text, fnName)
    if params and paramTypes then
        local mappedArgIndex = argIndex
        if isMethodCall then
            mappedArgIndex = mappedArgIndex + 1
        end
        local pName = params[mappedArgIndex]
        if pName then
            pType = paramTypes[pName]
        end
    end
    if not pType then
        pType = inferArgTypeFromOverloads(text, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferArgTypeFromTypedFunctionVar(text, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferFunctionArgTypeFromFieldOverloads(text, rawFnName, argHead, argIndex, isMethodCall)
        fromFieldOverload = pType ~= nil
    end

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

    if fromFieldOverload then
        action.push {
            label = pType,
            kind = ls.spec.CompletionItemKind.Function,
        }
        return
    end

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
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local rawFnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not rawFnName then
        return
    end
    local isMethodCall = rawFnName:find(':', 1, true) ~= nil
    local fnName = rawFnName
    fnName = fnName:gsub(':', '.')

    local argIndex = 1
    for _ in argHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local params, paramTypes = util.findFunctionDocParamTypes(text, fnName)
    local pType
    if params and paramTypes then
        local mappedArgIndex = argIndex
        if isMethodCall then
            mappedArgIndex = mappedArgIndex + 1
        end
        local pName = params[mappedArgIndex]
        if pName then
            pType = paramTypes[pName]
        end
    end
    if not pType then
        pType = inferArgTypeFromOverloads(text, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferArgTypeFromTypedFunctionVar(text, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        return
    end

    local inTableArg = argHead:find('{', 1, true) ~= nil
    if not inTableArg and normalizeTypeExpr(pType):match('%[%]$') then
        action.skip()
        return
    end
    local aliases = util.collectAliases(text)
    pType = resolveEnumTypeExprFromText(text, aliases, pType, inTableArg)

    local enums = util.extractEnumLiterals(pType)
    if #enums == 0 then
        return
    end

    action.skip()

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local inDoubleQuote = left:match('"[^"\n]*$') ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and (inSingleQuote or inDoubleQuote) then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
        }
        item.textEdit = {
            start = editStart,
            finish = editFinish,
            newText = label,
        }
        action.push(item)
        ::continue::
    end
end, 15)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local inferredType = inferEnumTypeFromTypedTableLiteral(text, textOffset)
    if not inferredType then
        return
    end

    local aliases = util.collectAliases(text)
    local resolvedType = resolveEnumTypeExprFromText(text, aliases, inferredType, true)
    local enums = util.extractEnumLiterals(resolvedType)
    if #enums == 0 then
        return
    end

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and inSingleQuote then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    action.skip()
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        ---@type any
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = {
                start = editStart,
                finish = editFinish,
                newText = label,
            },
        }
        action.push(item)
        ::continue::
    end
end, 15)
