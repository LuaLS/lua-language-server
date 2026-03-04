---@type Feature.Provider<Feature.Completion.Param>
local providers = ls.feature.helper.providers()
local guide = require 'parser.guide'

---@class Feature.Completion.Param
---@field uri Uri
---@field offset integer
---@field scope Scope
---@field sources LuaParser.Node.Base[]

---@param uri Uri
---@param offset integer
---@return LSP.CompletionItem[]
function ls.feature.completion(uri, offset)
    local sources, scope = ls.scope.findSources(uri, offset)
    if not scope then
        return {}
    end

    local param = {
        uri     = uri,
        offset  = offset,
        scope   = scope,
        sources = sources,
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
    if not source or source.kind ~= 'var' then
        return
    end
    ---@cast source LuaParser.Node.Var
    local word = source.id
    if not word or word == '' then
        return
    end

    local locals = guide.getVisibleLocals(source, param.offset)
    for _, loc in ipairs(locals) do
        local name = loc.id
        -- 简单前缀匹配（排除自身）
        if name ~= word and name:sub(1, #word) == word then
            action.push {
                label = name,
                kind  = ls.spec.CompletionItemKind.Variable,
            }
        end
    end
end)
