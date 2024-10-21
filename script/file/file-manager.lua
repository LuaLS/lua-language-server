---@class FileManager
---@overload fun(ignoreCase?: boolean): self
local M = Class 'FileManager'

---@param ignoreCase? boolean
function M:__init(ignoreCase)
    --文件表
    if ignoreCase then
        self.fileMap = ls.caselessTable.create()
    else
        self.fileMap = {}
    end
end

--获取文件
---@param uri uri
---@return File?
function M:getFile(uri)
    local file = self.fileMap[uri]
    return file
end

---@param uri uri
---@return File
function M:newFile(uri)
    local file = New 'File' (uri)
    self.fileMap[uri] = file
    return file
end

---@param uri uri
---@param clientVersion? integer
---@return File
function M:openFile(uri, clientVersion)
    local file = self:getFile(uri)
            or   self:newFile(uri)
    file:openByClient()
    if clientVersion then
        file:updateClientVersion(clientVersion)
    end
    return file
end

---@param uri uri
---@return File
function M:closeFile(uri)
    local file = self:getFile(uri)
            or   self:newFile(uri)
    file:closeByClient()
    return file
end

---@param uri uri
---@return boolean
function M:isOpenedByClient(uri)
    local file = self:getFile(uri)
    if not file then
        return false
    end
    return file.isOpenedByClient
end

---@param uri uri
---@param text string
---@param clientVersion? integer
---@return File
function M:setText(uri, text, clientVersion)
    local file = self:getFile(uri)
            or   self:newFile(uri)
    file:setText(text)
    if clientVersion then
        file:updateClientVersion(clientVersion)
    end
    self.fileMap[uri] = true
    return file
end

---@param uri uri
---@return File?
function M:removeFile(uri)
    local file = self.fileMap[uri]
    self.fileMap[uri] = nil
    return file
end

ls.file.manager = New 'FileManager' ()
