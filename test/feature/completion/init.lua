---@diagnostic disable: await-in-sync

-- 确保 Match / EXISTS / NIL / IGNORE_REST 等工具可用（不走过滤器，总是加载）
require 'test.parser.ast'

---@param script string
---@return fun(expects: table[]|table|nil|fun(results: any[]?))
function TEST_COMPLETION(script)
    local results = TEST_FRAME(script, function (catched)
        local cursor = catched['?'][1][1]
        return ls.feature.completion(test.fileUri, cursor)
    end)

    ---@param item any
    ---@param rule any
    ---@return boolean
    local function matchRule(item, rule)
        if type(rule) == 'function' then
            return rule(item) == true
        end
        if type(rule) ~= 'table' then
            -- 简写：care = <kind>
            return item.kind == rule
        end
        -- 数组规则：任意一条命中即可
        if #rule > 0 then
            for _, sub in ipairs(rule) do
                if matchRule(item, sub) then
                    return true
                end
            end
            return false
        end
        -- 哈希规则：字段子集匹配
        for k, v in pairs(rule) do
            if type(v) == 'table' and #v > 0 then
                local ok = false
                for _, vv in ipairs(v) do
                    if item[k] == vv then
                        ok = true
                        break
                    end
                end
                if not ok then
                    return false
                end
            else
                if item[k] ~= v then
                    return false
                end
            end
        end
        return true
    end

    ---@param all any[]?
    ---@param care any
    ---@return any[]
    local function filterByCare(all, care)
        if not care then
            return all or {}
        end
        if type(all) ~= 'table' then
            return {}
        end
        local filtered = {}
        for _, item in ipairs(all) do
            if matchRule(item, care) then
                filtered[#filtered+1] = item
            end
        end
        return filtered
    end

    local function normalizeLegacyExpectedTextEdit(value)
        if type(value) ~= 'table' then
            return value
        end
        if value.textEdit and type(value.textEdit) == 'table' then
            local te = value.textEdit
            if te.start and te.finish and not te.range then
                local s = te.start
                local f = te.finish
                te.range = {
                    start = {
                        line = s // 10000,
                        character = s % 10000,
                    },
                    ['end'] = {
                        line = f // 10000,
                        character = f % 10000,
                    },
                }
                te.start = nil
                te.finish = nil
            end
        end
        for _, v in pairs(value) do
            normalizeLegacyExpectedTextEdit(v)
        end
        return value
    end

    return function (expects)
        local finalResults = results

        -- 自定义断言函数
        if type(expects) == 'function' then
            expects(finalResults)
            return
        end
        -- nil 表示期望没有结果
        if expects == nil then
            if finalResults == nil or #finalResults == 0 then
                return
            end
            error(string.format('期望无补全结果，但得到了 %d 个：%s\n脚本片段:\n%s', #finalResults, ls.inspect(finalResults), script))
        end
        -- EXISTS 表示期望有结果（不关心具体内容）
        if expects == EXISTS then
            if finalResults and #finalResults > 0 then
                return
            end
            error(string.format('期望有补全结果，但结果为空\n脚本片段:\n%s', script))
        end
        if type(expects) == 'table' and expects.care ~= nil then
            finalResults = filterByCare(finalResults, expects.care)
            expects = table.move(expects, 1, #expects, 1, {})
            if expects.include == true then
                expects.include = true
            end
        end
        if type(expects) == 'table' and expects.include == true then
            expects = table.move(expects, 1, #expects, 1, {})
            expects[IGNORE_REST] = true
        end
        normalizeLegacyExpectedTextEdit(expects)
        -- 精确匹配列表
        Match(finalResults, expects, true)
    end
end

test.require 'test.feature.completion.word'
test.require 'test.feature.completion.keyword'
test.require 'test.feature.completion.field'
test.require 'test.feature.completion.luadoc'
test.require 'test.feature.completion.string'
test.require 'test.feature.completion.postfix'
test.require 'test.feature.completion.special'
test.require 'test.feature.completion.continue'
