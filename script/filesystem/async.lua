local thread  = require 'bee.thread'
local channel = require 'bee.channel'
local requestChannel  = channel.create('filesystem-request')
local responseChannel = channel.create('filesystem-response')

local thd = thread.create([[
package.path = {packagepath:q}
require 'filesystem.async-worker'
]] % {
    packagepath = package.path,
})

local id = 0
local requestMap = {}

---@async
---@param method string
---@param params table
---@return any
local function request(method, params)
    id = id + 1
    local data = {
        id = id,
        method = method,
        params = params,
    }
    requestChannel:push(data)
    return ls.await.yield(function (resume)
        requestMap[id] = resume
    end)
end

---@class AsyncFileSystem: FileSystem
ls.afs = Class('AsyncFileSystem', 'FileSystem')

ls.afs.mode = 'async'

---@async
---@param uri Uri
---@return Uri[]?
function ls.afs.getChilds(uri)
    return request('getChilds', { uri })
end

---@async
---@param uri Uri
---@return 'file'|'directory'|'symlink'|nil
function ls.afs.getTypeWithSymlink(uri)
    return request('getTypeWithSymlink', { uri })
end

---@async
---@param uri Uri
---@return 'file'|'directory'|nil
function ls.afs.getType(uri)
    return request('getType', { uri })
end

---@async
---@param uri Uri
---@return string?
function ls.afs.read(uri)
    return request('read', { uri })
end

---@async
---@param uri Uri
---@param content string
---@return boolean
function ls.afs.write(uri, content)
    return request('write', { uri, content })
end

ls.eventLoop.addTask(function ()
    if not next(requestMap) then
        return
    end
    while true do
        local ok, data = responseChannel:pop()
        if not ok then
            break
        end
        local resume = requestMap[data.id]
        if not resume then
            goto continue
        end
        requestMap[data.id] = nil
        if data.error then
            log.warn(data.error)
        end
        resume(data.result)
        ::continue::
    end
end)
