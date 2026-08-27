NIL          = {'<NIL>'}
EXISTS       = {'<EXISTS>'}
IGNORE_REST  = '<IGNORE_REST>'

---@param result any
---@param expect any
---@param exact? boolean # 为 true 时要求列表长度完全一致（精确匹配）
function Match(result, expect, exact)
    local path = {}

    local function eq(exp, res, parentExact)
        if exp == NIL then
            if res == nil then
                return true
            end
            return false, exp, res
        end
        if exp == EXISTS then
            if res ~= nil then
                return true
            end
            return false, exp, res
        end
        if type(exp) ~= type(res) then
            return false, exp, res
        end
        if type(exp) == 'table' then
            -- 如果此表含 IGNORE_REST，则本层退回子集模式
            local thisExact = parentExact and not exp[IGNORE_REST]
            if thisExact then
                -- 精确匹配：检查列表长度
                local expLen = #exp
                local resLen = res and #res or 0
                if expLen ~= resLen then
                    return false, exp, res
                end
            elseif not thisExact and parentExact and exp[IGNORE_REST] then
                -- 无序子集：期望数组每项在结果中存在一个匹配即可
                for i = 1, #exp do
                    local found = false
                    for j = 1, (res and #res or 0) do
                        local mark = #path
                        local ok = eq(exp[i], res[j], true)
                        if not ok then
                            for k = #path, mark + 1, -1 do
                                path[k] = nil
                            end
                        else
                            found = true
                            break
                        end
                    end
                    if not found then
                        path[#path+1] = i
                        return false, exp[i], '<missing>'
                    end
                end
                return true
            end
            for k, v in pairs(exp) do
                if k ~= IGNORE_REST then
                    path[#path+1] = k
                    local ok = eq(v, res[k], thisExact)
                    path[#path] = nil
                    if not ok then
                        return false, v, res[k]
                    end
                end
            end
            return true
        else
            if exp ~= res then
                return false, exp, res
            end
            return true
        end
    end

    local ok, exp, res = eq(expect, result, exact)
    if ok then
        return
    end

    local fullPath = {}
    for i, k in ipairs(path) do
        if type(k) == 'number' then
            fullPath[i] = '[' .. k .. ']'
        else
            if i == 1 then
                fullPath[i] = k
            else
                fullPath[i] = '.' .. k
            end
        end
    end
    error(string.format('结果不一致！路径：`%s`，期望：`%s`，结果：`%s`'
        , table.concat(fullPath)
        , ls.inspect(exp)
        , ls.inspect(res)
    ))
end

require 'parser'

require 'test.parser.ast.nil'
require 'test.parser.ast.boolean'
require 'test.parser.ast.string'
require 'test.parser.ast.number'
require 'test.parser.ast.comment'
require 'test.parser.ast.local'
require 'test.parser.ast.table'
require 'test.parser.ast.exp'
require 'test.parser.ast.state'
require 'test.parser.ast.block'
require 'test.parser.ast.main'
require 'test.parser.ast.cat'
require 'test.parser.ast.optchain'
