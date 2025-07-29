---@class File: Class.Base
---@field text string
---@field clientVersion? integer
---@overload fun(uri:string): self
local M = Class 'File'

M.openedByClient = false
M.serverVersion = 0

---@param uri Uri
function M:__init(uri)
    self.uri = uri

    ls.file.all[uri] = self
end

function M:__del()
    ls.file.all[self.uri] = nil
end

function M:__close()
    self:remove()
end

function M:openByClient()
    self.openedByClient = true
end

function M:closeByClient()
    self.openedByClient = false
end

function M:isOpenedByClient()
    return self.openedByClient
end

---@return string?
function M:getText()
    return self.text
end

---@param text string
function M:setText(text)
    if self.text == text then
        return
    end
    self.text = text
    self.serverVersion = self.serverVersion + 1
end

---@param version integer
function M:updateClientVersion(version)
    self.clientVersion = version
end

function M:remove()
    Delete(self)
end

---@type table<Uri, File>
ls.file.all = ls.fs.newMap()

---@param uri Uri
---@return File
function ls.file.create(uri)
    return New 'File' (uri)
end

---@param uri Uri
---@return File?
function ls.file.get(uri)
    return ls.file.all[uri]
end

---@param uri Uri
---@param clientVersion? integer
---@return File
function ls.file.openByClient(uri, clientVersion)
    local file = ls.file.get(uri)
            or   ls.file.create(uri)
    file:openByClient()
    if clientVersion then
        file:updateClientVersion(clientVersion)
    end
    return file
end

---@param uri Uri
---@return File?
function ls.file.closeByClient(uri)
    local file = ls.file.get(uri)
    if not file then
        return nil
    end
    file:closeByClient()
    return file
end

---@param uri Uri
---@return boolean
function ls.file.isOpenedByClient(uri)
    local file = ls.file.get(uri)
    if not file then
        return false
    end
    return file:openedByClient()
end

---@param uri Uri
---@param text string
---@param clientVersion? integer
---@return File
function ls.file.setText(uri, text, clientVersion)
    local file = ls.file.get(uri)
            or   ls.file.create(uri)
    file:setText(text)
    if clientVersion then
        file:updateClientVersion(clientVersion)
    end
    return file
end

---@param uri Uri
---@return File?
function ls.file.remove(uri)
    local file = ls.file.get(uri)
    if file then
        file:remove()
    end
    return file
end

---@param uri Uri
---@return Uri
function ls.file.getRealUri(uri)
    local file = ls.file.get(uri)
    if not file then
        return uri
    end
    return file.uri
end

return M
