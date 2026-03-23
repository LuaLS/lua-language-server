-- 字段补全 provider：处理 '.' 和 ':' 触发的补全请求。
-- 从类型系统（Node.Table / Node.Type fieldTable）以及光标处可见的变量中收集候选项。

local util = ls.feature.completionUtil
local guide = require 'parser.guide'

-- 遍历 AST，找到包含 `textOffset` 的最深层 block。
-- 在 `param.sources` 为空时作为兜底作用域锚点使用。
---@param ast any
---@param textOffset integer
---@return any
local function findDeepestBlock(ast, textOffset)
    local block = ast.main
    local function step(b)
        for _, child in ipairs(b.childs) do
            if child.isBlock and child.start <= textOffset and textOffset <= child.finish then
                block = child
                step(child)
                return
            end
        end
    end
    step(block)
    return block
end

-- 根据静态节点判断候选项的 LSP CompletionItemKind。
-- 未展开的 Node.Field 包装节点一律返回 Field；
-- 若值可调用，则根据 trigger 返回 Function 或 Method。
---@param fieldNode Node.Field?
---@param trigger string
---@return integer
local function fieldCompletionKind(fieldNode, trigger)
    if fieldNode and fieldNode.kind == 'field' then
        return ls.spec.CompletionItemKind.Field
    end
    if util.hasFunctionNode(fieldNode) then
        return trigger == ':'
            and ls.spec.CompletionItemKind.Method
            or  ls.spec.CompletionItemKind.Function
    end
    return ls.spec.CompletionItemKind.Field
end

-- 同 fieldCompletionKind，但用于运行时已展开的节点
-- （调用方已经解包 Node.Field，无需再检查 kind == 'field'）。
local function runtimeFieldCompletionKind(node, trigger)
    if not node then
        return ls.spec.CompletionItemKind.Field
    end
    if util.hasFunctionNode(node) then
        return trigger == ':'
            and ls.spec.CompletionItemKind.Method
            or  ls.spec.CompletionItemKind.Function
    end
    return ls.spec.CompletionItemKind.Field
end

-- 从 Node.Table（或类型的 fieldTable）中追加与 `word` 模糊匹配的字符串键字段。
-- 已在 `seen` 中的键跳过，避免重复。
---@param tableNode Node.Table?
---@param word string
---@param matches {name: string, valueNode: Node?}[]
---@param seen table<string, true>
local function appendFieldsFromTable(tableNode, word, matches, seen)
    if not tableNode then
        return
    end
    local keys = tableNode.keys
    local valueMap = tableNode.valueMap
    if not keys then
        return
    end
    for _, keyNode in ipairs(keys) do
        if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
            local name = keyNode.literal
            ---@cast name string
            if not seen[name] and ls.util.stringSimilar(word, name, true) then
                seen[name] = true
                matches[#matches+1] = {
                    name = name,
                    valueNode = valueMap and valueMap[name] or nil,
                }
            end
        end
    end
end

-- 从 Node.Table 中追加整数键字段（数组风格）。
-- 在 '.' 触发时会以 '[N]' 的形式输出补全项。
---@param tableNode Node.Table?
---@param intMatches {literal: integer, valueNode: Node?}[]
local function appendIntegerFieldsFromTable(tableNode, intMatches)
    if not tableNode then
        return
    end
    local keys = tableNode.keys
    local valueMap = tableNode.valueMap
    if not keys then
        return
    end
    for _, keyNode in ipairs(keys) do
        if keyNode.kind == 'value' and math.type(keyNode.literal) == 'integer' then
            local lit = keyNode.literal
            ---@cast lit integer
            intMatches[#intMatches+1] = {
                literal   = lit,
                valueNode = valueMap and valueMap[lit] or nil,
            }
        end
    end
end

---@param node Node?
---@param intMatches {literal: integer, valueNode: Node?}[]
local function appendIntegerFieldsFromNode(node, intMatches)
    if not node then
        return
    end
    node:each('table', function (tableNode)
        ---@cast tableNode Node.Table
        appendIntegerFieldsFromTable(tableNode, intMatches)
    end, {})
    node:each('type', function (typeNode)
        ---@cast typeNode Node.Type
        appendIntegerFieldsFromTable(typeNode.fieldTable, intMatches)
    end, {})
end

---@param node Node?
---@param word string
---@param matches {name: string, valueNode: Node?}[]
---@param seen table<string, true>
local function appendFieldsFromNode(node, word, matches, seen)
    if not node then
        return
    end
    node:each('table', function (tableNode)
        ---@cast tableNode Node.Table
        appendFieldsFromTable(tableNode, word, matches, seen)
    end, {})
    node:each('type', function (typeNode)
        ---@cast typeNode Node.Type
        appendFieldsFromTable(typeNode.fieldTable, word, matches, seen)
    end, {})
end

---@param node Node?
---@return boolean
local function hasStringType(node)
    if not node then
        return false
    end
    if node.kind == 'type' then
        ---@cast node Node.Type
        if node.typeName == 'string' then
            return true
        end
    end
    if node.kind == 'value' then
        ---@cast node Node.Value
        if node.typeName == 'string' then
            return true
        end
    end
    local found = false
    node:each('type', function (typeNode)
        ---@cast typeNode Node.Type
        if typeNode.typeName == 'string' then
            found = true
        end
    end, {})
    return found
end

local DEFAULT_STRING_MEMBERS = {
    'byte',
    'char',
    'dump',
    'find',
    'format',
    'gmatch',
    'gsub',
    'len',
    'lower',
    'match',
    'pack',
    'packsize',
    'rep',
    'reverse',
    'sub',
    'unpack',
    'upper',
}

---@param word string
---@param matches {name: string, valueNode: Node?}[]
---@param seen table<string, true>
local function appendDefaultStringMembers(word, matches, seen)
    for _, name in ipairs(DEFAULT_STRING_MEMBERS) do
        if not seen[name] and ls.util.stringSimilar(word, name, true) then
            seen[name] = true
            matches[#matches+1] = {
                name = name,
                valueNode = nil,
            }
        end
    end
end

---@param node Node?
---@return string?
local function getTypeName(node)
    if not node then
        return nil
    end
    if node.kind == 'type' then
        ---@cast node Node.Type
        return node.typeName
    end
    local found
    node:each('type', function (typeNode)
        ---@cast typeNode Node.Type
        if not found then
            found = typeNode.typeName
        end
    end, {})
    return found
end

-- ─────────────────────────────────────────────────────────────────────────────
-- 核心接口：根据对象源节点和字段前缀生成补全项列表。
--
-- @param param      Provider 上下文
-- @param source     对象表达式的 AST 源节点（Field 节点的 last 域）
-- @param key        已输入的字段名前缀（'' 表示刚输入完触发字符）
-- @param options    可选配置：
--   isMethod    boolean  是否为 ':' 触发（影响 Method/Function 偏好及 ':' 时的过滤）
--   snippetMode string   'both'（默认）同时生成普通项和 Snippet 项；
--                        'none' 只生成普通项
--   dotOffset   integer  '.' 的显示偏移，用于整数键 textEdit（key=='' 时传入）
--   objName     string?  对象标识符名称，用于可见局部变量兜底查找
---@param param any
---@param source any
---@param key string
---@param options {isMethod: boolean?, snippetMode: string?, dotOffset: integer?, objName: string?}?
---@return table[]
local function buildFieldItems(param, source, key, options)
    options = options or {}
    local isMethod    = options.isMethod    or false
    local snippetMode = options.snippetMode or 'both'
    local trigger     = isMethod and ':' or '.'

    local objNode = param.scope.vm:getNode(source)
    local objVar  = param.scope.vm:getVariable(source)

    -- ── 快速收集字符串键字段 ──────────────────────────────────────────────
    local matches = {}
    local seen    = {}
    appendFieldsFromNode(objNode, key, matches, seen)
    if objVar then
        appendFieldsFromNode(objVar.value, key, matches, seen)
    end

    -- ── 整数键字段（数组下标），仅 key=='' 且 '.' 触发时有意义 ─────────────
    local intMatches = {}
    if not isMethod and key == '' then
        local intSeen = {}
        appendIntegerFieldsFromNode(objNode, intMatches)
        if objVar then
            appendIntegerFieldsFromNode(objVar.value, intMatches)
        end
        local deduped = {}
        for _, item in ipairs(intMatches) do
            if not intSeen[item.literal] then
                intSeen[item.literal] = true
                deduped[#deduped+1] = item
            end
        end
        intMatches = deduped
    end

    -- ── 兜底：快速路径无结果时逐步扩大查找范围 ───────────────────────────
    if #matches == 0 then
        local textOffset = param.textOffset
                        or util.toTextOffset(param.scanner.text, param.offset)
        local document   = param.scope:getDocument(param.uri)

        objVar = objVar or param.scope.vm:getVariable(source)

        -- 通过作用域内可见局部变量按名称匹配
        local objName = options.objName or source.id
        if not objVar and objName then
            local anchor = param.sources[1]
            if not anchor then
                -- param.sources 在隐式位置可能为空；
                -- 用最深的包含光标的 AST block 合成一个最小作用域锚点。
                local ast = document and document.ast
                if ast and ast.main then
                    anchor = { parentBlock = findDeepestBlock(ast, textOffset) }
                end
            end
            if anchor then
                for _, loc in ipairs(guide.getVisibleLocals(anchor, textOffset)) do
                    if loc.id == objName then
                        objVar = param.scope.vm:getVariable(loc)
                        if objVar then
                            appendFieldsFromNode(objVar.value, key, matches, seen)
                            if not isMethod and key == '' then
                                appendIntegerFieldsFromNode(objVar.value, intMatches)
                            end
                            break
                        end
                    end
                end
            end
        end

        local objValue     = objVar and objVar.value or nil
        local inferredType = getTypeName(objNode) or getTypeName(objValue)
        local stringLike   = hasStringType(objNode)
                          or hasStringType(objValue)
                          or inferredType == 'string'

        -- 具名类型补全：在 runtime 中查找该类型的 fieldTable
        if inferredType then
            appendFieldsFromTable(
                param.scope.rt.type(inferredType).fieldTable, key, matches, seen)
        end

        -- 字符串专项补全，依次尝试：
        --   1. runtime 中 'string' 类型的 fieldTable
        --   2. 当前环境中用户自定义的 string 表
        --   3. 硬编码的 DEFAULT_STRING_MEMBERS 兜底列表
        if stringLike then
            local rtStringType = param.scope.rt.type('string')
            if rtStringType then
                appendFieldsFromTable(rtStringType.fieldTable, key, matches, seen)
            end
            local envLocal    = document and guide.getEnvLocal(document.ast, textOffset)
            local envVar      = envLocal and param.scope.vm:getVariable(envLocal) or nil
            local childs      = envVar and envVar:getChilds() or nil
            local stringVar   = childs and childs['string'] or nil
            local stringValue = stringVar and stringVar.value or nil
            local stringKeys
            local stringMap
            if stringValue and stringValue.kind == 'table' then
                ---@cast stringValue Node.Table
                stringKeys = stringValue.keys
                stringMap  = stringValue.valueMap
            elseif stringValue and stringValue.kind == 'type' then
                ---@cast stringValue Node.Type
                local ft = stringValue.fieldTable
                if ft then
                    stringKeys = ft.keys
                    stringMap  = ft.valueMap
                end
            end
            if stringKeys and stringMap then
                for _, keyNode in ipairs(stringKeys) do
                    if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
                        local name = keyNode.literal
                        ---@cast name string
                        if ls.util.stringSimilar(key, name, true) then
                            matches[#matches+1] = { name = name, valueNode = stringMap[name] }
                        end
                    end
                end
            end
            if #matches == 0 then
                appendDefaultStringMembers(key, matches, seen)
            end
        end
    end

    if #matches == 0 and #intMatches == 0 then
        return {}
    end

    -- ── 构建输出项 ────────────────────────────────────────────────────────
    local objTypeName = getTypeName(objNode)
                     or (objVar and getTypeName(objVar.value) or nil)

    table.sort(matches, function(a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    local outItems = {}
    local function emit(item)
        outItems[#outItems+1] = item
    end

    -- 整数键 '[N]' 项（需要 dotOffset 以生成替换 '.' 的 textEdit）
    if not isMethod and #intMatches > 0 and options.dotOffset then
        table.sort(intMatches, function(a, b) return a.literal < b.literal end)
        for _, item in ipairs(intMatches) do
            emit {
                label = tostring(item.literal),
                kind  = ls.spec.CompletionItemKind.Field,
                textEdit = {
                    start   = options.dotOffset,
                    finish  = param.offset,
                    newText = string.format('[%d]', item.literal),
                },
            }
        end
    end

    -- 字符串键字段项
    for _, item in ipairs(matches) do
        -- baseKind：从类型系统静态推断；functionKind：运行时探查后的最终 Kind
        local baseKind          = fieldCompletionKind(item.valueNode, trigger)
        local functionKind      = baseKind
        local functionValueNode = item.valueNode

        -- 类成员模式：Node.Field 包裹 Node.Variable
        -- 例：`MyClass.method = function(self, ...) end`
        local rawValueNode = item.valueNode
                          and item.valueNode.kind == 'field'
                          and item.valueNode.value
                          or nil

        if rawValueNode and rawValueNode.kind == 'variable' then
            functionValueNode = rawValueNode
            local funcs = util.collectFunctionNodes(rawValueNode)
            if #funcs > 0 then
                local fp = funcs[1].paramsDef[1]
                functionKind = (fp and fp.key == 'self')
                    and ls.spec.CompletionItemKind.Method
                    or  ls.spec.CompletionItemKind.Function
            end
        end

        -- 运行时精化：静态无法确定 Kind 时，从子变量赋值记录中查找函数值
        -- （例如函数在其他文件中赋值的情况）
        if functionKind == ls.spec.CompletionItemKind.Field then
            local itemObjVar = param.scope.vm:getVariable(source)
            if itemObjVar then
                local childVar = itemObjVar:getChild(item.name)
                if childVar:hasAssign() then
                    local childValue = childVar.value
                    if childValue and childValue.kind == 'field' then
                        ---@cast childValue Node.Field
                        childValue = childValue.value and childValue.value.truly or nil
                    end
                    if childValue then
                        functionValueNode = childValue
                    end
                    functionKind = runtimeFieldCompletionKind(childValue, trigger)
                    if functionKind == ls.spec.CompletionItemKind.Field then
                        for assign in childVar:eachAssign() do
                            ---@cast assign Node.Field
                            if assign.value and util.hasFunctionNode(assign.value) then
                                functionValueNode = assign.value
                                functionKind      = isMethod
                                    and ls.spec.CompletionItemKind.Method
                                    or  ls.spec.CompletionItemKind.Function
                                break
                            end
                        end
                    end
                end
            end
        end

        -- 签名标签（仅类成员风格字段有）
        local signatureLabel
        local snippetText
        -- classMemberLike 为 true 表示该字段以变量形式声明（类成员风格），
        -- 只有此类字段才会生成完整的签名标签。
        local classMemberLike = rawValueNode and rawValueNode.kind == 'variable'
        if classMemberLike and functionKind ~= ls.spec.CompletionItemKind.Field and functionValueNode then
            local funcs = util.collectFunctionNodes(functionValueNode)
            if #funcs > 0 then
                local label
                label, snippetText = util.buildFunctionSignature(item.name, funcs[1])
                signatureLabel = isMethod and (item.name .. '()') or label
            end
        end
        if not snippetText and signatureLabel then
            snippetText = signatureLabel
        end

        -- 是否需要额外的 Snippet 项（仅类类型且 snippetMode ~= 'none'）
        local withSnippet = snippetMode ~= 'none'
                         and objTypeName
                         and objTypeName:find('.', 1, true)

        if isMethod then
            -- ':' 触发：只输出可调用项，跳过纯 Field
            if functionKind ~= ls.spec.CompletionItemKind.Field
            or util.hasFunctionNode(item.valueNode) then
                emit {
                    label      = signatureLabel or item.name,
                    kind       = functionKind,
                    insertText = functionKind ~= ls.spec.CompletionItemKind.Field
                                 and item.name or nil,
                }
            end
        elseif baseKind == ls.spec.CompletionItemKind.Field
            and functionKind ~= ls.spec.CompletionItemKind.Field
            and not util.hasFunctionNode(item.valueNode) then
            -- '.' 触发：静态为 Field 但运行时是函数 → 同时出 Field + Function 两项
            emit { label = item.name, kind = ls.spec.CompletionItemKind.Field }
            emit {
                label      = signatureLabel or (item.name .. '()'),
                kind       = functionKind,
                insertText = item.name,
            }
            if withSnippet then
                emit {
                    label      = signatureLabel or (item.name .. '()'),
                    kind       = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText or signatureLabel or (item.name .. '()'),
                }
            end
        else
            emit {
                label      = signatureLabel or item.name,
                kind       = functionKind,
                insertText = functionKind ~= ls.spec.CompletionItemKind.Field
                             and item.name or nil,
            }
            if not isMethod and withSnippet
            and functionKind ~= ls.spec.CompletionItemKind.Field then
                emit {
                    label      = signatureLabel or item.name,
                    kind       = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText or signatureLabel or (item.name .. '()'),
                }
            end
        end
    end

    -- ── 排序并返回 ────────────────────────────────────────────────────────
    -- ':' 触发：Method > Function > Field
    -- '.' 触发：Field > Function > Method
    local function rank(kind)
        if isMethod then
            if kind == ls.spec.CompletionItemKind.Method   then return 1 end
            if kind == ls.spec.CompletionItemKind.Function then return 2 end
            return 3
        end
        if kind == ls.spec.CompletionItemKind.Field    then return 1 end
        if kind == ls.spec.CompletionItemKind.Function then return 2 end
        if kind == ls.spec.CompletionItemKind.Method   then return 3 end
        return 4
    end

    table.sort(outItems, function(a, b)
        local ra, rb = rank(a.kind), rank(b.kind)
        if ra ~= rb then return ra < rb end
        return ls.util.stringLess(a.label, b.label)
    end)

    return outItems
end

-- ── Provider 1：刚输入完 '.' 或 ':'，word 为空 ──────────────────────────────
-- 例：`var.<??>` `obj:<??>` — 从 param.sources 中查找 dummy Field 节点（key 为 nil）。
ls.feature.provider.completion(function(param, action)
    if param.inComment then return end

    -- findSources 会跳过 dummy 节点，需要直接查询 ast.nodesMap 查找 dummy Field 节点。
    -- dummy Field 节点：'.'/':' 已消耗但 key 为空，finish = symbolPos + 1（紧贴触发符右侧）
    local document = param.scope:getDocument(param.uri)
    if not document then return end

    local ast = document.ast
    if not ast then return end

    -- param.sourceTextOffset 已吸附到最后一个符号右边（snapToLeftSymbolRight），
    -- 对 `t.   <cursor>` 等含空格场景可修正到 '.' 位置，再用 finish = symbolPos+1 精确匹配。
    local srcOffset = param.sourceTextOffset

    local fieldSource
    local fieldNodes = ast.nodesMap and ast.nodesMap['field']
    if fieldNodes then
        for _, node in ipairs(fieldNodes) do
            ---@cast node any
            if node.dummy and node.start <= srcOffset and node.finish >= srcOffset then
                fieldSource = node
                break
            end
        end
    end
    -- 当 parser 跨换行解析了真实 key（如 `t.\nxxx()`），不会生成 dummy 节点；
    -- 此时检查 param.sources 中的非 dummy Field 节点：
    -- 若 srcOffset 在 symbolPos 之后、key.start 之前，仍属于 Provider 1 场景。
    if not fieldSource then
        for _, src in ipairs(param.sources) do
            ---@cast src any
            if src.kind == 'field' and not src.dummy
            and src.symbolPos
            and srcOffset > src.symbolPos
            and (not src.key or srcOffset <= src.key.start) then
                fieldSource = src
                break
            end
        end
    end
    if not fieldSource then return end

    local objSource = fieldSource.last
    if not objSource then return end

    local isMethod  = fieldSource.subtype == 'method'
    local objName   = objSource.kind == 'var' and objSource.id or nil
    -- symbolPos（0-indexed）就是字节偏移，直接作为 dotOffset 传入。
    local dotOffset = not isMethod and fieldSource.symbolPos or nil
    -- 只对 '.' ':' 访问阻止 word provider，'[]' 下标访问保留 word 补全。
    if fieldSource.subtype == 'field' or fieldSource.subtype == 'method' then
        action.skip()
    end
    local items = buildFieldItems(param, objSource, '', {
        isMethod  = isMethod,
        dotOffset = dotOffset,
        objName   = objName,
    })
    for _, item in ipairs(items) do
        action.push(item)
    end
end, 10)

-- ── Provider 2：'.' 或 ':' 后又输入了部分字段名 ──────────────────────────────
-- 例：`var.partial<??>` `obj:mtd<??>` — 只做字符串键字段 fuzzy 匹配。
ls.feature.provider.completion(function(param, action)
    if param.inComment then return end

    -- 非 dummy Field 节点：'.' 后跟有 key，key.start ~ 光标 = 已输入的字段前缀
    local fieldSource
    for _, src in ipairs(param.sources) do
        ---@cast src any
        if src.kind == 'field' and not src.dummy then
            fieldSource = src
            break
        end
    end
    if not fieldSource then return end

    -- 计算光标前已输入的字段名前缀（支持光标在标识符中间的情形）
    local textOffset = param.textOffset
                    or util.toTextOffset(param.scanner.text, param.offset)
    local word = fieldSource.key
             and param.scanner.text:sub(fieldSource.key.start + 1, textOffset)
             or  ''
    if word == '' then return end

    local document = param.scope:getDocument(param.uri)
    if not document then return end

    local objSource = fieldSource.last
    if not objSource then return end

    local isMethod = fieldSource.subtype == 'method'
    local objName  = objSource.kind == 'var' and objSource.id or nil
    -- 只对 '.' ':' 访问阻止 word provider，'[]' 下标访问保留 word 补全。
    if fieldSource.subtype == 'field' or fieldSource.subtype == 'method' then
        action.skip()
    end
    local items = buildFieldItems(param, objSource, word, {
        isMethod = isMethod,
        objName  = objName,
    })
    for _, item in ipairs(items) do
        action.push(item)
    end
end, 10)
