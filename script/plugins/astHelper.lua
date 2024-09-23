local luadoc = require 'parser.luadoc'
local guide = require 'parser.guide'
local _M = {}

function _M.buildComment(t, value, pos)
    return {
        type    = 'comment.short',
        start   = pos,
        finish  = pos,
        text    = "-@" .. t .. " " .. value,
        virtual = true
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
---@param group table?
function _M.addClassDoc(ast, source, classname, group)
    return _M.addDoc(ast, source, "class", classname, group)
end

--- give the local/global variable a luadoc comment
---@param ast parser.object
---@param source parser.object local/global variable
---@param key string
---@param value string
---@param group table?
function _M.addDoc(ast, source, key, value, group)
    if source.type ~= 'local' and not guide.isGlobal(source) then
        return false
    end
    local comment = _M.buildComment(key, value, source.start - 1)
    local doc = luadoc.buildAndBindDoc(ast, source, comment, group)
	if group then
		group[#group+1] = doc
	end
	return doc
end

---remove `ast` function node `index` arg, the variable will be the function local variable
---@param source parser.object function node
---@param index integer
---@return parser.object?
function _M.removeArg(source, index)
    if source.type == 'function' or source.type == 'call' then
        local arg = table.remove(source.args, index)
        if not arg then
            return nil
        end
        arg.parent = arg.parent.parent
        return arg
    end
    return nil
end

---把特定函数当成构造函数,`index` 参数是self
---@param classname string
---@param source parser.object function node
---@param index integer
---@return boolean, parser.object?
function _M.addClassDocAtParam(ast, classname, source, index)
    local arg = _M.removeArg(source, index)
    if arg then
        return not not _M.addClassDoc(ast, arg, classname), arg
    end
    return false
end

---把函数参数绑定类型
---@param ast parser.object
---@param typename string
---@param source parser.object
function _M.addParamTypeDoc(ast, typename, source)
    if not guide.isParam(source) then
        return false
    end
    local paramname = guide.getKeyName(source)
    if not paramname then
        return false
    end
    local comment = _M.buildComment("param",
        ('%s %s'):format(paramname, typename),
        source.start - 1)

    return luadoc.buildAndBindDoc(ast, source.parent.parent, comment)
end

return _M
