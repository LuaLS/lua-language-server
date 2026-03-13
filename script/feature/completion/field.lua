local util = ls.feature.completionUtil
local guide = require 'parser.guide'
local hoverUtil = require 'feature.hover-util'

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

---@param text string
---@param objName string
---@param textOffset integer
---@return string?
local function inferObjectTypeByText(text, objName, textOffset)
    local left = text:sub(1, textOffset)
    local callName
    for fn in left:gmatch('local%s+' .. objName .. '%s*=%s*([%w_%.:]+)%s*%(') do
        callName = fn
    end
    if not callName then
        return nil
    end
    local plainFn = callName:gsub(':', '.')
    local escapedFn = plainFn:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')
    local returnType
    for r in left:gmatch('%-%-%-@return%s+([%w_%.]+)%s*[^\r\n]*\r?\n%s*local%s+function%s+' .. escapedFn .. '%s*%(') do
        returnType = r
    end
    if returnType then
        return returnType
    end
    for r in left:gmatch('%-%-%-@return%s+([%w_%.]+)%s*[^\r\n]*\r?\n%s*function%s+' .. escapedFn .. '%s*%(') do
        returnType = r
    end
    return returnType
end

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

---@param fieldNode Node.Field?
---@param trigger string
---@return integer
local function fieldCompletionKind(fieldNode, trigger)
    local valueNode = fieldNode and fieldNode.value or nil
    if util.hasFunctionNode(valueNode) then
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
    if util.hasFunctionNode(node) then
        return trigger == ':'
            and ls.spec.CompletionItemKind.Method
            or  ls.spec.CompletionItemKind.Function
    end
    return ls.spec.CompletionItemKind.Field
end

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

---@param ownerTypeName string?
---@param name string
---@param valueNode Node?
---@return string?
local function buildFieldDescription(ownerTypeName, name, valueNode)
    if not ownerTypeName or not valueNode or valueNode.kind ~= 'field' then
        return nil
    end
    ---@cast valueNode Node.Field
    local value = valueNode.value
    if not value then
        return nil
    end
    local fieldType = value:view()
    if not fieldType or fieldType == '' then
        return nil
    end
    local access
    if name:match('^[_%a][_%w]*$') then
        access = '.' .. name
    else
        access = string.format('[%q]', name)
    end
    return hoverUtil.toLuaCodeBlock(string.format('(field) %s%s: %s', ownerTypeName, access, fieldType))
end

ls.feature.provider.completion(function (param, action)
    local trigger, objEnd, word = param.scanner:getFieldTriggerBack()
    if not trigger then
        return
    end
    word = word or ''

    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end
    local objSources = document:findSources(objEnd)
    if (not objSources or #objSources == 0) and objEnd > 1 then
        objSources = document:findSources(objEnd - 1)
    end
    if (not objSources or #objSources == 0) then
        objSources = document:findSources(objEnd + 1)
    end
    objSources = objSources or {}

    local objName = getObjectNameBack(param.scanner.text, objEnd)

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

    local matches = {}
    local seen = {}
    appendFieldsFromNode(objNode, word, matches, seen)

    if objVar then
        appendFieldsFromNode(objVar:getCurrentValue(), word, matches, seen)
        appendFieldsFromNode(objVar:getGuessValue(), word, matches, seen)
        appendFieldsFromNode(objVar:getStaticValue(), word, matches, seen)
    end

    local objTypeName = getTypeName(objNode)
                    or (objVar and getTypeName(objVar:getCurrentValue()) or nil)
                    or (objVar and getTypeName(objVar:getGuessValue()) or nil)
                    or (objVar and getTypeName(objVar:getStaticValue()) or nil)

    table.sort(matches, function (a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    if #matches == 0 then
        local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset, param)
        objVar = objVar or (objSource and param.scope.vm:getVariable(objSource) or nil)
        if not objVar then
            ---@type any
            local source = param.sources[1]
            if not source then
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
                            appendFieldsFromNode(objVar:getCurrentValue(), word, matches, seen)
                            appendFieldsFromNode(objVar:getGuessValue(), word, matches, seen)
                            appendFieldsFromNode(objVar:getStaticValue(), word, matches, seen)
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
        local objCurrent = objVar and objVar:getCurrentValue() or nil
        local objGuess = objVar and objVar:getGuessValue() or nil
        local objStatic = objVar and objVar:getStaticValue() or nil
        local inferredType = objName and inferObjectTypeByText(param.scanner.text, objName, textOffset) or nil
        local stringLike = hasStringType(objNode)
                        or hasStringType(objCurrent)
                        or hasStringType(objGuess)
                        or hasStringType(objStatic)
                        or inferredType == 'string'

        if inferredType then
            appendFieldsFromTable(param.scope.rt.type(inferredType).fieldTable, word, matches, seen)
        end
        if stringLike then
            local rtStringType = param.scope.rt.type('string')
            if rtStringType then
                appendFieldsFromTable(rtStringType.fieldTable, word, matches, seen)
            end
            local envLocal = guide.getEnvLocal(document.ast, textOffset)
            local envVar = envLocal and param.scope.vm:getVariable(envLocal) or nil
            local childs = envVar and envVar:getChilds() or nil
            local stringVar = childs and childs['string'] or nil
            local stringValue = stringVar and stringVar:getStaticValue() or nil
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
        if #matches == 0 then
            return
        end
    end

    action.skip()

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
                        if assign.value and util.hasFunctionNode(assign.value) then
                            functionKind = trigger == ':'
                                and ls.spec.CompletionItemKind.Method
                                or  ls.spec.CompletionItemKind.Function
                            break
                        end
                    end
                end
            end
        end

        if trigger ~= ':' or functionKind == ls.spec.CompletionItemKind.Field then
            action.push {
                label = item.name,
                kind = ls.spec.CompletionItemKind.Field,
                description = buildFieldDescription(objTypeName, item.name, item.valueNode),
            }
        end
        if functionKind ~= ls.spec.CompletionItemKind.Field then
            action.push {
                label = item.name .. '()',
                kind = functionKind,
            }
        end
    end
end, 10)
