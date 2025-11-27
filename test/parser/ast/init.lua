NIL = {'<NIL>'}

---@param result any
---@param expect any
function Match(result, expect)
    for k, v in pairs(expect) do
        if v == NIL then
            assert(result[k] == nil)
            return
        end
        if type(v) == 'table' then
            Match(result[k], v)
        else
            assert(result[k] == v)
        end
    end
end

require 'parser'

require 'test.ast.nil'
require 'test.ast.boolean'
require 'test.ast.string'
require 'test.ast.number'
require 'test.ast.comment'
require 'test.ast.local'
require 'test.ast.table'
require 'test.ast.exp'
require 'test.ast.state'
require 'test.ast.block'
require 'test.ast.main'
require 'test.ast.cats'
