local parser = require 'parser'

---@class File
---@field text? string
---@field ast? LuaParser.Ast
---@overload fun(uri:string): self
local M = Class 'File'

M.isOpened = false

---@param uri uri
function M:__init(uri)
    
end

function M:open()
    self.isOpened = true
end

function M:close()
    self.isOpened = false
end

---@return string
function M:getText()
    return self.text
end

---@param text string
function M:setText(text)
    self.text = text
end

---@return LuaParser.Ast
function M:compileAst()
    local ast = parser.compile(self.text)
    return ast
end

return M
