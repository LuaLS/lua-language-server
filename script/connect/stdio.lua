local jsonrpc  = require 'connect.jsonrpc'
local platform = require 'bee.platform'

local M = {}

function M.init()
    if platform.os == 'windows' then
        local windows = require 'bee.windows'
        windows.filemode(io.stdin, 'b')
        windows.filemode(io.stdout, 'b')
    end
    io.stdin:setvbuf 'no'
    io.stdout:setvbuf 'no'
end

---@param onData fun(data: table)
---@param onError? fun(message: string)
function M.start(onData, onError)
    while true do
        local suc, res = pcall(jsonrpc.decode, io.read)
        if not suc then
            ---@diagnostic disable-next-line: cast-type-mismatch
            ---@cast res string
            if onError then
                onError(res)
            end
            return
        end
        onData(res)
    end
end

return M
