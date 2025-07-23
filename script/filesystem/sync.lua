local fs = require 'bee.filesystem'

---@class FileSystem
ls.fs = Class 'FileSystem'

---@type 'sync' | 'async'
ls.fs.mode = 'sync'

---@param uri Uri
---@return Uri[]?
function ls.fs.getChilds(uri)
    local childs = {}
    for path in ls.fsu.listDirectory(ls.uri.decode(uri)) do
        childs[#childs+1] = ls.uri.encode(path:string())
    end
    return childs
end

---@param uri Uri
---@return 'file'|'directory'|'symlink'|nil
function ls.fs.getTypeWithSymlink(uri)
    local ftype = fs.type(fs.path(ls.uri.decode(uri)))
    if ftype == 'regular' then
        return 'file'
    end
    if ftype == 'directory' then
        return 'directory'
    end
    if ftype == 'symlink' then
        return 'symlink'
    end
    return nil
end

---@param uri Uri
---@return 'file'|'directory'|nil
function ls.fs.getType(uri)
    local status = fs.status(fs.path(ls.uri.decode(uri)))
    local ftype = status:type()
    if ftype == 'regular' then
        return 'file'
    end
    if ftype == 'directory' then
        return 'directory'
    end
    return nil
end

---@param uri Uri
---@return string?
function ls.fs.read(uri)
    return ls.util.loadFile(ls.uri.decode(uri))
end

---@param uri Uri
---@return Uri
function ls.fs.parent(uri)
    local parent = uri
        : gsub('[^/]+$', '')
        : gsub('/$', '')
    return parent
end

---@return table<string, any>
function ls.fs.newMap()
    if ls.env.ignoreCase then
        return ls.caselessTable.create()
    else
        return {}
    end
end
