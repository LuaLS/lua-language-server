---@type Feature.Provider<Feature.Completion.Param>
local providers    = ls.feature.helper.providers()
local guide        = require 'parser.guide'
local TextScanner  = require 'feature.text-scanner'

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

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
        scanner = scanner,
    }

    local results = providers.runner(param)

    return results
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

-- 当前作用域内的局部变量补全
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
        if ls.util.stringSimilar(word, name, true) then
            names[#names+1] = name
        end
    end
    table.sort(names, ls.util.stringLess)

    for _, name in ipairs(names) do
        action.push {
            label = name,
            kind  = ls.spec.CompletionItemKind.Variable,
        }
    end
end)

-- 全局变量补全
ls.feature.provider.completion(function (param, action)
    local word = param.scanner:getWordBack()

    -- 通过 guide.getLocal 找到此处可见的 _ENV local 节点（支持 _ENV 被局部覆盖）
    local document = param.scope:getDocument(param.uri)
    if not document then
        return
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

    -- 收集匹配的全局变量名并排序
    local names = {}
    for name, var in pairs(childs) do
        if  type(name) == 'string'
        and var:hasAssign()
        and ls.util.stringSimilar(word, name, true) then
            names[#names+1] = name
        end
    end
    table.sort(names, ls.util.stringLess)

    for _, name in ipairs(names) do
        action.push {
            label = name,
            kind  = ls.spec.CompletionItemKind.Field,
        }
    end
end)
