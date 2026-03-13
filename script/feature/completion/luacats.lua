local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset, param)
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
    local textOffset = util.toTextOffset(text, param.offset, param)
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
    local textOffset = util.toTextOffset(text, param.offset, param)
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

    local catSource = util.getLuadocCatSource(param)
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
    for name, kind in pairs(names) do
        if name ~= currentClass and name:sub(1, #typePrefix) == typePrefix then
            local item = {
                label = name,
                kind = kind,
            }
            if name:find('[^%w_]') then
                item.textEdit = {
                    start = absWordStart,
                    finish = param.offset,
                    newText = name,
                }
            end
            action.push(item)
        end
    end
end, 20)

ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)
    local prefix = left:match('%-%-%-@param%s+([%w_]*)%s*$')
    if prefix == nil then
        return
    end

    local params, isMethod = util.findNextFunctionParams(text, textOffset)
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
    local textOffset = util.toTextOffset(text, param.offset, param)
    local _, lineLeft = util.getLineLeft(text, textOffset)
    local prefix = lineLeft:match('^%s*%-%-%-@param%s+([%w_]*)$')
    if prefix == nil then
        return
    end

    action.skip()

    local params, isMethod = util.findNextFunctionParams(text, textOffset)
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
    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)
    if  not left:match('function%s+[%w_%.:]*%s*%([^()%[%]{}\n]*$')
    and not left:match('function%s*%([^()%[%]{}\n]*$') then
        return
    end

    local word = param.scanner:getWordBack()
    local docParams = util.findDocParamsBeforeCurrentFunction(text, textOffset)
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
