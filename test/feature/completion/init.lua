---@diagnostic disable: await-in-sync

-- 确保 Match / EXISTS / NIL / IGNORE_REST 等工具可用（不走过滤器，总是加载）
require 'test.parser.ast'

---@param script string
---@return fun(expects: table[]|table|nil)
function TEST_COMPLETION(script)
    local results = TEST_FRAME(script, function (catched)
        local cursor = catched['?'][1][1]
        return ls.feature.completion(test.fileUri, cursor)
    end)

    return function (expects)
        -- 自定义断言函数
        if type(expects) == 'function' then
            expects(results)
            return
        end
        -- nil 表示期望没有结果
        if expects == nil then
            if results == nil or #results == 0 then
                return
            end
            error(string.format('期望无补全结果，但得到了 %d 个：%s\n脚本片段:\n%s', #results, ls.inspect(results), script))
        end
        -- EXISTS 表示期望有结果（不关心具体内容）
        if expects == EXISTS then
            if results and #results > 0 then
                return
            end
            error(string.format('期望有补全结果，但结果为空\n脚本片段:\n%s', script))
        end
        if type(expects) == 'table' and expects.include == true then
            expects = table.move(expects, 1, #expects, 1, {})
            expects[IGNORE_REST] = true
        end
        -- 精确匹配列表
        Match(results, expects, true)
    end
end

test.require 'test.feature.completion.word'
test.require 'test.feature.completion.keyword'
test.require 'test.feature.completion.field'
test.require 'test.feature.completion.luadoc'
test.require 'test.feature.completion.string'
test.require 'test.feature.completion.postfix'
test.require 'test.feature.completion.special'
-- test.require 'test.feature.completion.continue'  -- 旧系统测试，依赖已删除的 proto.define
