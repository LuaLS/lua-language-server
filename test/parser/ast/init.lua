NIL = {'<NIL>'}

---@param result any
---@param expect any
function Match(result, expect)
    local path = {}

    local function eq(exp, res)
        if exp == NIL then
            if res == nil then
                return
            else
                error({exp, res})
            end
        end
        if type(exp) ~= type(res) then
            error({exp, res})
        end
        if type(exp) == 'table' then
            for k, v in pairs(exp) do
                path[#path+1] = k
                eq(v, res[k])
                path[#path] = nil
            end
        else
            if exp ~= res then
                error({exp, res})
            end
        end
    end

    local suc, expres = pcall(eq, expect, result)
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
        , exp
        , res
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
