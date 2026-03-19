local util = ls.feature.completionUtil
local guide = require 'parser.guide'
local findLocalTypeExpr

---@param expr string
---@return string
local function normalizeTypeExpr(expr)
    return util.trim(expr:gsub('%?$', ''))
end

--- 直接从 Node 树中收集所有字符串字面量（"a"、'b' 等）。
--- 自动穿透 union / field / type / call 等节点，无需文本解析。
---@param node any
---@return string[]
local function collectStringLiteralsFromNode(node)
    if not node then return {} end
    local results = {}
    local seen    = {}
    node:each('value', function (n)
        if n.typeName == 'string' then
            local lit = n:view()
            if not seen[lit] then
                seen[lit] = true
                results[#results+1] = lit
            end
        end
    end)
    return results
end

---@param text string
---@param aliasName string
---@return string?
local function findAliasExprInText(text, aliasName)
    local lines = {}
    local inAlias = false
    for line in text:gmatch('[^\r\n]+') do
        local name, def = line:match('^%s*%-%-%-%s*@alias%s+([%w_%.]+)%s*(.-)%s*$')
        if name then
            inAlias = (name == aliasName)
            if inAlias and def and util.trim(def) ~= '' then
                return util.trim(def)
            end
        elseif inAlias then
            local item = line:match('^%s*%-%-%-%s*|%s*(.-)%s*$')
            if item then
                item = util.trim((item:gsub('%s*#.*$', '')))
                if item ~= '' then
                    lines[#lines+1] = item
                end
            else
                break
            end
        end
    end
    if #lines > 0 then
        return table.concat(lines, ' | ')
    end
    return nil
end

---@param text string
---@param aliases table<string, string>
---@param typeExpr string
---@param inTableArg boolean
---@return string
local function resolveEnumTypeExprFromText(text, aliases, typeExpr, inTableArg)
    local expr = normalizeTypeExpr(typeExpr)
    if inTableArg then
        expr = normalizeTypeExpr(expr:gsub('%[%]$', ''))
    end
    local visited = {}
    while not visited[expr] do
        visited[expr] = true
        local nextExpr = aliases[expr] or findAliasExprInText(text, expr)
        if not nextExpr then
            break
        end
        expr = normalizeTypeExpr(nextExpr)
    end
    return expr
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

---@param keySource any
---@return string?
local function extractStringKeyLiteral(keySource)
    if not keySource then
        return nil
    end
    if keySource.kind == 'fieldid' or keySource.kind == 'tablefieldid' then
        return keySource.id
    end
    if keySource.kind == 'string' then
        return keySource.value
    end
    return nil
end

---@param tableNode any
---@return string?
local function inferOwnerVarNameFromTableNode(tableNode)
    if not tableNode then
        return nil
    end
    local parent = tableNode.parent
    if not parent then
        return nil
    end
    local index = tableNode.index
    if not index then
        return nil
    end

    if parent.kind == 'localdef' then
        local loc = parent.vars and parent.vars[index] or nil
        return loc and loc.id or nil
    end

    if parent.kind == 'assign' then
        local exp = parent.exps and parent.exps[index] or nil
        if not exp then
            return nil
        end
        if exp.kind == 'var' then
            return exp.id
        end
        if exp.kind == 'field' and exp.getFirstVar then
            local firstVar = exp:getFirstVar()
            if firstVar and firstVar.kind == 'var' then
                return firstVar.id
            end
        end
    end
    return nil
end

---@param source any
---@param textOffset integer
---@return string? varName
---@return string? keyLiteral
local function extractAssignedVarAndKeyFromSource(source, textOffset)
    if not source then
        return nil, nil
    end

    if source.kind == 'field' then
        local value = source.value
        if value and value.start <= textOffset and textOffset <= value.finish then
            local keyLiteral = extractStringKeyLiteral(source.key)
            local firstVar = source.getFirstVar and source:getFirstVar() or nil
            if keyLiteral and firstVar and firstVar.kind == 'var' then
                return firstVar.id, keyLiteral
            end
        end
        return nil, nil
    end

    if source.kind == 'tablefield' then
        local value = source.value
        if value and value.start <= textOffset and textOffset <= value.finish then
            local keyLiteral = extractStringKeyLiteral(source.key)
            local varName = inferOwnerVarNameFromTableNode(source.parent)
            if varName and keyLiteral then
                return varName, keyLiteral
            end
            if varName then
                return varName, nil
            end
        end
    end

    return nil, nil
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@return any[]
local function collectAssignmentCandidateSources(param, textOffset)
    local document = param.scope:getDocument(param.uri)
    if not document then
        return param.sources or {}
    end

    local offsets = {
        param.sourceTextOffset,
        textOffset,
        textOffset - 1,
        textOffset + 1,
        param.realTextOffset,
    }

    local result = {}
    local seen = setmetatable({}, { __mode = 'k' })

    local function push(source)
        if not source then
            return
        end
        if seen[source] then
            return
        end
        seen[source] = true
        result[#result+1] = source
    end

    for _, source in ipairs(param.sources or {}) do
        push(source)
    end

    for _, offset in ipairs(offsets) do
        if type(offset) == 'number' and offset >= 1 then
            for _, source in ipairs(document:findSources(offset) or {}) do
                push(source)
            end
        end
    end

    return result
end

---@param text string
---@param textOffset integer
---@return string? varName
---@return string? keyLiteral
local function resolveAssignedVarAndKeyFromLineFallback(text, textOffset)
    local left = text:sub(1, textOffset)
    local lineLeft = (left:gsub('[%<%?]+$', '')):match('[^\r\n]*$') or ''

    local varName, keyLiteral = lineLeft:match('([%w_]+)%.([%w_]+)%s*=%s*')
    if varName then
        return varName, keyLiteral
    end
    varName, keyLiteral = lineLeft:match('([%w_]+)%[\"([^\"\r\n]*)\"%]%s*=%s*')
    if varName then
        return varName, keyLiteral
    end
    varName, keyLiteral = lineLeft:match("([%w_]+)%['([^'\r\n]*)'%]%s*=%s*")
    if varName then
        return varName, keyLiteral
    end
    return nil, nil
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@return string? varName
---@return string? keyLiteral
local function resolveAssignedVarAndKeyFromSources(param, textOffset)
    local function trySource(source)
        local current = source
        for _ = 1, 8 do
            if not current then
                break
            end
            local varName, keyLiteral = extractAssignedVarAndKeyFromSource(current, textOffset)
            if varName then
                return varName, keyLiteral
            end
            current = current.parent
        end
        return nil, nil
    end

    for _, source in ipairs(collectAssignmentCandidateSources(param, textOffset)) do
        local varName, keyLiteral = trySource(source)
        if varName then
            return varName, keyLiteral
        end
    end

    return resolveAssignedVarAndKeyFromLineFallback(param.scanner.text, textOffset)
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@param varName string
---@return Node.Variable?
local function findVisibleLocalVariable(param, textOffset, varName)
    local document = param.scope:getDocument(param.uri)
    ---@type any
    local source = param.sources[1]
    if not source and document then
        local sources = document:findSources(textOffset) or {}
        source = sources[1]
        if not source and textOffset > 1 then
            sources = document:findSources(textOffset - 1) or {}
            source = sources[1]
        end
    end
    if not source and document then
        local ast = document.ast
        if ast and ast.main then
            source = {
                parentBlock = findDeepestBlock(ast, textOffset),
            }
        end
    end
    if not source then
        return nil
    end

    for _, loc in ipairs(guide.getVisibleLocals(source, textOffset)) do
        if loc.id == varName then
            local var = param.scope.vm:getVariable(loc)
            if var then
                return var
            end
        end
    end

    -- In `local x = ...` initializer, `x` is not visible yet.
    -- Recover variable from localdef parent chain by table source index.
    local function findFromLocaldefParent(node)
        local current = node
        for _ = 1, 8 do
            if not current then
                break
            end

            local target = current
            if target.kind == 'tablefield' then
                target = target.parent
            end

            if target and target.kind == 'table' then
                local parent = target.parent
                local index = target.index
                if parent and parent.kind == 'localdef' and index then
                    local loc = parent.vars and parent.vars[index] or nil
                    if loc and loc.id == varName then
                        local var = param.scope.vm:getVariable(loc)
                        if var then
                            return var
                        end
                    end
                end
            end

            current = current.parent
        end
        return nil
    end

    for _, candidate in ipairs(collectAssignmentCandidateSources(param, textOffset)) do
        local var = findFromLocaldefParent(candidate)
        if var then
            return var
        end
    end

    return nil
end

--- 根据一组候选 key 节点，在变量的当前/猜测/静态值上依次调用 :get，
--- 返回第一个非 NIL/NEVER 的值节点，供直接收集字面量使用。
---@param param Feature.Completion.Param
---@param textOffset integer
---@param varName string
---@param keyNode Node.Key 候选 key
---@return any?          值节点（Node）
local function lookupTableValueNode(param, textOffset, varName, keyNode)
    local var = findVisibleLocalVariable(param, textOffset, varName)
    if not var then
        return nil
    end
    local rt = param.scope.rt

    local v, exists = var:get(keyNode)
    if exists and v and v ~= rt.NIL and v ~= rt.NEVER then
        return v
    end
    return nil
end

---@param param Feature.Completion.Param
---@param text string
---@param textOffset integer
---@return string?
local function inferFunctionTypeFromTypedClassFieldLiteralNodeView(param, text, textOffset)
    -- Extract varName and fieldKey from AST sources or line fallback.
    local varName, fieldKey = resolveAssignedVarAndKeyFromSources(param, textOffset)
    if not varName then
        local left = text:sub(1, textOffset)
        varName = left:match('local%s+([%w_]+)%s*=%s*{[^{}]*$')
    end
    if not varName then
        return nil
    end
    if not fieldKey then
        local left = text:sub(1, textOffset)
        fieldKey = left:match('([%w_]+)%s*=%s*["\'][^"\'\r\n]*$')
               or left:match('([%w_]+)%s*=%s*$')
    end
    if not fieldKey then
        return nil
    end

    -- Resolve the variable's type via Node API.
    local var = findVisibleLocalVariable(param, textOffset, varName)
    if not var then
        return nil
    end
    local rt = param.scope.rt

    local function getClassNode(node)
        if not node or node == rt.NIL or node == rt.NEVER then
            return nil
        end
        -- If the node itself is a class/type, use it directly.
        if node.kind == 'class' or node.kind == 'type' then
            return node
        end
        -- Otherwise try to resolve via view → rt.type
        local viewed = normalizeTypeExpr(node:view())
        if viewed and viewed ~= '' and not viewed:find('|', 1, true) then
            return rt.type(viewed)
        end
        return nil
    end

    local classNode = getClassNode(var.value)
    if not classNode then
        return nil
    end

    local fieldNode, exists = classNode:get(fieldKey)
    if not exists or not fieldNode then
        return nil
    end
    if not util.hasFunctionNode(fieldNode) then
        return nil
    end

    local viewed = fieldNode:view()
    if not viewed or viewed == '' then
        return nil
    end
    return viewed
end

---@param text string
---@param varName string
---@return string?
findLocalTypeExpr = function (text, varName)
    for t, localName in text:gmatch('%-%-%-@type%s+([^\r\n]+)%s*\r?\n%s*local%s+([%w_]+)') do
        if localName == varName then
            return normalizeTypeExpr(t)
        end
    end
    return nil
end

---@param text string
---@param className string
---@param fieldName string
---@return string[]
local function collectClassFieldFunctionTypes(text, className, fieldName)
    local results = {}
    local inClass = false
    for line in text:gmatch('[^\r\n]+') do
        local thisClass = line:match('^%s*%-%-%-%s*@class%s+([%w_%.]+)')
        if thisClass then
            inClass = (thisClass == className)
            goto continue
        end
        if not inClass then
            goto continue
        end

        local thisField, thisType = line:match('^%s*%-%-%-%s*@field%s+([%w_]+)%s+(.+)$')
        if thisField then
            if thisField == fieldName and thisType:match('^fun%s*%(') then
                results[#results+1] = util.trim(thisType)
            end
            goto continue
        end

        if line:match('^%s*%-%-%-%s*@') or line:match('^%s*%-%-%-') then
            goto continue
        end
        inClass = false
        ::continue::
    end
    return results
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@return string?
local function inferEnumTypeFromTypedLocalVarExpr(param, textOffset)
    local text = param.scanner.text
    local left = text:sub(1, textOffset)
    local varName = left:match('([%w_]+)%s*==%s*$')
                or left:match('([%w_]+)%s*~=%s*$')
                or left:match('([%w_]+)%s*<=%s*$')
                or left:match('([%w_]+)%s*>=%s*$')
                or left:match('([%w_]+)%s*<%s*$')
                or left:match('([%w_]+)%s*>%s*$')
                or left:match('([%w_]+)%s*=%s*$')
                or left:match('([%w_]+)%s*==%s*["\'][^"\'\r\n]*$')
                or left:match('([%w_]+)%s*~=%s*["\'][^"\'\r\n]*$')
                or left:match('([%w_]+)%s*<=%s*["\'][^"\'\r\n]*$')
                or left:match('([%w_]+)%s*>=%s*["\'][^"\'\r\n]*$')
                or left:match('([%w_]+)%s*<%s*["\'][^"\'\r\n]*$')
                or left:match('([%w_]+)%s*>%s*["\'][^"\'\r\n]*$')
                or left:match('([%w_]+)%s*=%s*["\'][^"\'\r\n]*$')
    if not varName then
        return nil
    end

    -- Try Node path: variable is visible at expression context.
    local var = findVisibleLocalVariable(param, textOffset, varName)
    if var then
        local rt = param.scope.rt
        local function inferFromNode(node)
            if not node or node == rt.NIL or node == rt.NEVER then
                return nil
            end
            local viewed = normalizeTypeExpr(node:view())
            return viewed ~= '' and viewed or nil
        end
        local inferred = inferFromNode(var.value)
        if inferred then
            return inferred
        end
    end

    -- Fallback: text scan for ---@type annotation.
    return findLocalTypeExpr(text, varName)
end

local parseFunParams
local extractParamType

---@param param Feature.Completion.Param
---@param textOffset integer
---@param varName string
---@return string?
local function inferLocalVarTypeView(param, textOffset, varName)
    local var = findVisibleLocalVariable(param, textOffset, varName)
    if var then
        local rt = param.scope.rt
        local function getView(node)
            if not node or node == rt.NIL or node == rt.NEVER then return nil end
            local v = normalizeTypeExpr(node:view())
            return v ~= '' and v or nil
        end
        local viewed = getView(var.value)
        if viewed then
            return viewed
        end
    end
    return findLocalTypeExpr(param.scanner.text, varName)
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@return string? pType
---@return string? argHead
local function inferArgTypeFromTypedFunctionVarCall(param, textOffset)
    local text = param.scanner.text
    local left = text:sub(1, textOffset)
    local rawFnName, capturedArgHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not rawFnName then
        return nil, nil
    end

    local varName = rawFnName:match('([%w_]+)$')
    if not varName then
        return nil, nil
    end

    local argIndex = 1
    for _ in capturedArgHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local declaredType = inferLocalVarTypeView(param, textOffset, varName)
    if not declaredType or not declaredType:match('^fun%s*%(') then
        return nil, nil
    end

    local params = parseFunParams(declaredType)
    local pType = extractParamType(params[argIndex])
    if not pType or pType == '' then
        return nil, nil
    end

    return pType, capturedArgHead
end


---@param funType string
---@return string[]
parseFunParams = function (funType)
    local s = funType:match('^fun%s*%((.*)%)')
    if not s then
        return {}
    end
    local params = {}
    local depth = 0
    local startPos = 1
    for i = 1, #s do
        local ch = s:sub(i, i)
        if ch == '(' then
            depth = depth + 1
        elseif ch == ')' then
            if depth > 0 then
                depth = depth - 1
            end
        elseif ch == ',' and depth == 0 then
            params[#params+1] = util.trim(s:sub(startPos, i - 1))
            startPos = i + 1
        end
    end
    local tail = util.trim(s:sub(startPos))
    if tail ~= '' then
        params[#params+1] = tail
    end
    return params
end

---@param paramDef string?
---@return string?
extractParamType = function (paramDef)
    if not paramDef then
        return nil
    end
    return util.trim((paramDef:match('^[%w_%.]+%s*:%s*(.+)$') or paramDef))
end

---@param text string
---@param rawFnName string
---@param argIndex integer
---@param isMethodCall boolean
---@return string?
local function inferArgTypeFromOverloads(text, rawFnName, argIndex, isMethodCall)
    local methodName = rawFnName:match('([%w_]+)$')
    if not methodName then
        return nil
    end
    local mappedArgIndex = isMethodCall and (argIndex + 1) or argIndex

    local pos = 1
    while true do
        local fnPos, fnEnd, fnDecl = text:find('function%s+([%w_%.:]+)%s*%(', pos)
        if not fnPos then
            break
        end
        if fnDecl and fnDecl:match('[%.:]' .. methodName .. '$') then
            local near = text:sub(math.max(1, fnPos - 600), fnPos)
            local lastOverload
            for typeExpr in near:gmatch('%-%-%-@overload%s+(fun%b())') do
                lastOverload = typeExpr
            end
            if lastOverload then
                local params = parseFunParams(lastOverload)
                local pType = extractParamType(params[mappedArgIndex])
                if pType and pType ~= '' then
                    return pType
                end
            end
        end
        pos = fnEnd + 1
    end

    return nil
end

---@param param Feature.Completion.Param
---@param textOffset integer
---@param rawFnName string
---@param argIndex integer
---@param isMethodCall boolean
---@return string?
local function inferArgTypeFromTypedFunctionVar(param, textOffset, rawFnName, argIndex, isMethodCall)
    local varName = rawFnName:match('([%w_]+)$')
    if not varName then
        return nil
    end
    local mappedArgIndex = isMethodCall and (argIndex + 1) or argIndex

    local declaredType = inferLocalVarTypeView(param, textOffset, varName)
    if declaredType then
        local params = parseFunParams(declaredType)
        local pType = extractParamType(params[mappedArgIndex])
        if pType and pType ~= '' then
            return pType
        end
    end

    -- Fallback: scan all @type fun(...) annotations in text.
    local text = param.scanner.text
    for funType, localName in text:gmatch('%-%-%-@type%s+(fun%b())%s*\r?\n%s*local%s+([%w_]+)') do
        if localName == varName then
            local params = parseFunParams(funType)
            local pType = extractParamType(params[mappedArgIndex])
            if pType and pType ~= '' then
                return pType
            end
        end
    end
    return nil
end

---@param t string?
---@return string?
local function normalizeQuotedLiteralType(t)
    if not t or t == '' then
        return nil
    end
    t = util.trim(t)
    if #t >= 2 then
        local first = t:sub(1, 1)
        local last = t:sub(-1)
        if (first == '"' and last == '"') or (first == '\'' and last == '\'') then
            t = t:sub(2, -2)
        end
    end
    if #t >= 2 and t:sub(1, 1) == '"' and t:sub(-1) == '"' then
        t = t:sub(2, -2)
    end
    return t
end

---@param text string
---@param typeExpr string?
---@return string?
local function resolveEventLiteral(text, typeExpr)
    if not typeExpr or typeExpr == '' then
        return nil
    end
    local aliasExpr = findAliasExprInText(text, normalizeTypeExpr(typeExpr))
    if aliasExpr then
        local literals = util.extractEnumLiterals(aliasExpr)
        if #literals > 0 then
            return normalizeQuotedLiteralType(literals[1])
        end
    end
    return normalizeQuotedLiteralType(typeExpr)
end

---@param literal string
---@return string
local function normalizeEnumLiteral(literal)
    if literal:match('^"\'.+\'"$') then
        return literal:sub(2, -2)
    end
    return literal
end

---@param start integer
---@param finish integer
---@param newText string
---@return any
local function makeLegacyTextEdit(start, finish, newText)
    return {
        start = start,
        finish = finish,
        newText = newText,
    }
end

---@param text string
---@param fnName string
---@param argHead string
---@param argIndex integer
---@param isMethodCall boolean
---@param objTypeName string?
---@return string?
local function inferFunctionArgTypeFromFieldOverloads(text, fnName, argHead, argIndex, isMethodCall, objTypeName)
    local mappedArgIndex = isMethodCall and (argIndex + 1) or argIndex
    if mappedArgIndex < 2 then
        return nil
    end
    local fieldName = fnName:match('[%.:]([%w_]+)$')
    if not fieldName then
        return nil
    end
    local firstArg = normalizeQuotedLiteralType(argHead:match('["\'](.-)["\']'))

    local fallback

    local function scanTypeExpr(typeExpr)
        if not typeExpr or not typeExpr:match('^fun%s*%(') then
            return nil
        end
            local params = parseFunParams(typeExpr)
            local hasSelfParam = params[1] and params[1]:match('^%s*self%s*:') ~= nil
            local eventArgIndex = (isMethodCall or hasSelfParam) and 2 or 1
            local p1Type = extractParamType(params[eventArgIndex])
            local pNType = extractParamType(params[mappedArgIndex])
            if pNType and pNType ~= '' and not pNType:match('^fun%s*%(') and not firstArg then
            return pNType
            end
            if pNType and pNType:match('^fun%s*%(') then
                fallback = fallback or pNType
                if firstArg and resolveEventLiteral(text, p1Type) == firstArg then
                return pNType
                end
            end
        return nil
    end

    if objTypeName and objTypeName ~= '' then
        local typeExprs = collectClassFieldFunctionTypes(text, objTypeName, fieldName)
        for _, typeExpr in ipairs(typeExprs) do
            local resolved = scanTypeExpr(typeExpr)
            if resolved then
                return resolved
            end
        end
        return fallback
    end

    for line in text:gmatch('[^\r\n]+') do
        local typeExpr = line:match('^%s*%-%-%-%s*@field%s+' .. fieldName .. '%s+(.+)$')
        if typeExpr then
            local resolved = scanTypeExpr(typeExpr)
            if resolved then
                return resolved
            end
        end
    end
    return fallback
end

-- 函数变量调用，参数位置的 fun(...) 类型 → 函数代码片段补全
-- e.g. `---@type fun(x: "a") local f; f(<??>)`
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local pType, argHead = inferArgTypeFromTypedFunctionVarCall(param, textOffset)
    if not pType then
        return
    end
    if not argHead then
        return
    end

    local inTableArg = argHead:find('{', 1, true) ~= nil
    if not inTableArg and normalizeTypeExpr(pType):match('%[%]$') then
        action.skip()
        return
    end

    local aliases = util.collectAliases(text)
    pType = resolveEnumTypeExprFromText(text, aliases, pType, inTableArg)
    local enums = util.extractEnumLiterals(pType)
    if #enums == 0 then
        return
    end

    action.skip()

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local inDoubleQuote = left:match('"[^"\n]*$') ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and (inSingleQuote or inDoubleQuote) then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        action.push {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = makeLegacyTextEdit(editStart, editFinish, label),
        }
        ::continue::
    end
end, 17)

-- 具名函数调用，形参类型为 fun(...) 时在调用处补全函数代码片段
-- e.g. `---@overload fun(cb: fun()) function setup(cb) end; setup(<??>)`
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local rawFnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not rawFnName then
        return
    end
    local isMethodCall = rawFnName:find(':', 1, true) ~= nil
    local fnName = rawFnName
    fnName = fnName:gsub(':', '.')

    local argIndex = 1
    for _ in argHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local objName = rawFnName:match('^([%w_]+)[%.:]')
    local objTypeName = objName and inferLocalVarTypeView(param, textOffset, objName) or nil

    local pType
    local fromFieldOverload = false

    local params, paramTypes = util.findFunctionDocParamTypes(text, fnName)
    if params and paramTypes then
        local mappedArgIndex = argIndex
        if isMethodCall then
            mappedArgIndex = mappedArgIndex + 1
        end
        local pName = params[mappedArgIndex]
        if pName then
            pType = paramTypes[pName]
        end
    end
    if not pType then
        pType = inferArgTypeFromOverloads(text, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferArgTypeFromTypedFunctionVar(param, textOffset, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferFunctionArgTypeFromFieldOverloads(text, rawFnName, argHead, argIndex, isMethodCall, objTypeName)
        fromFieldOverload = pType ~= nil
    end

    if not pType or not pType:match('^fun%s*%(') then
        return
    end

    local word = util.getCompletionWord(param)
    if word ~= '' and not (('function'):sub(1, #word) == word) then
        return
    end

    local args = pType:match('^fun%s*%((.-)%)') or ''
    local placeholders = {}
    local idx = 1
    for part in args:gmatch('[^,]+') do
        local name = util.trim(part):match('^([%w_]+)%s*:')
                  or util.trim(part):match('^([%w_]+)')
        if name and name ~= '...' then
            placeholders[#placeholders+1] = string.format('${%d:%s}', idx, name)
            idx = idx + 1
        end
    end

    local newText = string.format('function (%s)\n\t$0\nend', table.concat(placeholders, ', '))
    local editStart = util.toDisplayOffset(param, textOffset - #word)
    local editFinish = util.toDisplayOffset(param, textOffset)

    action.skip()

    if fromFieldOverload then
        action.push {
            label = pType,
            kind = ls.spec.CompletionItemKind.Function,
        }
        return
    end

    ---@type any
    local functionTypeItem = {
        label = pType,
        kind = ls.spec.CompletionItemKind.Function,
        textEdit = {
            start = editStart,
            finish = editFinish,
            newText = newText,
        }
    }
    action.push(functionTypeItem)

    action.push {
        label = 'function',
        kind = ls.spec.CompletionItemKind.Keyword,
    }
    action.push {
        label = 'function ()',
        kind = ls.spec.CompletionItemKind.Snippet,
    }
end, 16)

-- 具名函数调用，形参类型为字符串枚举时的枚举字面量补全
-- e.g. `---@param mode "r"|"w" function open(mode) end; open(<??>)`
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local rawFnName, argHead = left:match('([%w_%.:]+)%s*%(([^()]*)$')
    if not rawFnName then
        return
    end
    local isMethodCall = rawFnName:find(':', 1, true) ~= nil
    local fnName = rawFnName
    fnName = fnName:gsub(':', '.')

    local argIndex = 1
    for _ in argHead:gmatch(',') do
        argIndex = argIndex + 1
    end

    local objName = rawFnName:match('^([%w_]+)[%.:]')
    local objTypeName = objName and inferLocalVarTypeView(param, textOffset, objName) or nil

    local params, paramTypes = util.findFunctionDocParamTypes(text, fnName)
    local pType
    if params and paramTypes then
        local mappedArgIndex = argIndex
        if isMethodCall then
            mappedArgIndex = mappedArgIndex + 1
        end
        local pName = params[mappedArgIndex]
        if pName then
            pType = paramTypes[pName]
        end
    end
    if not pType then
        pType = inferArgTypeFromOverloads(text, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferArgTypeFromTypedFunctionVar(param, textOffset, rawFnName, argIndex, isMethodCall)
    end
    if not pType then
        pType = inferFunctionArgTypeFromFieldOverloads(text, rawFnName, argHead, argIndex, isMethodCall, objTypeName)
    end
    if not pType then
        return
    end

    local inTableArg = argHead:find('{', 1, true) ~= nil
    if not inTableArg and normalizeTypeExpr(pType):match('%[%]$') then
        action.skip()
        return
    end
    local aliases = util.collectAliases(text)
    pType = resolveEnumTypeExprFromText(text, aliases, pType, inTableArg)

    local enums = util.extractEnumLiterals(pType)
    if #enums == 0 then
        return
    end

    action.skip()

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local inDoubleQuote = left:match('"[^"\n]*$') ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and (inSingleQuote or inDoubleQuote) then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
        }
        item.textEdit = {
            start = editStart,
            finish = editFinish,
            newText = label,
        }
        action.push(item)
        ::continue::
    end
end, 24)

-- `---@type table<string, "a"|"b"> local x` 具名字段值补全（高优先级）
-- 处理：`x.foo = <??>` / `x["foo"] = <??>` / `local x = { foo = <??> }`
-- 须通过 AST 拿到 varName + fieldKey；无具名字段的位置不在此处理
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)
    local varName, fieldKey = resolveAssignedVarAndKeyFromSources(param, textOffset)
    if not varName or not fieldKey then
        return
    end

    local valueNode = lookupTableValueNode(param, textOffset, varName, fieldKey)
    local enums = collectStringLiteralsFromNode(valueNode)
    if #enums == 0 then
        return
    end

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local inDoubleQuote = left:match('"[^"\n]*$') ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and (inSingleQuote or inDoubleQuote) then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    action.skip()
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        action.push {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = makeLegacyTextEdit(editStart, editFinish, label),
        }
        ::continue::
    end
end, 1001)

-- 类字段类型为 fun(...) 时赋值处的函数代码片段补全
-- e.g. `---@class Foo; ---@field cb fun(x: integer); local o: Foo; o.cb = <??>` 
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)

    local funTypeLabel = inferFunctionTypeFromTypedClassFieldLiteralNodeView(param, text, textOffset)
    if not funTypeLabel or not funTypeLabel:match('^fun%s*%(') then
        return
    end

    local word = util.getCompletionWord(param)
    if word ~= '' and not (('function'):sub(1, #word) == word) then
        return
    end

    local args = funTypeLabel:match('^fun%s*%((.-)%)') or ''
    local placeholders = {}
    local idx = 1
    for part in args:gmatch('[^,]+') do
        local name = util.trim(part):match('^([%w_]+)%s*:')
                  or util.trim(part):match('^([%w_]+)')
        if name and name ~= '...' then
            placeholders[#placeholders+1] = string.format('${%d:%s}', idx, name)
            idx = idx + 1
        end
    end

    local newText = string.format('function (%s)\n\t$0\nend', table.concat(placeholders, ', '))
    local editStart = util.toDisplayOffset(param, textOffset - #word)
    local editFinish = util.toDisplayOffset(param, textOffset)

    action.skip()
    action.push {
        label = funTypeLabel,
        kind = ls.spec.CompletionItemKind.Function,
        textEdit = makeLegacyTextEdit(editStart, editFinish, newText),
    }
end, 17)

-- 局部变量赋值/比较时，从该变量的类型注解推断枚举字面量（文本路径，非表类型变量）
-- e.g. `---@type "a"|"b" local x; x == <??>` 或 `x = <??>` 
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local inferredType = inferEnumTypeFromTypedLocalVarExpr(param, textOffset)
    if not inferredType then
        return
    end

    local aliases = util.collectAliases(text)
    local resolvedType = resolveEnumTypeExprFromText(text, aliases, inferredType, false)
    local enums = util.extractEnumLiterals(resolvedType)
    if #enums == 0 then
        return
    end

    action.skip()

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local inDoubleQuote = left:match('"[^"\n]*$') ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and (inSingleQuote or inDoubleQuote) then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = makeLegacyTextEdit(editStart, editFinish, label),
        }
        action.push(item)
        ::continue::
    end
end, 24)

-- 具名字段值补全（普通优先级）
-- 处理：`t.foo = <??>` / `t["foo"] = <??>` / `local t = { foo = <??> }` 中具名字段的值位置
-- 须通过 AST 拿到 varName + fieldKey；无具名字段（数组元素）的位置不在此处理
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local varName, fieldKey = resolveAssignedVarAndKeyFromSources(param, textOffset)
    if not varName or not fieldKey or fieldKey == '' then
        return
    end

    local valueNode = lookupTableValueNode(param, textOffset, varName, fieldKey)
    local enums = collectStringLiteralsFromNode(valueNode)
    if #enums == 0 then
        return
    end

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and inSingleQuote then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    action.skip()
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        ---@type any
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = {
                start = editStart,
                finish = editFinish,
                newText = label,
            },
        }
        action.push(item)
        ::continue::
    end
end, 24)

-- 数组元素补全（表构造器数组位置，由 AST 确定当前下标）
-- 处理：`local l = {<??>}` / `local l = {x, <??>}` / `local l = {<??>, x}` 等
-- 找到包含光标的最小 table 节点，统计其中 finish < cursor 的数组元素（subtype=='exp'）个数得到下标。
-- 若光标处于具名字段（subtype~='exp'）的范围内，则跳过（交由 B2 provider 处理）。
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)

    -- 在父链中找到包含光标的最小（span 最短）table 节点，同时不在具名字段范围内
    local varName, index
    local bestSpan = math.maxinteger

    for _, source in ipairs(collectAssignmentCandidateSources(param, textOffset)) do
        local current = source
        for _ = 1, 10 do
            if not current then break end
            if current.kind == 'table'
            and current.start <= textOffset
            and textOffset <= current.finish then
                local span = current.finish - current.start
                if span < bestSpan then
                    local name = inferOwnerVarNameFromTableNode(current)
                    if name then
                        -- 若光标落在某个具名字段（field/index subtype）的范围内，属于 B2 场景
                        local inNamedField = false
                        for _, field in ipairs(current.fields or {}) do
                            if field.subtype ~= 'exp'
                            and field.start <= textOffset
                            and textOffset <= field.finish then
                                inNamedField = true
                                break
                            end
                        end
                        if not inNamedField then
                            bestSpan = span
                            -- 统计在光标之前已完成的数组元素数（finish < cursor）
                            local count = 0
                            for _, field in ipairs(current.fields or {}) do
                                if field.subtype == 'exp' and field.finish < textOffset then
                                    count = count + 1
                                end
                            end
                            varName = name
                            index   = count + 1
                        end
                    end
                end
            end
            current = current.parent
        end
    end

    if not varName then
        return
    end

    local left = text:sub(1, textOffset)

    local valueNode = lookupTableValueNode(param, textOffset, varName, index)
    local enums = collectStringLiteralsFromNode(valueNode)
    if #enums == 0 then
        return
    end

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and inSingleQuote then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    action.skip()
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        ---@type any
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = {
                start = editStart,
                finish = editFinish,
                newText = label,
            },
        }
        action.push(item)
        ::continue::
    end
end, 24)

-- 表构造器具名字段值补全（文本匹配兜底）
-- 处理：`local t = { foo = <??>}` / `local t = { ["foo"] = <??>}` 等光标在 `key =` 之后的位置
-- resolveAssignedVarAndKeyFromSources 在表构造器值位置无法解析 fieldKey，故用文本匹配兜底。
ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end

    local text = param.scanner.text
    local textOffset = param.textOffset or util.toTextOffset(text, param.offset, param)
    local left = text:sub(1, textOffset)

    local varName = left:match('local%s+([%w_]+)%s*=%s*{[^{}]*$')
    if not varName then
        return
    end

    -- 必须在 `key =` 之后才由本 provider 处理（word: foo = 或 bracket: ["foo"] = / ['foo'] =）
    local afterBrace = left:match('{([^{}]-)$') or ''
    local fieldKey = afterBrace:match('([%w_]+)%s*=%s*["\']?[^"\'\r\n,{}]*$')
                  or afterBrace:match('%[["\']([^"\']-)["\']%]%s*=%s*["\']?[^"\'\r\n,{}]*$')
    if not fieldKey then
        return
    end

    local valueNode = lookupTableValueNode(param, textOffset, varName, fieldKey)
    local enums = collectStringLiteralsFromNode(valueNode)
    if #enums == 0 then
        return
    end

    local inSingleQuote = left:match("'[^'\n]*$") ~= nil
    local word = util.getCompletionWord(param)
    local editStartOffset = textOffset - #word
    local editFinishOffset = textOffset
    if word == '' and inSingleQuote then
        editStartOffset = textOffset - 1
        editFinishOffset = textOffset + 1
    end
    local editStart = util.toDisplayOffset(param, editStartOffset)
    local editFinish = util.toDisplayOffset(param, editFinishOffset)
    local used = {}

    action.skip()
    for _, literal in ipairs(enums) do
        local label = normalizeEnumLiteral(literal)
        if inSingleQuote and literal:sub(1, 1) == '"' and literal:sub(-1) == '"' then
            label = "'" .. literal:sub(2, -2) .. "'"
        end
        if label:match('^\'".+"\'$') then
            goto continue
        end
        if label:match("^''.+''$") then
            goto continue
        end
        if used[label] then
            goto continue
        end
        used[label] = true
        ---@type any
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.EnumMember,
            textEdit = {
                start = editStart,
                finish = editFinish,
                newText = label,
            },
        }
        action.push(item)
        ::continue::
    end
end, 24)
