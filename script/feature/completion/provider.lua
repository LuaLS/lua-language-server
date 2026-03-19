---@type Feature.Provider<Feature.Completion.Param>
local providers = ls.feature.helper.providers()
require 'feature.text-scanner'

---@class Feature.Completion.Param
---@field uri Uri
---@field offset integer
---@field realTextOffset integer
---@field sourceTextOffset integer
---@field textOffset integer
---@field scope Scope
---@field sources LuaParser.Node.Base[]
---@field scanner Feature.TextScanner
---@field inComment boolean
---@field inString boolean

---@param uri Uri
---@param offset integer  # 字节偏移量（0-based）
---@return CompletionItem[]
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

    local realTextOffset = offset
    local textOffset = realTextOffset

    local function isBlank(ch)
        return ch == ' ' or ch == '\t' or ch == '\n' or ch == '\r'
    end

    local function isIdentChar(ch)
        return ch == '_'
            or (ch >= 'a' and ch <= 'z')
            or (ch >= 'A' and ch <= 'Z')
            or (ch >= '0' and ch <= '9')
    end

    local function snapToLeftSymbolRight(offset0)
        local pos = offset0
        while pos >= 1 and isBlank(text:sub(pos, pos)) do
            pos = pos - 1
        end
        if pos < 1 then
            return offset0
        end
        local ch = text:sub(pos, pos)
        if isIdentChar(ch) then
            return offset0
        end
        return pos
    end

    local sourceOffset = snapToLeftSymbolRight(realTextOffset)
    local sources = document:findSources(sourceOffset) or {}
    if #sources == 0 and sourceOffset > 0 then
        sources = document:findSources(sourceOffset - 1) or {}
    end

    local inComment = false
    local ast = document.ast
    local comments = ast and ast.comments or nil
    if comments then
        for _, comment in ipairs(comments) do
            if comment.start > textOffset then
                break
            end
            if comment.start <= textOffset and comment.finish >= textOffset then
                inComment = true
                break
            end
        end
    end

    local inString = false
    for _, source in ipairs(sources) do
        if source.kind == 'string' then
            inString = true
            break
        end
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
        -- 从 sources 中找包含当前偏移的最近 function 节点
        local funcNode
        for _, source in ipairs(sources) do
            if source.kind == 'function' then
                funcNode = source
                break
            end
        end
        if not funcNode then return false end
        -- funcNode.parent 是声明该函数的外层 block（blockParseChilds 中设置 state.parent = block）
        local block = funcNode.parent
        if not block or not block.cats then return false end
        -- 检查外层 block.cats 里是否有 @param cat 紧挨在 function 前一行
        -- 与 coder 的 getCatGroup 使用相同的邻接条件：cat.finishRow == funcRow - 1
        local funcRow = funcNode.startRow
        for _, cat in ipairs(block.cats) do
            if cat.kind == 'cat'
            and cat.value
            and cat.value.kind == 'catstateparam'
            and cat.finishRow == funcRow - 1 then
                return true
            end
        end
        return false
    end

    if word == '' then
        -- 检测光标是否在具名函数的参数列表括号内（AST symbolPos1/symbolPos2）
        local onFuncParams = false
        for _, source in ipairs(sources) do
            ---@cast source LuaParser.Node.Function
            if source.kind == 'function'
            and source.name
            and source.symbolPos1
            and source.symbolPos2
            and sourceOffset >= source.symbolPos1
            and sourceOffset <= source.symbolPos2 then
                onFuncParams = true
                break
            end
        end
        if onFuncParams then
            if not hasDocParamBeforeCurrentFunction() then
                return {}
            end
        end
    end

    local param = {
        uri = uri,
        offset = offset,
        realTextOffset = realTextOffset,
        sourceTextOffset = sourceOffset,
        textOffset = textOffset,
        scope = scope,
        sources = sources,
        scanner = scanner,
        inComment = inComment,
        inString = inString,
    }

    local results = providers.runner(param)

    return results
end

---@param callback fun(param: Feature.Completion.Param, action: Feature.ProviderActions<CompletionItem>)
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
---@return integer
function util.toTextOffset(text, offset)
    if offset <= #text then
        return offset
    end
    return #text
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@return integer
function util.toDisplayOffset(param, textOffset)
    return textOffset
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
    local textOffset = util.toTextOffset(param.scanner.text, param.offset)
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

---@param document Document?
---@param offset integer
---@return string[]
---@return boolean isMethod
function util.findNextFunctionParams(document, offset)
    local ast = document and document.ast
    local nodes = ast and ast.nodesMap and ast.nodesMap['function']
    if not nodes then
        return {}, false
    end
    -- 在 offset 之后找 start 最小的函数节点（即紧跟光标的那个函数声明）
    ---@type LuaParser.Node.Function?
    local bestFunc = nil
    for _, funcNode in ipairs(nodes) do
        ---@cast funcNode LuaParser.Node.Function
        if funcNode.start > offset then
            if not bestFunc or funcNode.start < bestFunc.start then
                bestFunc = funcNode
            end
        end
    end
    if not bestFunc then
        return {}, false
    end
    local params = {}
    if bestFunc.params then
        for _, p in ipairs(bestFunc.params) do
            if not p.dummy then
                params[#params+1] = p.id
            end
        end
    end
    local isMethod = bestFunc.name ~= nil and bestFunc.name.subtype == 'method'
    return params, isMethod
end

---@param sources LuaParser.Node.Base[]
---@param sourceOffset integer
---@return string[] names
function util.findDocParamsBeforeCurrentFunction(sources, sourceOffset)
    -- 从 sources（已按坐标过滤）中找光标所在的函数节点
    -- 要求光标在左括号之后，且在右括号之前（右括号不存在时同样接受）
    local funcNode = nil
    for _, source in ipairs(sources) do
        ---@cast source LuaParser.Node.Function
        if source.kind == 'function' and source.symbolPos1
        and sourceOffset >= source.symbolPos1
        and (not source.symbolPos2 or sourceOffset <= source.symbolPos2) then
            funcNode = source
            break
        end
    end
    if not funcNode then
        return {}
    end
    local block = funcNode.parent
    if not block or not block.cats then
        return {}
    end
    -- 正向遍历 block.cats，收集紧挨在函数前的连续 cat 注释组，提取其中的 @param 名称
    local funcRow = funcNode.startRow
    local groupCats = {}
    local prevEnd = -1
    for _, cat in ipairs(block.cats) do
        if cat.kind ~= 'cat' then goto continue end
        if cat.finishRow >= funcRow then break end
        if prevEnd ~= -1 and cat.startRow ~= prevEnd + 1 then
            groupCats = {}
        end
        groupCats[#groupCats+1] = cat
        prevEnd = cat.finishRow
        ::continue::
    end
    local names = {}
    if #groupCats > 0 and groupCats[#groupCats].finishRow == funcRow - 1 then
        for _, cat in ipairs(groupCats) do
            if cat.value and cat.value.kind == 'catstateparam' then
                names[#names+1] = cat.value.key.id
            end
        end
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
