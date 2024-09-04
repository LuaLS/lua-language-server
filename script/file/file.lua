local parser = require 'parser'

---@class File
---@field private newText? string
---@field text? string
---@field ast? LuaParser.Ast
---@overload fun(uri:string): self
local M = Class 'File'

M.isOpened = false

---@param uri uri
function M:__init(uri)
    self.uri = uri
end

function M:open()
    self.isOpened = true
end

function M:close()
    self.isOpened = false
end

--获取语义使用的文件内容（已flush过）
---@return string?
function M:getText()
    return self.text
end

--获取最新的文件内容（未flush过）
---@return string?
function M:getNewText()
    return self.newText or self.text
end

--要调用 `flush` 才能更新文件内容
---@param text string
function M:setText(text)
    self.newText = text
end

---@return boolean
function M:flush()
    if not self.newText then
        return false
    end
    self.text = self.newText
    self.newText = nil
    self.ast = nil
    return true
end

---@return LuaParser.Ast?
function M:compileAst()
    if self.ast then
        return self.ast
    end
    if not self.text then
        return nil
    end
    self.ast = parser.compile(self.text)
    return self.ast
end

return M
