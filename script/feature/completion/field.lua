-- 字段补全 provider：处理 '.' 和 ':' 触发的补全请求。
-- 从类型系统（Node.Table / Node.Type fieldTable）以及光标处可见的变量中收集候选项。

local util = ls.feature.completionUtil
local guide = require 'parser.guide'

-- 从 `endOffset` 位置向前扫描 `text`，提取触发字符前的标识符
-- （例如 "foo.bar" 中的 "foo"）。
---@param text string
---@param endOffset integer
---@return string?
local function getObjectNameBack(text, endOffset)
    local i = endOffset
    while i >= 1 do
        local ch = text:sub(i, i)
        if not util.isIdentChar(ch) then
            break
        end
        i = i - 1
    end
    local name = text:sub(i + 1, endOffset)
    if name == '' then
        return nil
    end
    return name
end

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

ls.feature.provider.completion(function (param, action)
    -- ── 阶段 1：扫描触发字符 ────────────────────────────────────────────────
    -- 检测光标前是否存在 '.' 或 ':' 触发字符。
    -- `trigger`  = '.' 或 ':'
    -- `objEnd`   = 对象表达式最后一个字符的文本偏移
    -- `word`     = 已输入的字段名前缀（可为空串）
    local trigger, objEnd, word = param.scanner:getFieldTriggerBack()
    if not trigger then
        return
    end
    if param.inComment then
        return
    end
    word = word or ''

    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end

    -- ── 阶段 2：定位对象的 AST 源节点 ──────────────────────────────────────
    -- 整数键补全项（仅在 '.' 触发且 word 为空时使用）
    local intMatches = {}
    local intSeen   = {}

    -- findSources 根据文本偏移返回对应的 AST 源节点。
    -- 偏移量 ±1 容错，处理边界差一问题。
    local objSources = document:findSources(objEnd)
    if (not objSources or #objSources == 0) and objEnd > 1 then
        objSources = document:findSources(objEnd - 1)
    end
    if (not objSources or #objSources == 0) then
        objSources = document:findSources(objEnd + 1)
    end
    objSources = objSources or {}

    local objName = getObjectNameBack(param.scanner.text, objEnd)

    -- 第一轮：优先找 kind=='var' 且 id 与对象名完全一致的源节点。
    -- 第二轮：退而求其次，取 VM 中有对应 node 或 variable 的任意节点。
    local objSource
    local objNode
    local objVar
    for _, source in ipairs(objSources) do
        ---@cast source any
        if source.kind == 'var' and objName and source.id == objName then
            objSource = source
            objNode = param.scope.vm:getNode(source)
            objVar = param.scope.vm:getVariable(source)
            break
        end
    end
    for _, source in ipairs(objSources) do
        if objSource then
            break
        end
        local node = param.scope.vm:getNode(source)
        local var = param.scope.vm:getVariable(source)
        if node or var then
            objSource = source
            objNode = node
            objVar = var
            break
        end
    end
    if not objSource then
        return
    end

    -- ── 阶段 3：快速路径收集 ────────────────────────────────────────────────
    -- 直接使用 VM 已找到的 node/var，遍历其 Node.Table / Node.Type 子节点，
    -- 收集匹配的字段名。
    local matches = {}
    local seen = {}
    appendFieldsFromNode(objNode, word, matches, seen)

    if objVar then
        appendFieldsFromNode(objVar.value, word, matches, seen)
    end

    -- 整数键字段（数组下标）只在 '.' 触发且没有前缀词时才有意义，
    -- 输出时会生成替换 '.' 为 '[N]' 的 textEdit。
    if trigger == '.' and word == '' then
        appendIntegerFieldsFromNode(objNode, intMatches)
        if objVar then
            appendIntegerFieldsFromNode(objVar.value, intMatches)
        end
        -- 对整数键去重
        local deduped = {}
        for _, item in ipairs(intMatches) do
            if not intSeen[item.literal] then
                intSeen[item.literal] = true
                deduped[#deduped+1] = item
            end
        end
        intMatches = deduped
    end

    -- 类型名用于后续在 runtime 中查找 fieldTable，
    -- 也用于判断是否需要为点调用风格额外生成 Snippet 项。
    local objTypeName = getTypeName(objNode)
                    or (objVar and getTypeName(objVar.value) or nil)

    table.sort(matches, function (a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    -- ── 阶段 4：快速路径无结果时的兜底处理 ────────────────────────────────
    if #matches == 0 then
        local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset, param)
        -- 再次尝试解析 objVar：先直接从 objSource 查 VM，
        -- 若仍失败则通过 guide.getVisibleLocals 遍历光标处所有可见局部变量，按名称匹配。
        objVar = objVar or (objSource and param.scope.vm:getVariable(objSource) or nil)
        if not objVar then
            ---@type any
            local source = param.sources[1]
            if not source then
                -- param.sources 在隐式位置可能为空；
                -- 用最深的包含光标的 AST block 合成一个最小作用域锚点。
                local ast = document.ast
                if ast and ast.main then
                    source = {
                        parentBlock = findDeepestBlock(ast, textOffset),
                    }
                end
            end
            if objName and source then
                for _, loc in ipairs(guide.getVisibleLocals(source, textOffset)) do
                    if loc.id == objName then
                        objVar = param.scope.vm:getVariable(loc)
                        if objVar then
                            appendFieldsFromNode(objVar.value, word, matches, seen)
                            if trigger == '.' and word == '' then
                                appendIntegerFieldsFromNode(objVar.value, intMatches)
                            end
                            break
                        end
                    end
                end
            end
        end
        if #matches > 0 then
            table.sort(matches, function (a, b)
                return ls.util.stringLess(a.name, b.name)
            end)
        end
        local objValue = objVar and objVar.value or nil
        local inferredType = getTypeName(objNode) or getTypeName(objValue)
        -- 字符串类型的对象需要追加完整的 string 标准库成员。
        local stringLike = hasStringType(objNode)
                        or hasStringType(objValue)
                        or inferredType == 'string'

        -- 具名类型补全：在 runtime 中查找该类型的 fieldTable。
        if inferredType then
            appendFieldsFromTable(param.scope.rt.type(inferredType).fieldTable, word, matches, seen)
        end
        -- 字符串专项补全，依次尝试：
        --   1. runtime 中 'string' 类型的 fieldTable
        --   2. 当前环境中用户自定义的 string 表
        --   3. 硬编码的 DEFAULT_STRING_MEMBERS 兜底列表
        if stringLike then
            local rtStringType = param.scope.rt.type('string')
            if rtStringType then
                appendFieldsFromTable(rtStringType.fieldTable, word, matches, seen)
            end
            local envLocal = guide.getEnvLocal(document.ast, textOffset)
            local envVar = envLocal and param.scope.vm:getVariable(envLocal) or nil
            local childs = envVar and envVar:getChilds() or nil
            local stringVar = childs and childs['string'] or nil
            local stringValue = stringVar and stringVar.value or nil
            local stringKeys
            local stringMap
            if stringValue and stringValue.kind == 'table' then
                ---@cast stringValue Node.Table
                stringKeys = stringValue.keys
                stringMap = stringValue.valueMap
            elseif stringValue and stringValue.kind == 'type' then
                ---@cast stringValue Node.Type
                local fieldTable = stringValue.fieldTable
                if fieldTable then
                    stringKeys = fieldTable.keys
                    stringMap = fieldTable.valueMap
                end
            end
            if stringKeys and stringMap then
                for _, keyNode in ipairs(stringKeys) do
                    if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
                        local name = keyNode.literal
                        ---@cast name string
                        if ls.util.stringSimilar(word, name, true) then
                            local valueNode = stringMap[name]
                            matches[#matches+1] = { name = name, valueNode = valueNode }
                        end
                    end
                end
                table.sort(matches, function (a, b)
                    return ls.util.stringLess(a.name, b.name)
                end)
            end
            if #matches == 0 then
                appendDefaultStringMembers(word, matches, seen)
                table.sort(matches, function (a, b)
                    return ls.util.stringLess(a.name, b.name)
                end)
            end
        end
        if #matches == 0 and #intMatches == 0 then
            return
        end
    end

    if #matches == 0 and #intMatches == 0 then
        return
    end

    -- ── 阶段 5：构建并输出补全项 ──────────────────────────────────────────
    -- 通知框架本 provider 已接管此次请求，阻止低优先级 provider 继续处理同一触发位置。
    action.skip()

    local outItems = {}
    local function emit(item)
        outItems[#outItems+1] = item
    end

    -- 整数键补全项：生成将 '.' 替换为 '[N]' 的 textEdit
    if trigger == '.' and #intMatches > 0 then
        table.sort(intMatches, function (a, b) return a.literal < b.literal end)
        local dotDisplayOffset = util.toDisplayOffset(param, objEnd)
        for _, item in ipairs(intMatches) do
            emit {
                label = tostring(item.literal),
                kind  = ls.spec.CompletionItemKind.Field,
                textEdit = {
                    start  = dotDisplayOffset,
                    finish = param.offset,
                    newText = string.format('[%d]', item.literal),
                },
            }
        end
    end

    for _, item in ipairs(matches) do
        -- `baseKind`：从类型系统中的节点静态推断出的 Kind。
        -- `functionKind`：经运行时探查后可能升级为 Method/Function。
        -- `functionValueNode`：用于生成签名标签的节点。
        local baseKind = fieldCompletionKind(item.valueNode, trigger)
        local functionKind = baseKind
        local functionValueNode = item.valueNode

        -- Node.Field 包裹 Node.Variable 是类成员模式：
        -- `MyClass.method = function(self, ...) end`。
        -- 展开到内层变量，以便检查其函数节点。
        local rawValueNode = item.valueNode and item.valueNode.kind == 'field' and item.valueNode.value or nil

        if rawValueNode and rawValueNode.kind == 'variable' then
            functionValueNode = rawValueNode
            local funcs = util.collectFunctionNodes(rawValueNode)
            if #funcs > 0 then
                local firstParam = funcs[1].paramsDef[1]
                if firstParam and firstParam.key == 'self' then
                    functionKind = ls.spec.CompletionItemKind.Method
                else
                    functionKind = ls.spec.CompletionItemKind.Function
                end
            end
        end

        -- 运行时精化：若静态分析未能确定 Kind，
        -- 从实际对象的子变量赋值记录中查找函数值
        -- （例如函数在其他文件中赋值的情况）。
        if functionKind == ls.spec.CompletionItemKind.Field then
            local itemObjVar = param.scope.vm:getVariable(objSource)
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
                                functionKind = trigger == ':'
                                    and ls.spec.CompletionItemKind.Method
                                    or  ls.spec.CompletionItemKind.Function
                                break
                            end
                        end
                    end
                end
            end
        end

        local signatureLabel
        local snippetText
        -- `classMemberLike` 为 true 表示该字段以变量形式声明（类成员风格），
        -- 只有此类字段才会生成完整的签名标签。
        local classMemberLike = rawValueNode and rawValueNode.kind == 'variable'
        if classMemberLike and functionKind ~= ls.spec.CompletionItemKind.Field and functionValueNode then
            local funcs = util.collectFunctionNodes(functionValueNode)
            if #funcs > 0 then
                local label
                label, snippetText = util.buildFunctionSignature(item.name, funcs[1])
                if trigger == ':' then
                    signatureLabel = item.name .. '()'
                else
                    signatureLabel = label
                end
            end
        end
        if not snippetText and signatureLabel then
            snippetText = signatureLabel
        end

        if trigger == ':' then
            if functionKind ~= ls.spec.CompletionItemKind.Field or util.hasFunctionNode(item.valueNode) then
                emit {
                    label = signatureLabel or item.name,
                    kind  = functionKind,
                    insertText = functionKind ~= ls.spec.CompletionItemKind.Field and item.name or nil,
                }
            end
        elseif baseKind == ls.spec.CompletionItemKind.Field
            and functionKind ~= ls.spec.CompletionItemKind.Field
            and not util.hasFunctionNode(item.valueNode) then
            emit {
                label = item.name,
                kind  = ls.spec.CompletionItemKind.Field,
            }
            emit {
                label = signatureLabel or (item.name .. '()'),
                kind  = functionKind,
                insertText = item.name,
            }
            if objTypeName and objTypeName:find('.', 1, true) then
                emit {
                    label = signatureLabel or (item.name .. '()'),
                    kind  = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText or signatureLabel or (item.name .. '()'),
                }
            end
        else
            emit {
                label = signatureLabel or item.name,
                kind  = functionKind,
                insertText = functionKind ~= ls.spec.CompletionItemKind.Field and item.name or nil,
            }
            if trigger == '.' and objTypeName and objTypeName:find('.', 1, true) and functionKind ~= ls.spec.CompletionItemKind.Field then
                emit {
                    label = signatureLabel or item.name,
                    kind  = ls.spec.CompletionItemKind.Snippet,
                    insertText = snippetText or signatureLabel or (item.name .. '()'),
                }
            end
        end
    end

    -- ── 阶段 6：排序并推送 ────────────────────────────────────────────────
    -- ':' 触发：Method > Function > Field（方法调用优先）。
    -- '.' 触发：Field > Function > Method（数据字段优先）。
    local function rank(kind)
        if trigger == ':' then
            if kind == ls.spec.CompletionItemKind.Method then
                return 1
            end
            if kind == ls.spec.CompletionItemKind.Function then
                return 2
            end
            return 3
        end
        if kind == ls.spec.CompletionItemKind.Field then
            return 1
        end
        if kind == ls.spec.CompletionItemKind.Function then
            return 2
        end
        if kind == ls.spec.CompletionItemKind.Method then
            return 3
        end
        return 4
    end

    table.sort(outItems, function (a, b)
        local ra = rank(a.kind)
        local rb = rank(b.kind)
        if ra ~= rb then
            return ra < rb
        end
        return ls.util.stringLess(a.label, b.label)
    end)

    for _, item in ipairs(outItems) do
        action.push(item)
    end
end, 10)
