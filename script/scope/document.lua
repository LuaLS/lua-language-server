---@class Document: Class.Base
local M = Class 'Document'

---@param file File
function M:__init(file)
    self.uri = file.uri
    self.text = file:getText()
    self.serverVersion = file.serverVersion
    self.clientVersion = file.clientVersion
end

---@type LuaParser.Ast
M.ast = nil

---@param self Document
---@return LuaParser.Ast | false
---@return true
M.__getter.ast = function (self)
    local suc, ast = xpcall(ls.parser.compile, log.error, self.text)
    if not suc then
        return false, true
    end
    return ast, true
end
