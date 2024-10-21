---@class Document
local M = Class 'Document'

---@param file File
function M:__init(file)
    self.uri = file.uri
    self.text = file:getText()
    self.serverVersion = file.serverVersion
    self.clientVersion = file.clientVersion
end
