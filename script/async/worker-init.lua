local channel = require 'bee.channel'
local time    = require 'bee.time'
local thread  = require 'bee.thread'

return function (options)

    require 'luals'

    ls.threadName = options.name
    thread.setname(options.name)

    local logChannel = channel.query('log')
    assert(logChannel, 'log channel not found')

    ---@diagnostic disable-next-line: lowercase-global
    log = New 'Log' {
        clock = function ()
            return time.monotonic() / 1000.0
        end,
        time  = function ()
            return time.time() // 1000
        end,
        level = options.logLevel,
        print = function (timeStamp, level, sourceStr, message)
            logChannel:push(options.name, timeStamp, level, sourceStr, message)
            return true
        end,
    }

    log.info('Worker ready!')

    xpcall(function ()
        if not options.debugger then
            return
        end
        local dbg = require 'debugger'
        if options.debugger.attach then
            dbg:attach {}
        else
            dbg:start(options.debugger.address)
            if options.debugger.wait then
                dbg:event 'wait'
            end
        end
    end, log.warn)

    local channel = require 'bee.channel'
    local epoll   = require 'bee.epoll'
    local requestChannel  = channel.query(options.name .. '-request')
    local responseChannel = channel.query(options.name .. '-response')

    assert(requestChannel,  options.name .. '-request channel not found')
    assert(responseChannel, options.name .. '-response channel not found')
    local module = require(options.entry)

    local function resolve(request)
        log.verb('Recieved request:', request.method)
        local method = request.method
        local params = request.params
        local result = table.pack(module.resolve(method, params))
        log.verb('Resolved result:', request.method)
        return result
    end

    local epfd <close> = assert(epoll.create(16))
    epfd:event_add(requestChannel:fd(), epoll.EPOLLIN)
    while true do
        for _, event in epfd:wait() do
            if event & epoll.EPOLLIN ~= 0 then
                local ok, request = requestChannel:pop()
                if ok then
                    local suc, result = xpcall(resolve, log.error, request)
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
