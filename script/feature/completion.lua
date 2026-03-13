---@type Feature.Provider<Feature.Completion.Param>
local providers    = ls.feature.helper.providers()
local guide        = require 'parser.guide'
require 'feature.text-scanner'

---@class Feature.Completion.Param
---@field uri     Uri
---@field offset  integer
---@field scope   Scope
---@field sources LuaParser.Node.Base[]
---@field scanner Feature.TextScanner

---@param uri Uri
---@param offset integer
---@return LSP.CompletionItem[]
function ls.feature.completion(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not scope then
        return {}
    end

    local text    = ls.file.get(uri):getText()
    local scanner = New 'Feature.TextScanner' (text, offset)

    -- `function f(a, <??>)` / `function (a, <??>)` 参数定义空位不做补全
    local word = scanner:getWordBack()
    if word == '' then
        local left = text:sub(1, offset)
        if  left:match('function%s+[%w_%.:]+%s*%([^()%[%]{}\n]*$')
        or  left:match('function%s*%([^()%[%]{}\n]*$') then
            return {}
        end
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
        scanner = scanner,
    }

    return providers.runner(param)
end

---@param callback fun(param: Feature.Completion.Param, action: Feature.ProviderActions<LSP.CompletionItem>)
---@param priority integer? # 优先级
---@return fun() disposable
function ls.feature.provider.completion(callback, priority)
    providers.queue:insert(callback, priority)
    return function ()
        providers.queue:remove(callback)
    end
end

-- Lua 关键字列表
local LUA_KEYWORDS = {
    'and', 'break', 'do', 'else', 'elseif', 'end',
    'for', 'function', 'if', 'in', 'local', 'not',
    'or', 'repeat', 'return', 'then', 'until', 'while',
    'true', 'false', 'nil',
}

--- 判断当前补全位置是否处于"语句"位置（即可以写语句的 block 上下文）。
--- 使用词法规则：
---   - 行首/文件首可视为语句位置
---   - `.` `:` `(` `[` `{` `,` `=` 后不是语句位置
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

-- 关键字补全（priority=0，field provider 的 skip() 会阻止本 provider）
-- 仅在语句位置（block 上下文）才补全关键字
ls.feature.provider.completion(function (param, action)
    local word = param.scanner:getWordBack()
    if word == '' then
        return
    end

    -- 只在语句位置补全关键字
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

-- 当前作用域内的局部变量补全（priority=0）
ls.feature.provider.completion(function (param, action)
    local source = param.sources[1]
    if not source then
        return
    end

    local word = param.scanner:getWordBack()

    local locals = guide.getVisibleLocals(source, param.offset)
    local names  = {}
    for _, loc in ipairs(locals) do
        local name = loc.id
        -- 跳过 Lua 内部隐式局部变量
        if name == '_ENV' then
            goto continue
        end
        -- 跳过当前正在定义的变量自身（光标在其定义 AST 节点范围内）
        if loc.start <= param.offset and loc.finish >= param.offset then
            goto continue
        end
        if ls.util.stringSimilar(word, name, true) then
            names[#names+1] = name
        end
        ::continue::
    end
    table.sort(names, ls.util.stringLess)

    for _, name in ipairs(names) do
        action.push {
            label = name,
            kind  = ls.spec.CompletionItemKind.Variable,
        }
    end
end)

--- 根据 Node.Field 的值和访问方式判断补全 kind。
---@param fieldNode Node.Field?
---@param trigger   string  # '.' 或 ':'
---@return integer
local function fieldCompletionKind(fieldNode, trigger)
    -- valueMap 中存的是 Node.Field，通过 .value.truly 递归解引用到真实值节点
    local valueNode = fieldNode and fieldNode.value.truly
    if valueNode and valueNode.kind == 'function' then
        return trigger == ':'
               and ls.spec.CompletionItemKind.Method
               or  ls.spec.CompletionItemKind.Function
    end
    return ls.spec.CompletionItemKind.Field
end

-- 字段访问补全（t.xxx / t:xxx / fun().xxx），priority=10 确保先于局部/全局 provider 执行
ls.feature.provider.completion(function (param, action)
    -- 用 getFieldTriggerBack 检测是否是字段访问，同时得到字段前缀 word 和对象末尾 offset
    local trigger, objEnd, word = param.scanner:getFieldTriggerBack()
    if not trigger then
        return
    end

    -- 通过 objEnd offset 在语法树里找到对象表达式对应的 AST 节点
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

    -- 通过 vm:getNode 将 AST 节点转为 Node，查询其 keys
    local objNode = param.scope.vm:getNode(objSource)
    if not objNode then
        return
    end

    -- 确认是字段访问上下文，阻止低优先级 provider 继续运行
    action.skip()

    -- 通过 Node.keys 枚举所有字符串字段，收集匹配的候选项
    local keys = objNode.keys
    if not keys then
        return
    end

    local matches = {}
    for _, keyNode in ipairs(keys) do
        -- 只关心字符串字面量 key
        if keyNode.kind == 'value' and type(keyNode.literal) == 'string' then
            local name = keyNode.literal
            ---@cast name string
            if ls.util.stringSimilar(word, name, true) then
                -- valueMap 的 key 经过 luaKey 转换，对于字符串字面量就是字符串本身
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
        action.push {
            label = item.name,
            kind  = fieldCompletionKind(item.valueNode, trigger),
        }
    end
end, 10)

-- 全局变量补全（priority=0）
ls.feature.provider.completion(function (param, action)
    local source = param.sources[1]
    local word   = param.scanner:getWordBack()

    local document = param.scope:getDocument(param.uri)
    if not document then
        return
    end

    -- 收集当前可见的局部变量名，用于排除被遮蔽的全局变量
    local shadowedByLocal = {}
    if source then
        for _, loc in ipairs(guide.getVisibleLocals(source, param.offset)) do
            shadowedByLocal[loc.id] = true
        end
    end

    local envLocal = guide.getEnvLocal(document.ast, param.offset)
    if not envLocal then
        return
    end
    local envVar = param.scope.vm:getVariable(envLocal)
    if not envVar then
        return
    end
    -- _ENV 的 Variable 通常是 VAR_G 的 masterVariable 别名，需要取主变量
    local childs = envVar:getMasterVariable().childs
    if not childs then
        return
    end

    local matches = {}
    for name, var in pairs(childs) do
        if  type(name) == 'string'
        and not shadowedByLocal[name]
        and var:isDefined()
        and ls.util.stringSimilar(word, name, true) then
            matches[#matches+1] = { name = name, var = var }
        end
    end
    table.sort(matches, function (a, b)
        return ls.util.stringLess(a.name, b.name)
    end)

    for _, item in ipairs(matches) do
        local value = item.var:getStaticValue()
        local kind  = value.kind == 'function'
                    and ls.spec.CompletionItemKind.Function
                    or  ls.spec.CompletionItemKind.Field
        action.push {
            label = item.name,
            kind  = kind,
        }
    end
end)
