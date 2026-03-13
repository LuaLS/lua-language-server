local markdown = require 'tools.markdown'

local M = {}

---@param view string?
---@return string?
function M.toLuaCodeBlock(view)
    if not view or view == '' then
        return nil
    end
    return markdown.create()
        : append('lua', view)
        : string()
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return string?
function M.getSourceView(scope, source)
    local node = scope.vm:getNode(source)
    if node then
        return node:view()
    end
    return source.code
end

return M
