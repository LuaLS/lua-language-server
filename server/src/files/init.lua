local file = require 'files.file'

local mt = {}
mt.__index = mt
mt.type = 'files'

function mt:save(uri)
    if not self._files[uri] then
        self._files[uri] = file(uri)
    end
    self._files[uri]:setText(uri)
end

function mt:remove(uri)
    local obj = self._files[uri]

    self._files[uri] = nil
end

function mt:open(uri)
    if not self._files[uri] then
        self._files[uri] = file(uri)
    end
    self._files[uri]:open()
end

function mt:close(uri)
    if not self._files[uri] then
        return
    end
    self._files[uri]:close()
end

function mt:isOpen(uri)
    local obj = self._files[uri]
    if not obj then
        return false
    end
    return obj:isOpen()
end

return function ()
    local self = setmetatable({
        _files = {},
    }, mt)
    return self
end
