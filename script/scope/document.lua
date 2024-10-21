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
---@return LuaParser.Ast
---@return true
M.__getter.ast = function (self)
    local ast = ls.parser.compile(self.text)
    return ast, true
end
