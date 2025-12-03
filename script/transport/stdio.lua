local platform = require 'bee.platform'

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
function M:send(data)
end

local API = {}

function API.create()
    return New 'Transport.Stdio' ()
end

return API
