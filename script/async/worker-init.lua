return function (...)
    local name, entry, debugger = ...

    require 'luals'

    ls.threadName = name

    ---@diagnostic disable-next-line: lowercase-global
    log = New 'Log' {
        print = function (level, message, timeStamp)
            
        end,
    }

    log.info('Worker ready!')

    xpcall(function ()
        if not debugger then
            return
        end
        local dbg = require 'debugger'
        dbg:start(debugger.address)
        if debugger.wait then
            dbg:event 'wait'
        end
    end, log.warn)

    local channel = require 'bee.channel'
    local epoll   = require 'bee.epoll'
    local requestChannel  = channel.query(name .. '-request')
    local responseChannel = channel.query(name .. '-response')

    assert(requestChannel,  name .. '-request channel not found')
    assert(responseChannel, name .. '-response channel not found')

    local module = require(entry)

    local function resolve(request)
        local method = request.method
        local params = request.params
        local result = table.pack(module.resolve(method, params))
        return result
    end


    local epfd <close> = assert(epoll.create(16))
    epfd:event_add(requestChannel:fd(), epoll.EPOLLIN)
    while true do
        for _, event in epfd:wait() do
            if event & epoll.EPOLLIN ~= 0 then
                local ok, request = requestChannel:pop()
                if ok then
                    local suc, result = xpcall(resolve, debug.traceback, request)
                    if request.id then
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
    end
end
