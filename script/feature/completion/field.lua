local util = ls.feature.completionUtil

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
    if not objSources or #objSources == 0 then
        return
    end

    local objSource = objSources[1]
    local objNode = param.scope.vm:getNode(objSource)
    if not objNode then
        return
    end

    action.skip()

    local keys = objNode.keys
    if not keys then
        return
    end

    local matches = {}
    for _, keyNode in ipairs(keys) do
        if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
            local name = keyNode.literal
            ---@cast name string
            ---@cast objNode Node.Table
            if ls.util.stringSimilar(word, name, true) then
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

        action.push {
            label = item.name,
            kind = ls.spec.CompletionItemKind.Field,
        }
        if functionKind ~= ls.spec.CompletionItemKind.Field then
            action.push {
                label = item.name .. '()',
                kind = functionKind,
            }
        end
    end
end, 10)
