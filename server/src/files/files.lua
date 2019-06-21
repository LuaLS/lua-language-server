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
function mt:open(uri)
    self._open[uri] = true
end

---@param uri uri
function mt:close(uri)
    self._open[uri] = nil
end

---@param uri uri
---@return boolean
function mt:isOpen(uri)
    return self._open[uri] == true
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

---@param uri uri
---@param vm VM
function mt:saveVM(uri, vm)
    local f = self._files[uri]
    if not f then
        return
    end
    f:saveVM(vm)
end

function mt:clear()
    for _, f in pairs(self._files) do
        f:remove()
    end
end

function mt:eachFile()
    return pairs(self._files)
end

function mt:eachOpened()
    return pairs(self._open)
end

return function ()
    local self = setmetatable({
        _files = {},
        _open = {},
    }, mt)
    return self
end
