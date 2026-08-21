local guide = require 'parser.guide'
local util = ls.feature.completionUtil

---@param param Feature.Completion.Param
---@return boolean
local function isAfterWordPosition(param)
    local text = param.scanner.text
    local pos = param.scanner.offset
    while pos >= 1 do
        local ch = text:sub(pos, pos)
        if ch ~= ' ' and ch ~= '\t' then
            break
        end
        pos = pos - 1
    end
    if pos < 1 then
        return false
    end
    local ch = text:sub(pos, pos)
    return ls.guide.isWordChar(ch)
        or ch == '.'
        or ch == ':'
end

---@param param Feature.Completion.Param
---@return boolean
local function isEmptyRhsCompletionPosition(param)
    local text = param.scanner.text
    local offset = param.realTextOffset or param.textOffset or util.toTextOffset(text, param.offset)
    if offset <= 1 then
        return false
    end

    local pos = offset
    while pos >= 1 do
        local ch = text:sub(pos, pos)
        if ch ~= ' ' and ch ~= '\t' and ch ~= '\n' and ch ~= '\r' then
            break
        end
        pos = pos - 1
    end
    if pos < 1 or text:sub(pos, pos) ~= '=' then
        return false
    end
    if pos > 1 and text:sub(pos - 1, pos - 1) == '=' then
        return false
    end

    local lineStart = offset
    while lineStart > 1 do
        local ch = text:sub(lineStart - 1, lineStart - 1)
        if ch == '\n' or ch == '\r' then
            break
        end
        lineStart = lineStart - 1
    end
    local lineLeft = text:sub(lineStart, offset)
    if lineLeft:match('^%s*local%s+[%w_,%s]+=%s*$') then
        return true
    end
    return false
end

ls.feature.provider.completion(function (param, action)
    if param.inComment or param.inLuaDoc or param.inString then
        return
    end

    local word = util.getCompletionWord(param)
    if word == '' then
        return
    end

    if not util.isStatementPosition(param) then
        return
    end

    local matches = {}
    for _, kw in ipairs(util.LUA_KEYWORDS) do
        if kw:sub(1, #word) == word then
            matches[#matches+1] = kw
        end
    end
    table.sort(matches, ls.util.stringLess)

    for _, kw in ipairs(matches) do
        action.push {
            label = kw,
            kind = ls.spec.CompletionItemKind.Keyword,
        }
    end
end)

ls.feature.provider.completion(function (param, action)
    if param.inComment or param.inLuaDoc or param.inString then
        return
    end

    if isEmptyRhsCompletionPosition(param) then
        return
    end

    ---@type any
    local source = param.sources[1]
    local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset)

    if not source then
        local document = param.scope:getDocument(param.uri)
        local ast = document and document.ast
        if ast and ast.main then
            local block = ast.main
            local function findDeepest(b)
                for _, child in ipairs(b.childs) do
                    if child.isBlock and child.start <= textOffset and textOffset <= child.finish then
                        block = child
                        findDeepest(child)
                        return
                    end
                end
            end
            findDeepest(ast.main)
            source = {
                parentBlock = block,
            }
            ---@cast source LuaParser.Node.Base
        end
    end
    if not source then
        return
    end

    local word = util.getCompletionWord(param)
    if word == '' and isAfterWordPosition(param) then
        return
    end

    local locals = guide.getVisibleLocals(source, textOffset)
    local entries = {}
    for _, loc in ipairs(locals) do
        local name = loc.id
        if name == '_ENV' then
            goto continue
        end
        if loc.start <= textOffset and loc.finish >= textOffset then
            goto continue
        end
        if word == '' or ls.util.stringSimilar(word, name, true) then
            local var = param.scope.vm:getVariable(loc)
            entries[#entries+1] = {
                name = name,
                var = var,
            }
        end
        ::continue::
    end
    table.sort(entries, function (a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    for _, entry in ipairs(entries) do
        local value = entry.var and entry.var.value or nil
        local funcs = util.collectFunctionNodes(value)

        if #funcs == 0 then
            action.push {
                label = entry.name,
                kind = ls.spec.CompletionItemKind.Variable,
            }
            goto continue
        end

        local usedLabel = {}
        for _, func in ipairs(funcs) do
            ---@cast func Node.Function
            local label, snippetText = util.buildFunctionSignature(entry.name, func)
            if not usedLabel[label] then
                usedLabel[label] = true
                action.push {
                    label = label,
                    kind = ls.spec.CompletionItemKind.Function,
                    insertText = entry.name,
                }
                action.push {
                    label = label,
                    kind = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText,
                }
            end
        end
        ::continue::
    end

end)

ls.feature.provider.completion(function (param, action)
    if param.inComment or param.inLuaDoc or param.inString then
        return
    end

    if isEmptyRhsCompletionPosition(param) then
        return
    end

    local source = param.sources[1]
    local word = util.getCompletionWord(param)

    if word == '' and isAfterWordPosition(param) then
        return
    end

    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end

    local shadowedByLocal = {}
    if source then
        local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset)
        for _, loc in ipairs(guide.getVisibleLocals(source, textOffset)) do
            shadowedByLocal[loc.id] = true
        end
    end

    local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset)
    local envLocal = guide.getEnvLocal(document.ast, textOffset)
    if not envLocal then
        return
    end
    local envVar = param.scope.vm:getVariable(envLocal)
    if not envVar then
        return
    end
    local childs = envVar:getChilds()
    if not childs then
        return
    end

    local matches = {}
    for name, var in pairs(childs) do
        if  type(name) == 'string'
        and not shadowedByLocal[name]
        and var:isDefined()
        and (word == '' or ls.util.stringSimilar(word, name, true)) then
            matches[#matches+1] = { name = name, var = var }
        end
    end
    table.sort(matches, function (a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    local unicodeName = param.scope.config:get(param.uri, 'Lua.runtime.unicodeName')

    local function literalKindOf(value)
        if not value then
            return ls.spec.CompletionItemKind.Field
        end
        if value.kind == 'value' then
            return ls.spec.CompletionItemKind.Enum
        end
        if value.kind == 'union' then
            for _, child in ipairs(value.values) do
                if child.kind == 'value' then
                    return ls.spec.CompletionItemKind.Enum
                end
            end
        end
        return ls.spec.CompletionItemKind.Field
    end

    local callSnippet = util.getCallSnippetMode(param)

    for _, item in ipairs(matches) do
        local value = item.var.value
        local funcs = util.collectFunctionNodes(value)

        local name = item.name
        local isIdent = guide.isLegalName(name)
        local isWideIdent = not isIdent and guide.isLegalName(name, true)
        if isIdent
        or (isWideIdent and unicodeName) then
            action.push {
                label = name,
                kind = literalKindOf(value),
            }
        elseif isWideIdent then
            local version = param.scope.config:get(param.uri, 'Lua.runtime.version')
            local envName = (version == 'Lua 5.1' or version == 'LuaJIT') and '_G' or '_ENV'
            action.push {
                label = name,
                kind  = literalKindOf(value),
                textEdit = {
                    start   = util.toDisplayOffset(param, textOffset - #word),
                    finish  = util.toDisplayOffset(param, textOffset),
                    newText = ('%s[%s]'):format(envName, ('%q'):format(name)),
                },
            }
        else
            local version = param.scope.config:get(param.uri, 'Lua.runtime.version')
            local envName = (version == 'Lua 5.1' or version == 'LuaJIT') and '_G' or '_ENV'
            local quoted = ("'%s'"):format(name)
            action.push {
                label = quoted,
                kind  = ls.spec.CompletionItemKind.Field,
                textEdit = {
                    start   = util.toDisplayOffset(param, textOffset - #word),
                    finish  = util.toDisplayOffset(param, textOffset),
                    newText = ('%s[%s]'):format(envName, quoted),
                },
            }
            goto continue
        end

        if #funcs == 0 then
            goto continue
        end

        local usedLabel = {}
        for _, func in ipairs(funcs) do
            ---@cast func Node.Function
            local label, snippetText = util.buildFunctionSignature(item.name, func)
            if not usedLabel[label] then
                usedLabel[label] = true
                action.push {
                    label = label,
                    kind = ls.spec.CompletionItemKind.Function,
                    insertText = callSnippet == 'Replace' and snippetText or item.name,
                }
                if callSnippet == 'Both' then
                    action.push {
                        label = label,
                        kind = ls.spec.CompletionItemKind.Snippet,
                        insertText = snippetText,
                    }
                end
            end
        end
        ::continue::
    end
end)
