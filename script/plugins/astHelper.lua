local luadoc = require 'parser.luadoc'
local ssub = require 'core.substring'
local guide = require 'parser.guide'
local _M = {}

function _M.buildComment(t, value)
    return {
        type   = 'comment.short',
        start  = 1,
        finish = 1,
        text   = "-@" .. t .. " " .. value,
    }
end

function _M.InsertDoc(ast, comm)
    local comms = ast.state.comms or {}
    comms[#comms+1] = comm
    ast.state.comms = comms
end

--- give the local/global variable add doc.class
---@param ast parser.object
---@param source parser.object local/global variable
---@param classname string
function _M.addClassDoc(ast, source, classname)
    if source.type ~= 'local' and not guide.isGlobal(source) then
        return false
    end
    --TODO fileds
    --TODO callers
    local comment = _M.buildComment("class", classname)
    comment.start = source.start - 1
    comment.finish = comment.start

    return luadoc.buildAndBindDoc(ast, source, comment)
end

---remove `ast` function node `index` arg, the variable will be the function local variable
---@param source parser.object function node
---@param index integer
---@return parser.object?
function _M.removeArg(source, index)
    if source.type == 'function' then
        local arg = table.remove(source.args, index)
        if not arg then
            return nil
        end
        arg.parent = arg.parent.parent
        return arg
    end
    return nil
end

--- 把特定函数当成构造函数,`index` 参数是self
---@param classname string
---@param source parser.object function node
---@param index integer
function _M.addClassDocAtParam(ast, classname, source, index)
    local arg = _M.removeArg(source, index)
    if arg then
        return _M.addClassDoc(ast, arg, classname)
    end
    return false
end

return _M
