local master = ls.async.create('afs', 2, 'filesystem.async-worker', true)

---@class AsyncFileSystem: FileSystem
ls.afs = Class('AsyncFileSystem', 'FileSystem')

ls.afs.mode = 'async'

---@async
---@param uri Uri
---@return Uri[]?
function ls.afs.getChilds(uri)
    return master:awaitRequest('getChilds', { uri })
end

---@async
---@param uri Uri
---@return 'file'|'directory'|'symlink'|nil
function ls.afs.getTypeWithSymlink(uri)
    return master:awaitRequest('getTypeWithSymlink', { uri })
end

---@async
---@param uri Uri
---@return 'file'|'directory'|nil
function ls.afs.getType(uri)
    return master:awaitRequest('getType', { uri })
end

---@async
---@param uri Uri
---@return string?
function ls.afs.read(uri)
    return master:awaitRequest('read', { uri })
end

---@async
---@param uri Uri
---@param content string
---@return boolean
function ls.afs.write(uri, content)
    return master:awaitRequest('write', { uri, content })
end

---@async
---@param uri Uri
---@return boolean
function ls.afs.remove(uri)
    return master:awaitRequest('remove', { uri })
end

---@async
---@param std 'stdin' | 'stdout' |'stderr'
---@param ... any
---@return string?
function ls.afs.stdRead(std, ...)
    return master:awaitRequest('stdRead', { std, ... })
end

---@async
---@param std 'stdin' | 'stdout' |'stderr'
---@param ... string | number
---@return boolean
function ls.afs.stdWrite(std, ...)
    return master:awaitRequest('stdWrite', { std, ... })
end
