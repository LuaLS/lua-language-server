local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset)
    local left = text:sub(1, textOffset)
    local currentClass = left:match('%-%-%-@class%s+([%w_%.]+)%s*:%s*$')
    if not currentClass then
        return
    end

    action.skip()
    local names = param.scope.vm:getLuaDocTypes()
    for name, kind in pairs(names) do
        if name ~= currentClass then
            action.push {
                label = name,
                kind = kind,
            }
        end
    end
end, 22)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset)
    local _, lineLeft = util.getLineLeft(text, textOffset)
    if not lineLeft:match('^%s*%-%-%-@type%s*$') then
        return
    end

    action.skip()
    local names = param.scope.vm:getLuaDocTypes()
    for name, kind in pairs(names) do
        action.push {
            label = name,
            kind = kind,
        }
    end
end, 22)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset)
    local lineStart, lineLeft = util.getLineLeft(text, textOffset)
    local left = text:sub(1, textOffset)
    local leftLine = left:match('[^\r\n]*$') or ''

    local tagPrefix = leftLine:match('^%s*%-%-%-@([%w_]*)$')
    if tagPrefix then
        action.skip()
        for _, tag in ipairs(util.LUADOC_TAGS) do
            if tag:sub(1, #tagPrefix) == tagPrefix then
                action.push {
                    label = tag,
                    kind = ls.spec.CompletionItemKind.Event,
                }
            end
        end
        return
    end

    local classExtendsCurrent = left:match('%-%-%-@class%s+([%w_%.]+)%s*:%s*$')

    local wordStart = lineLeft:find('([%w_%.]+)$')
    local typePrefix
    local head
    if wordStart then
        typePrefix = lineLeft:sub(wordStart)
        head = lineLeft:sub(1, wordStart - 1)
    else
        typePrefix = ''
        head = lineLeft
    end

    local inTypeRef
    local currentClass
    if classExtendsCurrent then
        inTypeRef = true
        currentClass = classExtendsCurrent
    end

    local typeLinePrefix = leftLine:match('^%s*%-%-%-@type%s*([%w_%.]*)$')
    if typeLinePrefix ~= nil then
        inTypeRef = true
        typePrefix = typeLinePrefix
    end
    local paramLineTypePrefix = leftLine:match('^%s*%-%-%-@param%s+[%w_]+%s*([%w_%.]*)$')
    if paramLineTypePrefix ~= nil then
        inTypeRef = true
        typePrefix = paramLineTypePrefix
    end

    if head:match('^%s*%-%-%-@class%s+[%w_%.]+%s*:%s*$') then
        inTypeRef = true
        currentClass = lineLeft:match('^%s*%-%-%-@class%s+([%w_%.]+)%s*:')
    elseif head:match('^%s*%-%-%-@type%s+.*[|`%s]$') or head:match('^%s*%-%-%-@type%s*$') then
        inTypeRef = true
    elseif head:match('^%s*%-%-%-@param%s+[%w_]+%s+.*[|`%s]$') or head:match('^%s*%-%-%-@param%s+[%w_]+%s*$') then
        inTypeRef = true
    elseif head:match('^%s*%-%-%-@see%s*$') then
        inTypeRef = true
    end

    if lineLeft:match('^%s*%-%-%-@type%s*$') then
        inTypeRef = true
        typePrefix = ''
    end
    if lineLeft:match('^%s*%-%-%-@param%s+[%w_]+%s*$') then
        inTypeRef = true
        typePrefix = ''
    end

    local catSource = param.inLuaDoc and util.getLuadocCatSource(param) or nil
    local missCatName = util.hasMissCatNameAtCursor(param)
    if missCatName then
        inTypeRef = true
        currentClass = currentClass or util.getCurrentClassNameFromSources(param)
    end

    if not inTypeRef and not catSource and not missCatName then
        return
    end

    action.skip()
    local names = param.scope.vm:getLuaDocTypes()
    local absWordStart = lineStart + wordStart - 1
    local displayWordStart = util.toDisplayOffset(param, absWordStart)
    for name, kind in pairs(names) do
        if name ~= currentClass and name:sub(1, #typePrefix) == typePrefix then
            local item = {
                label = name,
                kind = kind,
            }
            if name:find('[^%w_]') then
                item.textEdit = {
                    start = displayWordStart,
                    finish = param.offset,
                    newText = name,
                }
            end
            action.push(item)
        end
    end
end, 20)

---@param argHead string
---@return integer
local function countArgsOutsideTables(argHead)
    local count = 1
    local braceDepth = 0
    for i = 1, #argHead do
        local ch = argHead:sub(i, i)
        if ch == '{' then
            braceDepth = braceDepth + 1
        elseif ch == '}' then
            if braceDepth > 0 then
                braceDepth = braceDepth - 1
            end
        elseif ch == ',' and braceDepth == 0 then
            count = count + 1
        end
    end
    return count
end

---@param argHead string
---@return string? content
---@return integer braceDepth
local function currentTableContent(argHead)
    local braceDepth = 0
    local startPos
    for i = 1, #argHead do
        local ch = argHead:sub(i, i)
        if ch == '{' then
            braceDepth = braceDepth + 1
            if braceDepth == 1 then
                startPos = i
            end
        elseif ch == '}' and braceDepth > 0 then
            braceDepth = braceDepth - 1
        end
    end
    if not startPos or braceDepth <= 0 then
        return nil, braceDepth
    end
    return argHead:sub(startPos + 1), braceDepth
end

---@param pType string
---@return string[]
local function extractInlineTableTypeKeys(pType)
    local keys = {}
    local body = pType:match('^%s*{(.-)}%s*%??%s*$')
    if not body then
        return keys
    end
    local seen = {}
    for part in body:gmatch('[^,]+') do
        local name = util.trim(part):match('^([%w_]+)%s*%??%s*:')
        if name and not seen[name] then
            seen[name] = true
            keys[#keys+1] = name
        end
    end
    return keys
end

---@param text string
---@param textOffset integer
---@return string?
local function findTypedLocalTableClassName(text, textOffset)
    local left = text:sub(1, textOffset)
    local varName = left:match('local%s+([%w_]+)%s*=%s*{[^{}]*$')
    if not varName then
        return nil
    end
    local escapedName = varName:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
    local classType
    for t in left:gmatch('%-%-%-@type%s+([^\r\n]+)%s*\r?\n%s*local%s+' .. escapedName .. '%s*=') do
        classType = util.trim(t)
    end
    if not classType then
        return nil
    end
    return classType:match('^([%w_%.]+)%??$')
end

---@param text string
---@param fnName string
---@return string?
local function findOverloadFirstParamType(text, fnName)
    local escaped = fnName:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
    local fnStart = text:find('local%s+function%s+' .. escaped .. '%s*%(')
    if not fnStart then
        fnStart = text:find('function%s+' .. escaped .. '%s*%(')
    end
    if not fnStart then
        return nil
    end
    local docHead = text:sub(1, fnStart)
    local result
    for overloadArgs in docHead:gmatch('%-%-%-@overload%s+fun%s*%((.-)%)') do
        local paramType = util.trim(overloadArgs):match('^[%w_]+%s*:%s*(.+)$')
        if paramType then
            result = util.trim(paramType)
        end
    end
    return result
end

-- `f({<??>})` 属性补全：根据 `---@param x Class` 推导 Class 字段
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset)
    local left = text:sub(1, textOffset)

    local fnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    local callWithoutParens = false
    if not fnName then
        fnName, argHead = left:match('([%w_%.:]+)%s*({[^()]*)$')
        callWithoutParens = fnName ~= nil
    end
    if not fnName then
        return
    end

    local tableContent, braceDepth = currentTableContent(argHead)
    if tableContent and braceDepth > 1 then
        action.skip()
        return
    end
    if not tableContent or braceDepth ~= 1 then
        return
    end

    -- `f({aaa <??>})` 这种非法键位不做补全
    if tableContent:match('^%s*[%w_]+%s+$') then
        return
    end

    fnName = fnName:gsub(':', '.')
    local argIndex = callWithoutParens and 1 or countArgsOutsideTables(argHead)

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
    local propNames = {}
    local typeName = pType:match('^([%w_%.]+)%??$')
    if typeName then
        local typeNode = param.scope.rt.type(typeName)
        if not typeNode or not typeNode:isClassLike() then
            return
        end

        local expectValue = typeNode.expectValue
        if not expectValue or not expectValue.keys then
            return
        end
        for _, keyNode in ipairs(expectValue.keys) do
            if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
                propNames[#propNames+1] = keyNode.literal
            end
        end
    else
        propNames = extractInlineTableTypeKeys(pType)
        if #propNames == 0 then
            return
        end
    end

    local used = {}
    local allNames = {}
    for name in tableContent:gmatch('([%w_]+)%s*=') do
        used[name] = true
    end

    for _, name in ipairs(propNames) do
        allNames[name] = true
    end

    local tailIdent = tableContent:match('([%w_]+)%s*$')
    if  tailIdent
    and not tableContent:match('[=,]%s*$')
    and allNames[tailIdent] then
        return
    end

    local word = tableContent:match('([%w_]*)$') or ''

    table.sort(propNames, ls.util.stringLess)

    action.skip()
    for _, name in ipairs(propNames) do
        if not used[name] and (word == '' or name:sub(1, #word) == word) then
            action.push {
                label = name,
                kind = ls.spec.CompletionItemKind.Property,
            }
        end
    end
end, 23)

-- `new 'A' { <??> }` 这类构造风格调用，从 overload 的内联表参数补属性
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset)
    local left = text:sub(1, textOffset)

    local fnName, tableContent = left:match('([%w_%.:]+)%s+["\'][^"\'\r\n]*["\']%s*{([^{}]*)$')
    if not fnName then
        return
    end

    local pType = findOverloadFirstParamType(text, fnName:gsub(':', '.'))
    if not pType then
        return
    end

    local propNames = extractInlineTableTypeKeys(pType)
    if #propNames == 0 then
        return
    end

    local used = {}
    for name in tableContent:gmatch('([%w_]+)%s*=') do
        used[name] = true
    end
    local word = tableContent:match('([%w_]*)$') or ''

    action.skip()
    for _, name in ipairs(propNames) do
        if not used[name] and (word == '' or name:sub(1, #word) == word) then
            action.push {
                label = name,
                kind = ls.spec.CompletionItemKind.Property,
            }
        end
    end
end, 18)

-- `---@type A local t = { <??> }` 属性补全
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset)
    local left = text:sub(1, textOffset)
    if not left:match('local%s+[%w_]+%s*=%s*{[^{}]*$') then
        return
    end

    local className = findTypedLocalTableClassName(text, textOffset)
    if not className then
        return
    end

    local typeNode = param.scope.rt.type(className)
    if not typeNode or not typeNode:isClassLike() then
        return
    end
    local expectValue = typeNode.expectValue
    if not expectValue or not expectValue.keys then
        return
    end
    local fieldTable = typeNode.fieldTable or expectValue
    local rt = param.scope.rt

    local used = {}
    for name in left:gmatch('([%w_]+)%s*=') do
        used[name] = true
    end

    local items = {}
    local pushed = {}
    for _, keyNode in ipairs(expectValue.keys) do
        if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
            local name = keyNode.literal
            ---@cast name string
            if not used[name] and not pushed[name] then
                pushed[name] = true
                local fieldKey = rt.nodeKey(keyNode)
                local field = fieldTable.fieldMap and fieldTable.fieldMap[fieldKey] or nil
                local label = name
                if field and field.optional then
                    label = label .. '?'
                end
                items[#items+1] = {
                    label = label,
                    name = name,
                    optional = field and field.optional == true or false,
                }
            end
        end
    end
    if #items == 0 then
        return
    end

    table.sort(items, function (a, b)
        if a.optional ~= b.optional then
            return not a.optional
        end
        return ls.util.stringLess(a.name, b.name)
    end)

    action.skip()
    for _, item in ipairs(items) do
        action.push {
            label = item.label,
            kind = ls.spec.CompletionItemKind.Property,
        }
    end
end, 18)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset)
    local left = text:sub(1, textOffset)
    local prefix = left:match('%-%-%-@param%s+([%w_]*)%s*$')
    if prefix == nil then
        return
    end

    local document = param.scope:getDocument(param.uri)
    local params, isMethod = util.findNextFunctionParams(document, textOffset)
    if #params == 0 then
        return
    end

    action.skip()

    local filtered = {}
    for _, name in ipairs(params) do
        if name:sub(1, #prefix) == prefix then
            filtered[#filtered+1] = name
        end
    end
    if #filtered == 0 then
        return
    end

    if prefix == '' then
        action.push {
            label = table.concat(filtered, ', '),
            kind = ls.spec.CompletionItemKind.Snippet,
            insertText = util.buildParamSnippetText(filtered),
        }
        if isMethod then
            action.push {
                label = 'self',
                kind = ls.spec.CompletionItemKind.Interface,
            }
        end
    end

    for _, name in ipairs(filtered) do
        action.push {
            label = name,
            kind = ls.spec.CompletionItemKind.Interface,
        }
    end
end, 21)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset)
    local _, lineLeft = util.getLineLeft(text, textOffset)
    local prefix = lineLeft:match('^%s*%-%-%-@param%s+([%w_]*)$')
    if prefix == nil then
        return
    end

    action.skip()

    local document = param.scope:getDocument(param.uri)
    local params, isMethod = util.findNextFunctionParams(document, textOffset)
    local filtered = {}
    for _, name in ipairs(params) do
        if name:sub(1, #prefix) == prefix then
            filtered[#filtered+1] = name
        end
    end

    if #filtered > 0 and prefix == '' then
        action.push {
            label = table.concat(filtered, ', '),
            kind = ls.spec.CompletionItemKind.Snippet,
            insertText = util.buildParamSnippetText(filtered),
        }
    end

    if isMethod and prefix == '' then
        action.push {
            label = 'self',
            kind = ls.spec.CompletionItemKind.Interface,
        }
    end

    for _, name in ipairs(filtered) do
        action.push {
            label = name,
            kind = ls.spec.CompletionItemKind.Interface,
        }
    end
end, 20)

ls.feature.provider.completion(function (param, action)
    local word = param.scanner:getWordBack()
    local docParams = util.findDocParamsBeforeCurrentFunction(param.sources, param.sourceTextOffset)
    if #docParams == 0 then
        return
    end

    action.skip()

    local matched = {}
    for _, name in ipairs(docParams) do
        if word == '' or name:sub(1, #word) == word then
            matched[#matched+1] = name
        end
    end

    if #matched > 0 then
        action.push {
            label = table.concat(matched, ', '),
            kind = ls.spec.CompletionItemKind.Snippet,
        }
    end
    for _, name in ipairs(matched) do
        action.push {
            label = name,
            kind = ls.spec.CompletionItemKind.Interface,
        }
    end
end, 20)
