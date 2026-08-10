-- 上下文词（workspaceWord）补全 provider
-- 提供工作区中出现的词作为 Text 补全项，遵循 Lua.completion.showWord 三态：
--   Enable   ：总是显示上下文词
--   Fallback ：仅当其他 provider 未给出语义结果时显示（默认）
--   Disable  ：不显示
-- 以及 Lua.completion.workspaceWord（是否包含其他文件中的词）。
--
-- 词来源分两层（复用既有语义设施，不做源码重扫）：
--   1. 当前文档词（document.words），无前缀长度限制 —— 覆盖 `local f<??>` 等 1 字符前缀场景
--   2. 工作区词（Scope.WordIndex），需至少 2 字符前缀 —— 避免 1 字符的噪声建议
--
-- 注意：priority 必须 > runner 的初始 skipPriorty（-1），否则该 provider 永远不会被执行。

local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
    if param.inComment or param.inLuaDoc then
        return
    end
    if param.inString then
        return
    end

    local word = util.getCompletionWord(param)
    if word == '' then
        return
    end

    -- `#`（长度操作符）后是完整变量位置，不做词补全
    local _, wordStart = param.scanner:getWordBack()
    if wordStart > 1 and param.scanner.text:sub(wordStart - 1, wordStart - 1) == '#' then
        return
    end

    local showWord = param.scope.config:get(param.uri, 'Lua.completion.showWord')
    if showWord == nil then
        showWord = 'Fallback'
    end
    if showWord == 'Disable' then
        return
    end
    if showWord == 'Fallback' and action.has(function () return true end) then
        return
    end

    local lowerWord = word:lower()

    -- 第一层：当前文档词（词长度 >= 3），无前缀长度限制
    ---@type table<string, true>
    local pushed = {}
    local document = param.scope:getDocument(param.uri)
    if document then
        for str in pairs(document.words) do
            if #str >= 3
            and str ~= word
            and str:sub(1, #word):lower() == lowerWord
            and not pushed[str]
            and not action.hasWord(str) then
                pushed[str] = true
                action.push {
                    label = str,
                    kind = ls.spec.CompletionItemKind.Text,
                }
            end
        end
    end

    -- 第二层：工作区词（workspaceWord），需至少 2 字符前缀
    if param.scope.config:get(param.uri, 'Lua.completion.workspaceWord') ~= false
    and #word >= 2 then
        for _, name in ipairs(param.scope.wordIndex:match(word)) do
            if name ~= word
            and not pushed[name]
            and not action.hasWord(name) then
                action.push {
                    label = name,
                    kind = ls.spec.CompletionItemKind.Text,
                }
            end
        end
    end
end, 0)
