---@type Feature.Provider<Feature.Completion.Param>
local providers    = ls.feature.helper.providers()
local guide        = require 'parser.guide'
require 'feature.text-scanner'

---@class Feature.Completion.Param
---@field uri     Uri
---@field offset  integer
---@field textOffset integer
---@field scope   Scope
---@field sources LuaParser.Node.Base[]
---@field scanner Feature.TextScanner

---@param uri Uri
---@param offset integer
---@return LSP.CompletionItem[]
function ls.feature.completion(uri, offset)
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

    local text    = file:getText()
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

    -- `function f(a, <??>)` / `function (a, <??>)` 参数定义空位不做补全
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
                if hasDocParamBeforeCurrentFunction() then
                    -- `---@param` 已声明时，允许在函数参数定义位做参数名补�?
                else
                    return {}
                end
            end
        end
    end

    local param = {
        uri     = uri,
        offset  = offset,
        textOffset = textOffset,
        scope   = scope,
        sources = sources,
        scanner = scanner,
    }

    return providers.runner(param)
end

---@param callback fun(param: Feature.Completion.Param, action: Feature.ProviderActions<LSP.CompletionItem>)
---@param priority integer? # 优先�?
---@return fun() disposable
function ls.feature.provider.completion(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

-- Lua 关键字列�?
local LUA_KEYWORDS = {
    'and', 'break', 'do', 'else', 'elseif', 'end',
    'for', 'function', 'if', 'in', 'local', 'not',
    'or', 'repeat', 'return', 'then', 'until', 'while',
    'true', 'false', 'nil',
}

local LUADOC_TAGS = {
    'alias', 'as', 'async', 'cast', 'class', 'deprecated', 'diagnostic',
    'enum', 'field', 'generic', 'meta', 'module', 'nodiscard', 'operator',
    'overload', 'param', 'private', 'protected', 'return', 'see', 'type',
    'vararg',
}

---@param text string
---@param offset integer
---@param param? Feature.Completion.Param
---@return integer
local function toTextOffset(text, offset, param)
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
local function toDisplayOffset(param, textOffset)
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
local function getLineLeft(text, offset)
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
local function getLuadocCatSource(param)
    for _, source in ipairs(param.sources) do
        if source.kind == 'catid' or source.kind == 'catindex' or source.kind == 'catarray' then
            return source
        end
    end
    return nil
end

---@param param Feature.Completion.Param
---@return boolean
local function hasMissCatNameAtCursor(param)
    local textOffset = toTextOffset(param.scanner.text, param.offset, param)
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
local function getCurrentClassNameFromSources(param)
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
local function collectFunctionNodes(node)
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
local function hasFunctionNode(node)
    return #collectFunctionNodes(node) > 0
end

-- LuaDoc: `---@class A : <??>` 的空类型位补全（专门兜底�?
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = toTextOffset(text, param.offset, param)
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
                kind  = kind,
            }
        end
    end
end, 22)

-- LuaDoc: `---@type <??>` 空类型位补全（专门兜底）
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = toTextOffset(text, param.offset, param)
    local _, lineLeft = getLineLeft(text, textOffset)
    if not lineLeft:match('^%s*%-%-%-@type%s*$') then
        return
    end

    action.skip()
    local names = param.scope.vm:getLuaDocTypes()
    for name, kind in pairs(names) do
        action.push {
            label = name,
            kind  = kind,
        }
    end
end, 22)

-- LuaDoc 补全（注释内）：tag 关键字与类型名引�?
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = toTextOffset(text, param.offset, param)
    local lineStart, lineLeft = getLineLeft(text, textOffset)
    local left = text:sub(1, textOffset)
    local leftLine = left:match('[^\r\n]*$') or ''

    -- tag: `---@cl<?>` -> class
    local tagPrefix = leftLine:match('^%s*%-%-%-@([%w_]*)$')
    if tagPrefix then
        action.skip()
        for _, tag in ipairs(LUADOC_TAGS) do
            if tag:sub(1, #tagPrefix) == tagPrefix then
                action.push {
                    label = tag,
                    kind  = ls.spec.CompletionItemKind.Event,
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

    local catSource = getLuadocCatSource(param)
    local missCatName = hasMissCatNameAtCursor(param)
    if missCatName then
        inTypeRef = true
        currentClass = currentClass or getCurrentClassNameFromSources(param)
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
                kind  = kind,
            }
            if name:find('[^%w_]') then
                item.textEdit = {
                    start   = absWordStart,
                    finish  = param.offset,
                    newText = name,
                }
            end
            action.push(item)
        end
    end
end, 20)

--- 判断当前补全位置是否处于"语句"位置（即可以写语句的 block 上下文）�?
--- 使用词法规则�?
---   - 行首/文件首可视为语句位置
---   - `.` `:` `(` `[` `{` `,` `=` 后不是语句位�?
---   - 标识符字符后不是语句位置
---@param param Feature.Completion.Param
---@return boolean
local function isStatementPosition(param)
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
local function isIdentChar(ch)
    return ch == '_'
        or (ch >= 'a' and ch <= 'z')
        or (ch >= 'A' and ch <= 'Z')
        or (ch >= '0' and ch <= '9')
end

---@param param Feature.Completion.Param
---@return string
local function getCompletionWord(param)
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
    if not isIdentChar(prev) then
        return ''
    end

    local temp = New 'Feature.TextScanner' (text, offset - 1)
    local w = temp:getWordBack()
    return w
end

-- 关键字补全（priority=0，field provider �?skip() 会阻止本 provider�?
-- 仅在语句位置（block 上下文）才补全关键字
ls.feature.provider.completion(function (param, action)
    local word = getCompletionWord(param)
    if word == '' then
        return
    end

    -- 只在语句位置补全关键�?
    if not isStatementPosition(param) then
        return
    end

    local matches = {}
    for _, kw in ipairs(LUA_KEYWORDS) do
        -- 关键字使用前缀匹配（不做模糊匹配）
        if kw:sub(1, #word) == word then
            matches[#matches+1] = kw
        end
    end
    table.sort(matches, ls.util.stringLess)

    for _, kw in ipairs(matches) do
        action.push {
            label = kw,
            kind  = ls.spec.CompletionItemKind.Keyword,
        }
    end
end)

-- 当前作用域内的局部变量补全（priority=0�?
ls.feature.provider.completion(function (param, action)
    ---@type any
    local source = param.sources[1]
    local textOffset = param.textOffset or toTextOffset(param.scanner.text, param.offset, param)

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

    local word = getCompletionWord(param)

    local locals = guide.getVisibleLocals(source, textOffset)
    local entries  = {}
    for _, loc in ipairs(locals) do
        local name = loc.id
        -- 跳过 Lua 内部隐式局部变�?
        if name == '_ENV' then
            goto continue
        end
        -- 跳过当前正在定义的变量自身（光标在其定义 AST 节点范围内）
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

    ---@param name string
    ---@param func Node.Function
    ---@return string label
    ---@return string snippetText
    local function buildFunctionSignature(name, func)
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

    for _, entry in ipairs(entries) do
        local value = entry.var and entry.var:getStaticValue() or nil
        local funcs = collectFunctionNodes(value)

        if #funcs == 0 then
            action.push {
                label = entry.name,
                kind  = ls.spec.CompletionItemKind.Variable,
            }
            goto continue
        end

        local usedLabel = {}
        for _, func in ipairs(funcs) do
            ---@cast func Node.Function
            local label, snippetText = buildFunctionSignature(entry.name, func)
            if not usedLabel[label] then
                usedLabel[label] = true
                action.push {
                    label = label,
                    kind  = ls.spec.CompletionItemKind.Function,
                    insertText = entry.name,
                }
                action.push {
                    label = label,
                    kind  = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText,
                }
            end
        end
        ::continue::
    end
end)

--- 根据 Node.Field 的值和访问方式判断补全 kind�?
---@param fieldNode Node.Field?
---@param trigger   string  # '.' �?':'
---@return integer
local function fieldCompletionKind(fieldNode, trigger)
    local valueNode = fieldNode and fieldNode.value or nil
    if hasFunctionNode(valueNode) then
        return trigger == ':'
               and ls.spec.CompletionItemKind.Method
               or  ls.spec.CompletionItemKind.Function
    end
    return ls.spec.CompletionItemKind.Field
end

---@param node Node?
---@param trigger string
---@return integer
local function runtimeFieldCompletionKind(node, trigger)
    if not node then
        return ls.spec.CompletionItemKind.Field
    end
    if hasFunctionNode(node) then
        return trigger == ':'
               and ls.spec.CompletionItemKind.Method
               or  ls.spec.CompletionItemKind.Function
    end
    return ls.spec.CompletionItemKind.Field
end

---@param s string
---@return string
local function trim(s)
    return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

---@param text string
---@param offset integer
---@return string[]
---@return boolean isMethod
local function findNextFunctionParams(text, offset)
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
        local name = trim(part)
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
local function findDocParamsBeforeCurrentFunction(text, offset)
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
local function buildParamSnippetText(params)
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

-- LuaDoc: `---@param <??>` 参数名补全（从后续函数签名提取）
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)
    local prefix = left:match('%-%-%-@param%s+([%w_]*)%s*$')
    if prefix == nil then
        return
    end

    local params, isMethod = findNextFunctionParams(text, textOffset)
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
            label      = table.concat(filtered, ', '),
            kind       = ls.spec.CompletionItemKind.Snippet,
            insertText = buildParamSnippetText(filtered),
        }
        if isMethod then
            action.push {
                label = 'self',
                kind  = ls.spec.CompletionItemKind.Interface,
            }
        end
    end

    for _, name in ipairs(filtered) do
        action.push {
            label = name,
            kind  = ls.spec.CompletionItemKind.Interface,
        }
    end
end, 21)

-- LuaDoc: `---@param <??>` 参数名补全（从后续函数签名提取）
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = toTextOffset(text, param.offset, param)
    local lineStart, lineLeft = getLineLeft(text, textOffset)
    local prefix = lineLeft:match('^%s*%-%-%-@param%s+([%w_]*)$')
    if prefix == nil then
        return
    end

    action.skip()

    local params, isMethod = findNextFunctionParams(text, textOffset)
    local filtered = {}
    for _, name in ipairs(params) do
        if name:sub(1, #prefix) == prefix then
            filtered[#filtered+1] = name
        end
    end

    if #filtered > 0 and prefix == '' then
        action.push {
            label      = table.concat(filtered, ', '),
            kind       = ls.spec.CompletionItemKind.Snippet,
            insertText = buildParamSnippetText(filtered),
        }
    end

    if isMethod and prefix == '' then
        action.push {
            label = 'self',
            kind  = ls.spec.CompletionItemKind.Interface,
        }
    end

    for _, name in ipairs(filtered) do
        action.push {
            label = name,
            kind  = ls.spec.CompletionItemKind.Interface,
        }
    end
end, 20)

-- 函数参数定义位：基于已写 `---@param` 的参数名补全
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)
    if  not left:match('function%s+[%w_%.:]*%s*%([^()%[%]{}\n]*$')
    and not left:match('function%s*%([^()%[%]{}\n]*$') then
        return
    end

    local word = param.scanner:getWordBack()
    local docParams = findDocParamsBeforeCurrentFunction(text, textOffset)
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
            kind  = ls.spec.CompletionItemKind.Snippet,
        }
    end
    for _, name in ipairs(matched) do
        action.push {
            label = name,
            kind  = ls.spec.CompletionItemKind.Interface,
        }
    end
end, 20)

-- 字段访问补全（t.xxx / t:xxx / fun().xxx），priority=10 确保先于局�?全局 provider 执行
ls.feature.provider.completion(function (param, action)
    -- �?getFieldTriggerBack 检测是否是字段访问，同时得到字段前缀 word 和对象末�?offset
    local trigger, objEnd, word = param.scanner:getFieldTriggerBack()
    if not trigger then
        return
    end

    -- 通过 objEnd offset 在语法树里找到对象表达式对应�?AST 节点
    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end
    local objSources = document:findSources(objEnd)
    if not objSources or #objSources == 0 then
        return
    end

    -- 取覆盖范围最小（最精确）的那个节点
    local objSource = objSources[1]

    -- 通过 vm:getNode �?AST 节点转为 Node，查询其 keys
    local objNode = param.scope.vm:getNode(objSource)
    if not objNode then
        return
    end

    -- 确认是字段访问上下文，阻止低优先�?provider 继续运行
    action.skip()

    -- 通过 Node.keys 枚举所有字符串字段，收集匹配的候选项
    local keys = objNode.keys
    if not keys then
        return
    end

    local matches = {}
    for _, keyNode in ipairs(keys) do
        -- 只关心字符串字面�?key
        if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
            local name = keyNode.literal
            ---@cast name string
            if ls.util.stringSimilar(word, name, true) then
                -- valueMap �?key 经过 luaKey 转换，对于字符串字面量就是字符串本身
                ---@cast objNode Node.Table
                local valueNode = objNode.valueMap and objNode.valueMap[name]
                matches[#matches+1] = { name = name, valueNode = valueNode }
            end
        end
    end
    table.sort(matches, function (a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    for _, item in ipairs(matches) do
        local functionKind = fieldCompletionKind(item.valueNode, trigger)
        if functionKind == ls.spec.CompletionItemKind.Field then
            local objVar = param.scope.vm:getVariable(objSource)
            if objVar then
                local childVar = objVar:getChild(item.name)
                local childValue = childVar:getCurrentValue()
                                or childVar:getGuessValue()
                                or childVar:getStaticValue()
                if childValue and childValue.kind == 'field' then
                    ---@cast childValue Node.Field
                    childValue = childValue.value and childValue.value.truly or nil
                end
                functionKind = runtimeFieldCompletionKind(childValue, trigger)
                if functionKind == ls.spec.CompletionItemKind.Field and childVar:hasAssign() then
                    for assign in childVar:eachAssign() do
                        ---@cast assign Node.Field
                        if assign.value and hasFunctionNode(assign.value) then
                            functionKind = trigger == ':'
                                and ls.spec.CompletionItemKind.Method
                                or  ls.spec.CompletionItemKind.Function
                            break
                        end
                    end
                end
            end
        end
        if functionKind == ls.spec.CompletionItemKind.Field then
            action.push {
                label = item.name,
                kind  = ls.spec.CompletionItemKind.Field,
            }
            goto continue
        end

        action.push {
            label = item.name,
            kind  = ls.spec.CompletionItemKind.Field,
        }
        action.push {
            label = item.name .. '()',
            kind  = functionKind,
        }
        ::continue::
    end
end, 10)

---@param text string
---@return table<string, string>
local function collectAliases(text)
    local aliases = {}
    for name, def in text:gmatch('%-%-%-@alias%s+([%w_%.]+)%s+([^\r\n]+)') do
        aliases[name] = trim(def)
    end
    return aliases
end

---@param expr string
---@return string[]
local function extractEnumLiterals(expr)
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
local function findFunctionDocParamTypes(text, fnName)
    local fparams = text:match('function%s+' .. fnName:gsub('%.', '%%.') .. '%s*%(([^)]*)%)')
    if not fparams then
        return nil, nil
    end

    local params = {}
    for p in fparams:gmatch('[^,]+') do
        params[#params+1] = trim(p)
    end

    local paramTypes = {}
    for pName, pType in text:gmatch('%-%-%-@param%s+([%w_]+)%s+([^\r\n]+)') do
        paramTypes[pName] = trim(pType)
    end
    return params, paramTypes
end

-- 函数类型参数位补全：`f(fun<??>)` -> `fun(a: any):ret` / `function` / `function ()`
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local textOffset = param.textOffset or toTextOffset(text, param.offset, param)
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

    local params, paramTypes = findFunctionDocParamTypes(text, fnName)
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
    if not pType:match('^fun%s*%(') then
        return
    end

    local word = getCompletionWord(param)
    if word ~= '' and not (('function'):sub(1, #word) == word) then
        return
    end

    local args = pType:match('^fun%s*%((.-)%)') or ''
    local placeholders = {}
    local idx = 1
    for part in args:gmatch('[^,]+') do
        local name = trim(part):match('^([%w_]+)%s*:')
                  or trim(part):match('^([%w_]+)')
        if name and name ~= '...' then
            placeholders[#placeholders+1] = string.format('${%d:%s}', idx, name)
            idx = idx + 1
        end
    end
    local newText = string.format('function (%s)\n\t$0\nend', table.concat(placeholders, ', '))
    local editStart = toDisplayOffset(param, textOffset - #word)
    local editFinish = toDisplayOffset(param, textOffset)

    action.skip()
    action.push {
        label = pType,
        kind  = ls.spec.CompletionItemKind.Function,
        textEdit = {
            start   = editStart,
            finish  = editFinish,
            newText = newText,
        }
    }
    action.push {
        label = 'function',
        kind  = ls.spec.CompletionItemKind.Keyword,
    }
    action.push {
        label = 'function ()',
        kind  = ls.spec.CompletionItemKind.Snippet,
    }
end, 16)

-- 字符串枚举补全（函数参数位置，基�?LuaDoc param/alias�?
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

    local params, paramTypes = findFunctionDocParamTypes(text, fnName)
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

    local aliases = collectAliases(text)
    if aliases[pType] then
        pType = aliases[pType]
    end

    local enums = extractEnumLiterals(pType)
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
            kind  = ls.spec.CompletionItemKind.EnumMember,
        }
    end
end, 15)

-- postfix 语法补全：`expr@pcall` / `expr@method` / `expr++` �?
ls.feature.provider.completion(function (param, action)
    local text = param.scanner.text
    local lineStart, lineLeft = getLineLeft(text, param.offset)

    -- 避免�?LuaDoc `---@xxx` 识别�?postfix `expr@xxx`
    if lineLeft:match('^%s*%-%-%-') then
        return
    end

    local expr, op = lineLeft:match('^(.-)@([%w_]+)$')
    local plusExpr, plusOp = lineLeft:match('^(.-)(%+%+%??)$')
    if plusExpr and plusOp then
        expr = plusExpr
        op = plusOp
    end
    if not expr or expr == '' or not op then
        return
    end

    action.skip()

    local exprStart = lineStart
    local exprFinish = lineStart + #expr
    local opStart = exprFinish
    local opFinish = opStart + #op

    local function pushPostfix(label, newText)
        ---@diagnostic disable-next-line: assign-type-mismatch
        action.push {
            label = label,
            kind  = ls.spec.CompletionItemKind.Snippet,
            textEdit = {
                start   = opStart,
                finish  = opFinish,
                newText = newText,
            },
            additionalTextEdits = {
                {
                    start   = exprStart,
                    finish  = exprFinish,
                    newText = '',
                }
            }
        }
    end

    if op == 'pcall' then
        local fn, args = expr:match('^([%w_%.:]+)%((.*)%)$')
        if fn then
            local call = args == '' and ('pcall(' .. fn .. ')') or ('pcall(' .. fn .. ', ' .. args .. ')')
            pushPostfix('pcall', call)
        else
            pushPostfix('pcall', 'pcall(' .. expr .. '$1)$0')
        end
        return
    end

    if op == 'xpcall' then
        local fn, args = expr:match('^([%w_%.:]+)%((.*)%)$')
        if fn then
            local call = args == ''
                and ('xpcall(' .. fn .. ', ${1:debug.traceback})$0')
                or  ('xpcall(' .. fn .. ', ${1:debug.traceback}, ' .. args .. ')$0')
            pushPostfix('xpcall', call)
        else
            pushPostfix('xpcall', 'xpcall(' .. expr .. ', ${1:debug.traceback}$2)$0')
        end
        return
    end

    if op == 'function' then
        pushPostfix('function', 'function ' .. expr .. '($1)\n\t$0\nend')
        return
    end

    if op == 'method' then
        local owner, method = expr:match('^([%w_%.]+)[%.:]([%w_]+)$')
        if owner and method then
            pushPostfix('method', 'function ' .. owner .. ':' .. method .. '($1)\n\t$0\nend')
        end
        return
    end

    if op == 'insert' then
        pushPostfix('insert', 'table.insert(' .. expr .. ', $0)')
        return
    end

    if op == '++' then
        pushPostfix('++', expr .. ' = ' .. expr .. ' + 1')
        pushPostfix('++?', expr .. ' = (' .. expr .. ' or 0) + 1')
        return
    end
end, 25)

-- 全局变量补全（priority=0�?
ls.feature.provider.completion(function (param, action)
    local source = param.sources[1]
    local word   = getCompletionWord(param)

    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end

    -- 收集当前可见的局部变量名，用于排除被遮蔽的全局变量
    local shadowedByLocal = {}
    if source then
        local textOffset = param.textOffset or toTextOffset(param.scanner.text, param.offset, param)
        for _, loc in ipairs(guide.getVisibleLocals(source, textOffset)) do
            shadowedByLocal[loc.id] = true
        end
    end

    local textOffset = param.textOffset or toTextOffset(param.scanner.text, param.offset, param)
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

    ---@param name string
    ---@param func Node.Function
    ---@return string label
    ---@return string snippetText
    local function buildFunctionSignature(name, func)
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

    for _, item in ipairs(matches) do
        local value = item.var:getStaticValue()
        local funcs = collectFunctionNodes(value)

        action.push {
            label = item.name,
            kind  = ls.spec.CompletionItemKind.Field,
        }

        if #funcs == 0 then
            goto continue
        end

        local usedLabel = {}
        for _, func in ipairs(funcs) do
            ---@cast func Node.Function
            local label, snippetText = buildFunctionSignature(item.name, func)
            if not usedLabel[label] then
                usedLabel[label] = true
                action.push {
                    label = label,
                    kind  = ls.spec.CompletionItemKind.Function,
                    insertText = item.name,
                }
                action.push {
                    label = label,
                    kind  = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText,
                }
            end
        end
        ::continue::
    end
end)
