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
                return
            else
                error({exp, res})
            end
        end
        if exp == EXISTS then
            if res ~= nil then
                return
            else
                error({exp, res})
            end
        end
        if type(exp) ~= type(res) then
            error({exp, res})
        end
        if type(exp) == 'table' then
            -- 如果此表含 IGNORE_REST，则本层退回子集模式
            local thisExact = parentExact and not exp[IGNORE_REST]
            if thisExact then
                -- 精确匹配：检查列表长度
                local expLen = #exp
                local resLen = res and #res or 0
                if expLen ~= resLen then
                    error({exp, res})
                end
            end
            for k, v in pairs(exp) do
                if k ~= IGNORE_REST then
                    path[#path+1] = k
                    eq(v, res[k], thisExact)
                    path[#path] = nil
                end
            end
        else
            if exp ~= res then
                error({exp, res})
            end
        end
    end

    local suc, expres = pcall(eq, expect, result, exact)
    if suc then
        return
    end

    ---@cast expres any
    local exp, res = expres[1], expres[2]

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
