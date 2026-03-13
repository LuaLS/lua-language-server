---@type Feature.Provider<Feature.Completion.Param>
local providers = ls.feature.helper.providers()
require 'feature.text-scanner'

---@class Feature.Completion.Param
---@field uri Uri
---@field offset integer
---@field textOffset integer
---@field scope Scope
---@field sources LuaParser.Node.Base[]
---@field scanner Feature.TextScanner

---@param uri Uri
---@param offset integer
---@return LSP.CompletionItem[]
ls.feature.completion = function (uri, offset)
    if not offset then
        return {}
    end

    local scope = ls.scope.find(uri)
    if not scope then
        return {}
    end

    local document = scope:getDocument(uri)
    if not document then
        return {}
    end

    local file = ls.file.get(uri)
    if not file then
        return {}
    end

    local text = file:getText()
    if not text then
        return {}
    end

    local textOffset = offset
    if textOffset > #text then
        if textOffset >= 10000 then
            local row = textOffset // 10000
            local col = textOffset % 10000
            textOffset = document.positionConverter:positionToOffset(row, col)
        else
            textOffset = #text
        end
    end

    local sources = document:findSources(textOffset) or {}
    if #sources == 0 and textOffset > 0 then
        sources = document:findSources(textOffset - 1) or {}
    end

    local scanner = New 'Feature.TextScanner' (text, textOffset)

    local word = scanner:getWordBack()
    if word == '' and textOffset > 0 then
        local leftChar = text:sub(textOffset - 1, textOffset - 1)
        local rightChar = text:sub(textOffset, textOffset)
        if  leftChar == '_'
        or (leftChar >= 'a' and leftChar <= 'z')
        or (leftChar >= 'A' and leftChar <= 'Z')
        or (leftChar >= '0' and leftChar <= '9') then
            if rightChar ~= '' and rightChar ~= ' ' and rightChar ~= '\t' and rightChar ~= '\n' and rightChar ~= '\r' then
                goto skipAdjustScanner
            end
            scanner = New 'Feature.TextScanner' (text, textOffset - 1)
            word = scanner:getWordBack()
            textOffset = textOffset - 1
        end
    end
    ::skipAdjustScanner::

    local function hasDocParamBeforeCurrentFunction()
        local left = text:sub(1, textOffset)
        local funcStart = left:match('.*()function%s+[%w_%.:]*%s*%([^()%[%]{}\n]*$')
                       or left:match('.*()function%s*%([^()%[%]{}\n]*$')
        if not funcStart then
            return false
        end
        local from = math.max(1, funcStart - 600)
        local near = left:sub(from, funcStart)
        return near:match('%-%-%-@param%s+[%w_]+') ~= nil
    end

    if word == '' then
        local lineStart = textOffset
        while lineStart > 0 do
            local c = text:sub(lineStart, lineStart)
            if c == '\n' or c == '\r' then
                break
            end
            lineStart = lineStart - 1
        end
        local lineLeft = text:sub(lineStart + 1, textOffset)
        if lineLeft:match('^%s*local%s+function%s+') or lineLeft:match('^%s*function%s+') then
            local left = text:sub(1, textOffset)
            if  left:match('function%s+[%w_%.:]+%s*%([^()%[%]{}\n]*$')
            or  left:match('function%s*%([^()%[%]{}\n]*$') then
                if not hasDocParamBeforeCurrentFunction() then
                    return {}
                end
            end
        end
    end

    local param = {
        uri = uri,
        offset = offset,
        textOffset = textOffset,
        scope = scope,
        sources = sources,
        scanner = scanner,
    }

    return providers.runner(param)
end

---@param callback fun(param: Feature.Completion.Param, action: Feature.ProviderActions<LSP.CompletionItem>)
---@param priority integer?
---@return fun() disposable
ls.feature.provider.completion = function (callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

local util = {}
ls.feature.completionUtil = util

util.LUA_KEYWORDS = {
    'and', 'break', 'do', 'else', 'elseif', 'end',
    'for', 'function', 'if', 'in', 'local', 'not',
    'or', 'repeat', 'return', 'then', 'until', 'while',
    'true', 'false', 'nil',
}

util.LUADOC_TAGS = {
    'alias', 'as', 'async', 'cast', 'class', 'deprecated', 'diagnostic',
    'enum', 'field', 'generic', 'meta', 'module', 'nodiscard', 'operator',
    'overload', 'param', 'private', 'protected', 'return', 'see', 'type',
    'vararg',
}

---@param text string
---@param offset integer
---@param param? Feature.Completion.Param
---@return integer
function util.toTextOffset(text, offset, param)
    if offset <= #text then
        return offset
    end
    if offset < 10000 then
        return #text
    end
    if not param then
        return #text
    end
    local document = param.scope:getDocument(param.uri)
    if not document then
        return #text
    end
    local row = offset // 10000
    local col = offset % 10000
    return document.positionConverter:positionToOffset(row, col)
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@return integer
function util.toDisplayOffset(param, textOffset)
    local document = param.scope:getDocument(param.uri)
    if not document then
        return textOffset
    end
    local row, col = document.positionConverter:offsetToPosition(textOffset)
    if not row or not col then
        return textOffset
    end
    return row * 10000 + col
end

---@param text string
---@param offset integer
---@return integer lineStart
---@return string lineLeft
function util.getLineLeft(text, offset)
    local lineStart = offset
    while lineStart > 0 do
        local c = text:sub(lineStart, lineStart)
        if c == '\n' or c == '\r' then
            break
        end
        lineStart = lineStart - 1
    end
    lineStart = lineStart + 1
    return lineStart, text:sub(lineStart, offset)
end

---@param param Feature.Completion.Param
---@return LuaParser.Node.Base?
function util.getLuadocCatSource(param)
    for _, source in ipairs(param.sources) do
        if source.kind == 'catid' or source.kind == 'catindex' or source.kind == 'catarray' then
            return source
        end
    end
    return nil
end

---@param param Feature.Completion.Param
---@return boolean
function util.hasMissCatNameAtCursor(param)
    local textOffset = util.toTextOffset(param.scanner.text, param.offset, param)
    local document = param.scope:getDocument(param.uri)
    if not document or not document.ast or not document.ast.errors then
        return false
    end
    local cursorRow = document.positionConverter:offsetToPosition(textOffset)
    for _, err in ipairs(document.ast.errors) do
        if err.errorCode == 'MISS_CAT_NAME' then
            if err.start >= textOffset - 64 and err.start <= textOffset + 8 then
                return true
            end
            local errRow = document.positionConverter:offsetToPosition(err.start)
            if errRow == cursorRow then
                return true
            end
        end
    end
    return false
end

---@param param Feature.Completion.Param
---@return string?
function util.getCurrentClassNameFromSources(param)
    for _, source in ipairs(param.sources) do
        ---@cast source any
        if source.kind == 'catstateclass' and source.classID and source.classID.id then
            return source.classID.id
        end
        local parent = source.parent
        while parent do
            ---@cast parent any
            if parent.kind == 'catstateclass' and parent.classID and parent.classID.id then
                return parent.classID.id
            end
            parent = parent.parent
        end
    end
    return nil
end

---@param node Node?
---@return Node.Function[]
function util.collectFunctionNodes(node)
    if not node then
        return {}
    end
    local root = node:findValue(
        ls.node.kind['function']
      | ls.node.kind['union']
      | ls.node.kind['intersection']
    )
    if not root then
        return {}
    end
    if root.kind == 'function' then
        return { root }
    end
    ---@type Node.Function[]
    local funcs = {}
    local used = {}
    root:each('function', function (func)
        ---@cast func Node.Function
        if used[func] then
            return
        end
        used[func] = true
        funcs[#funcs+1] = func
    end, {})
    return funcs
end

---@param node Node?
---@return boolean
function util.hasFunctionNode(node)
    return #util.collectFunctionNodes(node) > 0
end

---@param param Feature.Completion.Param
---@return boolean
function util.isStatementPosition(param)
    local _, wordStart = param.scanner:getWordBack()
    local text = param.scanner.text

    local pos = wordStart - 1
    while pos >= 1 do
        local ch = text:sub(pos, pos)
        if ch ~= ' ' and ch ~= '\t' then
            break
        end
        pos = pos - 1
    end

    if pos < 1 then
        return true
    end

    local ch = text:sub(pos, pos)
    if ch == '\n' or ch == '\r' or ch == ';' then
        return true
    end
    if ch == '.' or ch == ':' or ch == '(' or ch == '[' or ch == '{' or ch == ',' or ch == '=' then
        return false
    end
    if  ch == '_'
    or (ch >= 'a' and ch <= 'z')
    or (ch >= 'A' and ch <= 'Z')
    or (ch >= '0' and ch <= '9') then
        return false
    end
    return true
end

---@param ch string
---@return boolean
function util.isIdentChar(ch)
    return ch == '_'
        or (ch >= 'a' and ch <= 'z')
        or (ch >= 'A' and ch <= 'Z')
        or (ch >= '0' and ch <= '9')
end

---@param param Feature.Completion.Param
---@return string
function util.getCompletionWord(param)
    local word = param.scanner:getWordBack()
    if word ~= '' then
        return word
    end

    local offset = param.textOffset or param.offset
    if offset <= 0 then
        return ''
    end

    local text = param.scanner.text
    local prev = text:sub(offset - 1, offset - 1)
    if not util.isIdentChar(prev) then
        return ''
    end

    local temp = New 'Feature.TextScanner' (text, offset - 1)
    local w = temp:getWordBack()
    return w
end

---@param s string
---@return string
function util.trim(s)
    return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

---@param text string
---@param offset integer
---@return string[]
---@return boolean isMethod
function util.findNextFunctionParams(text, offset)
    local after = text:sub(offset + 1)
    local startPos = after:find('function%s+[%w_%.:]+%s*%(')
                  or after:find('function%s*%(')
    if not startPos then
        return {}, false
    end

    local segment = after:sub(startPos)
    local head, args = segment:match('function%s+([%w_%.:]+)%s*%(([^)]*)%)')
    if not args then
        args = segment:match('function%s*%(([^)]*)%)')
    end
    if not args then
        return {}, false
    end

    local params = {}
    for part in args:gmatch('[^,]+') do
        local name = util.trim(part)
        if name ~= '' then
            params[#params+1] = name
        end
    end

    local isMethod = head and head:find(':', 1, true) ~= nil or false
    return params, isMethod
end

---@param text string
---@param offset integer
---@return string[] names
function util.findDocParamsBeforeCurrentFunction(text, offset)
    local left = text:sub(1, offset)
    local funcStart = left:match('.*()function%s+[%w_%.:]*%s*%([^()%[%]{}\n]*$')
                   or left:match('.*()function%s*%([^()%[%]{}\n]*$')
    if not funcStart then
        return {}
    end

    local lineStart = funcStart
    while lineStart > 1 do
        local c = text:sub(lineStart - 1, lineStart - 1)
        if c == '\n' or c == '\r' then
            break
        end
        lineStart = lineStart - 1
    end

    local from = math.max(1, lineStart - 800)
    local block = text:sub(from, lineStart - 1)
    local names = {}
    for name in block:gmatch('%-%-%-@param%s+([%w_]+)') do
        names[#names+1] = name
    end
    return names
end

---@param params string[]
---@return string
function util.buildParamSnippetText(params)
    if #params == 0 then
        return ''
    end
    local out = {}
    out[#out+1] = string.format('%s ${1:any}', params[1])
    for i = 2, #params do
        out[#out+1] = string.format('---@param %s ${%d:any}', params[i], i)
    end
    return table.concat(out, '\n')
end

---@param text string
---@return table<string, string>
function util.collectAliases(text)
    local aliases = {}
    for name, def in text:gmatch('%-%-%-@alias%s+([%w_%.]+)%s+([^\r\n]+)') do
        aliases[name] = util.trim(def)
    end
    return aliases
end

---@param expr string
---@return string[]
function util.extractEnumLiterals(expr)
    local out, used = {}, {}
    for s in expr:gmatch('"([^"]+)"') do
        local v = '"' .. s .. '"'
        if not used[v] then
            used[v] = true
            out[#out+1] = v
        end
    end
    for s in expr:gmatch("'([^']+)'") do
        local v = "'" .. s .. "'"
        if not used[v] then
            used[v] = true
            out[#out+1] = v
        end
    end
    for s in expr:gmatch('`([^`]+)`') do
        local v = s
        if not used[v] then
            used[v] = true
            out[#out+1] = v
        end
    end
    return out
end

---@param text string
---@param fnName string
---@return string[]? params
---@return table<string, string>? paramTypes
function util.findFunctionDocParamTypes(text, fnName)
    local fparams = text:match('function%s+' .. fnName:gsub('%.', '%%.') .. '%s*%(([^)]*)%)')
    if not fparams then
        return nil, nil
    end

    local params = {}
    for p in fparams:gmatch('[^,]+') do
        params[#params+1] = util.trim(p)
    end

    local paramTypes = {}
    for pName, pType in text:gmatch('%-%-%-@param%s+([%w_]+)%s+([^\r\n]+)') do
        paramTypes[pName] = util.trim(pType)
    end
    return params, paramTypes
end

---@param name string
---@param func Node.Function
---@return string label
---@return string snippetText
function util.buildFunctionSignature(name, func)
    local labels = {}
    local snippets = {}
    local index = 1

    for _, p in ipairs(func.paramsDef) do
        local optional = p.optional
        local labelPart = p.key
        local snippetPart = p.key .. (optional and '?' or '')
        labels[#labels+1] = labelPart
        snippets[#snippets+1] = string.format('${%d:%s}', index, snippetPart)
        index = index + 1
    end
    if func.varargParamDef then
        labels[#labels+1] = '...'
        snippets[#snippets+1] = string.format('${%d:...}', index)
    end

    return string.format('%s(%s)', name, table.concat(labels, ', '))
        , string.format('%s(%s)', name, table.concat(snippets, ', '))
end
