---@class FileManager
---@overload fun(): self
local M = Class 'FileManager'

M.version = 0

function M:__init()
    --文件表
    self.fileMap = {}
    --最近更新的文件
    self.newFiles = {}
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
---@return File
function M:openFile(uri)
    local file = self:getFile(uri)
            or   self:newFile(uri)
    file:open()
    return file
end

---@param uri uri
---@return File
function M:closeFile(uri)
    local file = self:getFile(uri)
            or   self:newFile(uri)
    file:close()
    return file
end

---@param uri uri
---@return boolean
function M:isOpened(uri)
    local file = self:getFile(uri)
    if not file then
        return false
    end
    return file.isOpened
end

---@param uri uri
---@param text string
---@return File
function M:setText(uri, text)
    local file = self:getFile(uri)
            or   self:newFile(uri)
    file:setText(text)
    self.newFiles[uri] = true
    return file
end

---@param uri uri
---@return File?
function M:removeFile(uri)
    local file = self.fileMap[uri]
    self.fileMap[uri] = nil
    return file
end

---@type Timer?
M.flushDelayTimer = nil

---@return boolean
function M:flush()
    if M.flushDelayTimer then
        M.flushDelayTimer:remove()
    end
    if not next(self.newFiles) then
        return false
    end
    local ok = false
    for uri in luals.util.sortPairs(self.newFiles) do
        local file = self:getFile(uri)
        if file and file:flush() then
            ok = true
        end
    end
    self.newFiles = {}
    return ok
end

---@param time number
function M:flushDelay(time)
    if M.flushDelayTimer then
        if M.flushDelayTimer:getRemainingTime() >= time then
            return
        end
        M.flushDelayTimer:remove()
    end
    M.flushDelayTimer = luals.timer.wait(time, M.flush)
end

return M
