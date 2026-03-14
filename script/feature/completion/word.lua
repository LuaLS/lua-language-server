local guide = require 'parser.guide'
local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
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
    ---@type any
    local source = param.sources[1]
    local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset, param)

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
        local value = entry.var and entry.var:getStaticValue() or nil
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

    -- `f({ abc = function() abc<??> end })`：补充首参类字段名，追加在本地词之后
    if word ~= '' then
        local left = param.scanner.text:sub(1, textOffset)
        if not left:match('{%s*[%w_]+%s*$') then
            local fnName
            for call in left:gmatch('([%w_%.:]+)%s*%(%s*{') do
                fnName = call
            end
            if not fnName then
                for call in left:gmatch('([%w_%.:]+)%s*{') do
                    fnName = call
                end
            end
            if fnName then
                fnName = fnName:gsub(':', '.')
                local params, paramTypes = util.findFunctionDocParamTypes(param.scanner.text, fnName)
                local pType = params and paramTypes and params[1] and paramTypes[params[1]] or nil
                local typeName = pType and pType:match('^([%w_%.]+)%??$') or nil
                if typeName then
                    local typeNode = param.scope.rt.type(typeName)
                    local expectValue = typeNode and typeNode:isClassLike() and typeNode.expectValue or nil
                    local keys = expectValue and expectValue.keys or nil
                    if keys then
                        local pushed = {}
                        for _, keyNode in ipairs(keys) do
                            if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
                                local name = keyNode.literal
                                ---@cast name string
                                if not pushed[name] and name:sub(1, #word) == word then
                                    pushed[name] = true
                                    action.push {
                                        label = name,
                                        kind = ls.spec.CompletionItemKind.Text,
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

ls.feature.provider.completion(function (param, action)
    local source = param.sources[1]
    local word = util.getCompletionWord(param)

    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end

    local shadowedByLocal = {}
    if source then
        local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset, param)
        for _, loc in ipairs(guide.getVisibleLocals(source, textOffset)) do
            shadowedByLocal[loc.id] = true
        end
    end

    local textOffset = param.textOffset or util.toTextOffset(param.scanner.text, param.offset, param)
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

    for _, item in ipairs(matches) do
        local value = item.var:getStaticValue()
        local funcs = util.collectFunctionNodes(value)

        action.push {
            label = item.name,
            kind = ls.spec.CompletionItemKind.Field,
        }

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
                    insertText = item.name,
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
