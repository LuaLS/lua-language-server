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
