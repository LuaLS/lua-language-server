local markdown = require 'tools.markdown'

local M = {}

---@class Feature.Hover.Item
---@field label string
---@field description? string

local SOURCE_PRIORITY = {
    ['function'] = 100,
    ['param'] = 90,
    ['local'] = 80,
    ['var'] = 70,
    ['field'] = 60,
    ['tablefield'] = 50,
    ['string'] = 40,
    ['integer'] = 40,
    ['float'] = 40,
    ['boolean'] = 40,
}

---@param path string
---@return string
local function dotPathToMethodPath(path)
    local pos = path:match('^.*()%.')
    if not pos then
        return path
    end
    return path:sub(1, pos - 1) .. ':' .. path:sub(pos + 1)
end

---@param source LuaParser.Node.Base?
---@return LuaParser.Node.Base?
local function normalizeSource(source)
    if not source then
        return nil
    end
    if source.kind == 'fieldid' or source.kind == 'tablefieldid' then
        return source.parent
    end
    return source
end

---@param parts string[]
---@return string
local function concatPath(parts)
    local result = parts[1] or ''
    for i = 2, #parts do
        local part = parts[i]
        if part:sub(1, 1) == '[' then
            result = result .. part
        else
            result = result .. '.' .. part
        end
    end
    return result
end

---@param source LuaParser.Node.Field
---@return string
local function renderFieldPath(source)
    local parts = {}
    ---@type LuaParser.Node.Base?
    local current = source
    for _ = 1, 1000 do
        if not current then
            break
        end
        if current.kind == 'field' then
            ---@cast current LuaParser.Node.Field
            local key = current.key
            if key and key.kind == 'fieldid' then
                parts[#parts+1] = key.id
            elseif key then
                parts[#parts+1] = '[' .. key.code .. ']'
            end
            current = current.last
        elseif current.kind == 'var' or current.kind == 'local' or current.kind == 'param' then
            ---@cast current LuaParser.Node.Var | LuaParser.Node.Local | LuaParser.Node.Param
            parts[#parts+1] = current.id
            break
        else
            break
        end
    end
    ls.util.revertArray(parts)
    return concatPath(parts)
end

---@param source LuaParser.Node.FuncName
---@return string
local function renderFunctionName(source)
    if source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        local path = renderFieldPath(source)
        if source.subtype == 'method' then
            return dotPathToMethodPath(path)
        end
        return path
    end
    ---@cast source LuaParser.Node.Var | LuaParser.Node.Local | LuaParser.Node.Param
    return source.id
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return Node.Key[]?
local function getGlobalPath(scope, source)
    if source.kind == 'var' then
        ---@cast source LuaParser.Node.Var
        if source.loc then
            return nil
        end
        return { source.id }
    end
    if source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        local firstVar = source:getFirstVar()
        if not firstVar or firstVar.loc then
            return nil
        end
        return scope.vm:getFullPath(source)
    end
    return nil
end

---@param source LuaParser.Node.Base
---@return string?
local function renderSourcePath(source)
    if source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        return renderFieldPath(source)
    end
    if source.kind == 'tablefield' then
        ---@cast source LuaParser.Node.TableField
        local key = source.key
        if key and key.kind == 'tablefieldid' then
            return key.id
        end
        if key then
            return '[' .. key.code .. ']'
        end
        return nil
    end
    if source.kind == 'function' then
        ---@cast source LuaParser.Node.Function
        if source.name then
            return renderFunctionName(source.name)
        end
    end
    if source.kind == 'var' or source.kind == 'local' or source.kind == 'param' then
        ---@cast source LuaParser.Node.Var | LuaParser.Node.Local | LuaParser.Node.Param
        return source.id
    end
    return source.code
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return Node.Variable?
function M.getSemanticVariable(scope, source)
    local normalizedSource = normalizeSource(source)
    if not normalizedSource then
        return nil
    end
    if normalizedSource.kind == 'local'
    or normalizedSource.kind == 'param'
    or normalizedSource.kind == 'var'
    or normalizedSource.kind == 'field'
    or normalizedSource.kind == 'tablefield' then
        local variable = scope.vm:getVariable(normalizedSource)
        if variable and (variable:isDefined() or M.getFunctionNode(variable.value)) then
            return variable
        end
        local globalPath = getGlobalPath(scope, normalizedSource)
        if globalPath then
            return scope.rt:globalGet(table.unpack(globalPath))
        end
        return variable
    end
    return nil
end

---@param sources LuaParser.Node.Base[]
---@return LuaParser.Node.Base?
function M.getTargetSource(sources)
    local bestSource
    local bestScore = -1
    local seen = {}
    for _, rawSource in ipairs(sources) do
        local source = normalizeSource(rawSource)
        if source and not seen[source] then
            seen[source] = true
            local score = SOURCE_PRIORITY[source.kind] or 0
            if score > bestScore then
                bestScore = score
                bestSource = source
            end
        end
    end
    return bestSource or normalizeSource(sources[1])
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return Node?
function M.getSemanticNode(scope, source)
    local normalizedSource = normalizeSource(source)
    if not normalizedSource then
        return nil
    end
    return scope.vm:getNode(normalizedSource)
end

---@param view string?
---@return string?
function M.toLuaCodeBlock(view)
    if not view or view == '' then
        return nil
    end
    return markdown.create()
        : append('lua', view)
        : string()
end

---@param item Feature.Hover.Item
---@return string?
function M.toMarkdownItem(item)
    if not item.label or item.label == '' then
        return nil
    end
    local mk = markdown.create()
    mk:append('lua', item.label)
    if item.description and item.description ~= '' then
        mk:appendText(item.description)
    end
    return mk:string()
end

---@param items Feature.Hover.Item[]?
---@return string?
function M.concatHoverItems(items)
    if not items or #items == 0 then
        return nil
    end
    local blocks = {}
    for _, item in ipairs(items) do
        local block = M.toMarkdownItem(item)
        if block then
            blocks[#blocks+1] = block
        end
    end
    if #blocks == 0 then
        return nil
    end
    return table.concat(blocks, '\n\n---\n\n')
end

---@param node Node
---@return string
function M.getTypeView(node)
    local value = node:finalValue()
    if value.kind == 'value' then
        ---@cast value Node.Value
        return value.nodeType:view()
    end
    if value.kind == 'table' then
        ---@cast value Node.Table
        if value:isEmpty() then
            return 'table'
        end
    end

    if node.kind == 'fcall' then
        return value:view()
    end

    return node:view()
end

---@param node? Node
---@return Node.Function?
function M.getFunctionNode(node)
    if not node then
        return nil
    end
    local func = node:findValue(ls.node.kind['function'])
    if not func then
        return nil
    end
    ---@cast func Node.Function
    return func
end

---@param a Node.Function
---@param b Node.Function
---@return boolean
local function isSameFunctionNode(a, b)
    if a == b then
        return true
    end
    if a.location and b.location then
        return a.location.uri == b.location.uri
           and a.location.offset == b.location.offset
    end
    return false
end

---@param variable Node.Variable
---@param func Node.Function
---@param fallbackPath string
---@return string
function M.getBestFunctionDisplayName(variable, func, fallbackPath)
    ---@type string
    local bestPath = fallbackPath
    local bestScore = -1

    ---@param candidate Node.Variable
    local function tryCandidate(candidate)
        local candidateFunc = M.getFunctionNode(candidate.value)
        if not candidateFunc or not isSameFunctionNode(candidateFunc, func) then
            return
        end
        local score = 0
        local candidateLoc = candidate:getLocation()
        if candidateLoc and func.location
        and candidateLoc.uri == func.location.uri
        and candidateLoc.offset == func.location.offset then
            score = score + 10
        end
        if candidate:isDefined() then
            score = score + 4
        end
        if candidateLoc then
            score = score + 2
        end
        if candidate.masterVariable then
            score = score - 1
        end
        local path = candidate:viewAsVariable()
        if not path or path == '' then
            return
        end
        if score > bestScore then
            bestScore = score
            bestPath = path
        elseif score == bestScore then
            if #path < #bestPath then
                bestPath = path
            end
        end
    end

    tryCandidate(variable)

    for _, equivalent in ipairs(variable.allEquivalents or {}) do
        if equivalent.kind == 'variable' then
            ---@cast equivalent Node.Variable
            tryCandidate(equivalent)
        end
    end

    return bestPath
end

---@param scope Scope
---@param source LuaParser.Node.Field
---@return string?
function M.buildMethodLabelFromSetmetatable(scope, source)
    if not source.key or source.key.kind ~= 'fieldid' then
        return nil
    end
    local firstVar = source:getFirstVar()
    if not firstVar or not firstVar.loc then
        return nil
    end

    local firstLoc = firstVar.loc
    if not firstLoc then
        return nil
    end
    local initValue = firstLoc.value
    if initValue and initValue.kind == 'select' then
        ---@cast initValue LuaParser.Node.Select
        initValue = initValue.value
    end
    if not initValue or initValue.kind ~= 'call' then
        return nil
    end

    ---@cast initValue LuaParser.Node.Call
    local callNode = initValue.node
    if not callNode or callNode.kind ~= 'var' then
        return nil
    end
    ---@cast callNode LuaParser.Node.Var
    if callNode.id ~= 'setmetatable' then
        return nil
    end

    local ownerSource = initValue.args and initValue.args[2] or nil
    if not ownerSource then
        return nil
    end
    if ownerSource.kind ~= 'var' and ownerSource.kind ~= 'field' then
        return nil
    end

    local ownerVariable = scope.vm:getVariable(ownerSource)
    if not ownerVariable then
        return nil
    end

    local key = source.key.id
    local value, exists = ownerVariable:get(key)
    if not exists then
        return nil
    end

    local func = M.getFunctionNode(value)
    if not func then
        return nil
    end

    local displayName = ownerVariable:viewAsVariable() .. '.' .. key
    return M.buildFunctionLabel(func, displayName)
end

---@param func Node.Function
---@param displayName string
---@return string
function M.buildFunctionLabel(func, displayName)
    local isMethod = func.paramsDef[1] and func.paramsDef[1].key == 'self' or false
    if isMethod then
        displayName = dotPathToMethodPath(displayName)
    end

    local params = {}
    local startIndex = isMethod and 2 or 1
    for i = startIndex, #func.paramsDef do
        local param = func.paramsDef[i]
        params[#params+1] = string.format('%s%s: %s'
            , param.key
            , param.optional and '?' or ''
            , param.value:view()
        )
    end
    if func.varargParamDef then
        params[#params+1] = '...' .. func.varargParamDef:view()
    end

    local lines = {
        string.format('%s%s(%s)'
            , isMethod and '(method) ' or 'function '
            , displayName
            , table.concat(params, ', ')
        )
    }

    if #func.returnsDef > 0 then
        if #func.returnsDef == 1 and not func.returnsDef[1].key then
            local retView = M.getTypeView(func.returnsDef[1].value)
            lines[#lines+1] = '  -> ' .. retView
        else
            for i, ret in ipairs(func.returnsDef) do
                local retView = M.getTypeView(ret.value)
                local text = ret.key and (ret.key .. ': ' .. retView) or retView
                lines[#lines+1] = ('  %d. %s'):format(i, text)
            end
        end
    else
        local min, max = func:getReturnCount()
        if max and max > 0 then
            if max == 1 then
                local ret = func:getReturn(1)
                if ret and ret ~= func.scope.rt.NIL then
                    lines[#lines+1] = '  -> ' .. M.getTypeView(ret)
                end
            else
                for i = 1, max do
                    local ret = func:getReturn(i)
                    if ret then
                        lines[#lines+1] = ('  %d. %s'):format(i, M.getTypeView(ret))
                    end
                end
            end
        elseif min == 1 then
            local ret = func:getReturn(1)
            if ret and ret ~= func.scope.rt.NIL then
                lines[#lines+1] = '  -> ' .. M.getTypeView(ret)
            end
        end
    end

    return table.concat(lines, '\n')
end

---@param source LuaParser.Node.Base
---@param variable Node.Variable
---@return string
function M.buildVariableLabel(source, variable)
    return M.buildVariableLabelWithNode(source, variable, variable.value)
end

---@param source LuaParser.Node.Base
---@param variable Node.Variable
---@param value Node
---@return string
function M.buildVariableLabelWithNode(source, variable, value)
    local path = variable:viewAsVariable()

    local func = M.getFunctionNode(value)
    if func then
        local displayName = M.getBestFunctionDisplayName(variable, func, path)
        return M.buildFunctionLabel(func, displayName)
    end
    if not variable:isDefined() then
        return M.buildUnknownLabel(source) or 'unknown'
    end

    local prefix
    if source.kind == 'param' then
        ---@cast source LuaParser.Node.Param
        prefix = source.isSelf and '(self) ' or '(parameter) '
    elseif source.kind == 'local' then
        prefix = 'local '
    elseif source.kind == 'var' then
        ---@cast source LuaParser.Node.Var
        if source.loc then
            local loc = source.loc
            if not loc then
                prefix = 'local '
            elseif loc.kind == 'param' then
                ---@cast loc LuaParser.Node.Param
                prefix = loc.isSelf and '(self) ' or '(parameter) '
            else
                prefix = 'local '
            end
        else
            prefix = '(global) '
        end
    elseif source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        local firstVar = source:getFirstVar()
        if firstVar and not firstVar.loc then
            prefix = '(global) '
        else
            prefix = '(field) '
        end
    elseif source.kind == 'tablefield' then
        prefix = '(field) '
    else
        prefix = ''
    end

    local label = string.format('%s%s: %s', prefix, path, M.getTypeView(value))
    local currentValue = variable.value:finalValue()
    if currentValue and currentValue.kind == 'value' then
        label = label .. ' = ' .. currentValue:view()
    end
    return label
end

---@param source LuaParser.Node.Base
---@param node? Node
---@return string?
function M.buildNodeLabel(source, node)
    local func = M.getFunctionNode(node)
    if func then
        local path = renderSourcePath(source)
        if path then
            return M.buildFunctionLabel(func, path)
        end
    end
    if node then
        local path = renderSourcePath(source)
        if path then
            if source.kind == 'tablefield' then
                local label = string.format('(field) %s: %s', path, M.getTypeView(node))
                local value = node:finalValue()
                if value.kind == 'value' then
                    label = label .. ' = ' .. value:view()
                end
                return label
            end
            return string.format('%s: %s', path, M.getTypeView(node))
        end
        return M.getTypeView(node)
    end
    return nil
end

---@param source LuaParser.Node.Base
---@return string?
function M.buildUnknownLabel(source)
    local path = renderSourcePath(source)
    if not path then
        return nil
    end
    local prefix = ''
    if source.kind == 'var' then
        prefix = '(global) '
    elseif source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        local firstVar = source:getFirstVar()
        if firstVar and not firstVar.loc then
            prefix = '(global) '
        else
            prefix = '(field) '
        end
    elseif source.kind == 'tablefield' then
        prefix = '(field) '
    elseif source.kind == 'local' then
        prefix = 'local '
    elseif source.kind == 'param' then
        ---@cast source LuaParser.Node.Param
        prefix = source.isSelf and '(self) ' or '(parameter) '
    end
    return string.format('%s%s: unknown', prefix, path)
end

---@param node? Node
---@return Node[]
function M.splitHoverNodes(node)
    if not node then
        return {}
    end

    local value = node.value
    if value.kind == 'union' then
        ---@cast value Node.Union
        return value.values
    end

    return { value }
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@param node? Node
---@return Feature.Hover.Item[]
function M.buildHoverItems(scope, source, node)
    local normalizedSource = normalizeSource(source)
    if not normalizedSource then
        return {}
    end
    source = normalizedSource

    if source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        local methodLabel = M.buildMethodLabelFromSetmetatable(scope, source)
        if methodLabel then
            return {
                { label = methodLabel }
            }
        end
    end

    local variable = M.getSemanticVariable(scope, source)
    if variable then
        local items = {}
        for _, subNode in ipairs(M.splitHoverNodes(variable.value)) do
            items[#items+1] = {
                label = M.buildVariableLabelWithNode(source, variable, subNode),
            }
        end
        return items
    end

    local splitNodes = M.splitHoverNodes(node)
    if #splitNodes > 0 then
        local items = {}
        for _, subNode in ipairs(splitNodes) do
            local label = M.buildNodeLabel(source, subNode)
            if label then
                items[#items+1] = { label = label }
            end
        end
        if #items > 0 then
            return items
        end
    end

    local unknown = M.buildUnknownLabel(source)
    if unknown then
        return {
            { label = unknown }
        }
    end

    if source.code and source.code ~= '' then
        return {
            { label = source.code }
        }
    end

    return {}
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return string?
function M.getSourceView(scope, source)
    local node = M.getSemanticNode(scope, source)
    if node then
        return node:view()
    end
    return source.code
end

return M
