local file = require 'files.file'

---@class files
local mt = {}
mt.__index = mt
mt.type = 'files'
mt._fileCount = 0
---@type table<uri, file>
mt._files = nil

---@param uri uri
---@param text string
function mt:save(uri, text, version)
    local f = self._files[uri]
    if not f then
        f = file(uri)
        self._files[uri] = f
        self._fileCount = self._fileCount + 1
    end
    f:setText(text)
    f:setVersion(version)
end

---@param uri uri
function mt:remove(uri)
    local f = self._files[uri]
    if not f then
        return
    end

    f:remove()
    self._files[uri] = nil
    self._fileCount = self._fileCount - 1
end

---@param uri uri
function mt:open(uri, text)
    self._open[uri] = text
end

---@param uri uri
function mt:close(uri)
    self._open[uri] = nil
end

---@param uri uri
---@return boolean
function mt:isOpen(uri)
    return self._open[uri] ~= nil
end

---@param uri uri
function mt:setLibrary(uri)
    self._library[uri] = true
end

---@param uri uri
---@return uri
function mt:isLibrary(uri)
    return self._library[uri] == true
end

---@param uri uri
function mt:isDead(uri)
    local f = self._files[uri]
    if not f then
        return true
    end
    if f:isRemoved() then
        return true
    end
    return f:getVersion() == -1
end

---@param uri uri
---@return file
function mt:get(uri)
    return self._files[uri]
end

function mt:clear()
    for _, f in pairs(self._files) do
        f:remove()
    end
    self._files = {}
    self._library = {}
    self._fileCount = nil
end

function mt:clearVM()
    for _, f in pairs(self._files) do
        f:removeVM()
    end
end

function mt:eachFile()
    return pairs(self._files)
end

function mt:eachOpened()
    return pairs(self._open)
end

function mt:count()
    return self._fileCount
end

return function ()
    local self = setmetatable({
        _files = {},
        _open = {},
        _library = {},
    }, mt)
    return self
end
