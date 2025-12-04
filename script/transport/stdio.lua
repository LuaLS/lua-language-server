local platform = require 'bee.platform'

local readMaster  = ls.async.create('stdio-r', 1, 'transport.stdio-worker', true)
local writeMaster = ls.async.create('stdio-w', 1, 'transport.stdio-worker', true)

---@class Transport.Stdio
local M = Class 'Transport.Stdio'

function M:__init()
    if platform.os == 'windows' then
        local windows = require 'bee.windows'
        windows.filemode(io.stdin, 'b')
        windows.filemode(io.stdout, 'b')
    end
    io.stdin:setvbuf 'no'
    io.stdout:setvbuf 'no'
end

---@param data string
function M:write(data)
    writeMaster:notify('write', { 'stdout', data })
end

---@async
---@param ... string | integer
---@return string?
function M:read(...)
    local data = readMaster:awaitRequest('read', { 'stdin', ... })
    return data
end

local API = {}

function API.create()
    return New 'Transport.Stdio' ()
end

return API
