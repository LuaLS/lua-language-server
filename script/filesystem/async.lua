local reader = ls.async.create('afs-reader', 1, 'filesystem.async-worker', true)
local writer = ls.async.create('afs-writer', 1, 'filesystem.async-worker', true)

---@class AsyncFileSystem: FileSystem
ls.afs = Class('AsyncFileSystem', 'FileSystem')

ls.afs.mode = 'async'

---@async
---@param uri Uri
---@return Uri[]?
function ls.afs.getChilds(uri)
    return reader:awaitRequest('getChilds', { uri })
end

---@async
---@param uri Uri
---@return 'file'|'directory'|'symlink'|nil
function ls.afs.getTypeWithSymlink(uri)
    return reader:awaitRequest('getTypeWithSymlink', { uri })
end

---@async
---@param uri Uri
---@return 'file'|'directory'|nil
function ls.afs.getType(uri)
    return reader:awaitRequest('getType', { uri })
end

---@async
---@param uri Uri
---@return string?
function ls.afs.read(uri)
    return reader:awaitRequest('read', { uri })
end

---@async
---@param uri Uri
---@param content string
---@return boolean
function ls.afs.write(uri, content)
    return writer:awaitRequest('write', { uri, content })
end

---@async
---@param uri Uri
---@return boolean
function ls.afs.remove(uri)
    return writer:awaitRequest('remove', { uri })
end
