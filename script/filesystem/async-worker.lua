local channel = require 'bee.channel'
local epoll   = require 'bee.epoll'
local requestChannel  = channel.query('filesystem-request')
local responseChannel = channel.query('filesystem-response')

assert(requestChannel,  'filesystem-request channel not found')
assert(responseChannel, 'filesystem-response channel not found')

Class = require 'class'.declare
---@class LuaLS
ls = {}
ls.util = require 'utility'
ls.uri  = require 'tools.uri'
ls.fsu  = require 'tools.fs-utility'

require 'filesystem.sync'

local function resolve(request)
    local method = request.method
    local params = request.params
    local f = ls.fs[method]
    if not f then
        return error(('Method "%s" not found'):format(method))
    end
    local result = f(table.unpack(params))
    return result
end

local epfd <close> = epoll.create(16)
epfd:event_add(requestChannel:fd(), epoll.EPOLLIN)
while true do
    for _, event in epfd:wait() do
        if event & epoll.EPOLLIN ~= 0 then
            local ok, request = requestChannel:pop()
            if ok then
                local suc, result = xpcall(resolve, debug.traceback, request)
                if suc then
                    responseChannel:push({
                        id = request.id,
                        result = result,
                    })
                else
                    responseChannel:push({
                        id = request.id,
                        error = result,
                    })
                end
            end
        end
    end
end
