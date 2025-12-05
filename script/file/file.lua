require 'filesystem'

---@class File: Class.Base, GCHost
---@field serverText string
---@field clientText? string
---@field clientVersion? integer
---@overload fun(uri:string): self
local M = Class 'File'

M.clientVersion = -1

Extends('File', 'GCHost')

---@param uri Uri
function M:__init(uri)
    self.uri = uri
    self.onDidChange = ls.sevent.create()

    ls.file.all[uri] = self
end

function M:__del()
    ls.file.all[self.uri] = nil
    ls.file.onDidRemove:fire(self.uri)
end

function M:__close()
    self:remove()
end

function M:isOpenedByClient()
    return self.clientText ~= nil
end

---@return string?
function M:getText()
    return self.clientText or self.serverText
end

---@param text string
function M:setServerText(text)
    if self.serverText == text then
        return
    end
    local oldText = self:getText()
    self.serverText = text
    if self:getText() == oldText then
        return
    end
    self.onDidChange:fire()
    ls.file.onDidChange:fire(self.uri)
end

---@param text string
---@param version integer
function M:setClientText(text, version)
    if version <= self.clientVersion then
        return
    end
    self.clientVersion = version
    if self.clientText == text then
        return
    end
    local oldText = self:getText()
    self.clientText = text
    if self:getText() == oldText then
        return
    end
    self.onDidChange:fire()
    ls.file.onDidChange:fire(self.uri)
end

function M:removeByClient()
    self.clientText = nil
    if not self.serverText then
        self:remove()
    end
end

function M:removeByServer()
    self.serverText = nil
    if not self.clientText then
        self:remove()
    end
end

function M:remove()
    Delete(self)
end

---@type table<Uri, File>
ls.file.all = ls.fs.newMap()

ls.file.onDidRemove = ls.sevent.create()
ls.file.onDidChange = ls.sevent.create()

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
---@return boolean
function ls.file.isOpenedByClient(uri)
    local file = ls.file.get(uri)
    if not file then
        return false
    end
    return file:isOpenedByClient()
end

---@param uri Uri
---@param text string
---@return File
function ls.file.setServerText(uri, text)
    local file = ls.file.get(uri)
            or   ls.file.create(uri)
    file:setServerText(text)
    return file
end

---@param uri Uri
---@param text string
---@param version integer
---@return File
function ls.file.setClientText(uri, text, version)
    local file = ls.file.get(uri)
            or   ls.file.create(uri)
    file:setClientText(text, version)
    return file
end

---@param uri Uri
---@return File?
function ls.file.removeByServer(uri)
    local file = ls.file.get(uri)
    if file then
        file:removeByServer()
    end
    return file
end

---@param uri Uri
---@return File?
function ls.file.removeByClient(uri)
    local file = ls.file.get(uri)
    if file then
        file:removeByClient()
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
