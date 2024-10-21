---@class File
---@field text string
---@field clientVersion? integer
---@overload fun(uri:string): self
local M = Class 'File'

M.isOpenedByClient = false

---@param uri uri
function M:__init(uri)
    self.uri = uri
end

function M:openByClient()
    self.isOpenedByClient = true
end

function M:closeByClient()
    self.isOpenedByClient = false
end

---@return string?
function M:getText()
    return self.text
end

---@param text string
function M:setText(text)
    self.newText = text
end

---@param version integer
function M:updateClientVersion(version)
    self.clientVersion = version
end

---@param uri uri
---@return File
function ls.file.create(uri)
    return New 'File' (uri)
end

return M
