local brave   = require 'brave.brave'

brave.on('loadProtoByStdio', function ()
    local jsonrpc = require 'jsonrpc'
    while true do
        local proto, err = jsonrpc.decode(io.read)
        --log.debug('loaded proto', proto.method)
        if not proto then
            brave.push('protoerror', err)
            return
        end
        brave.push('proto', proto)
    end
end)

brave.on('loadProtoBySocket', function (param)
    local jsonrpc = require 'jsonrpc'
    local net     = require 'service.net'
    local buf = ''

    ---@async
    local parser = coroutine.create(function ()
        while true do
            ---@async
            local proto, err = jsonrpc.decode(function (len)
                while true do
                    if #buf >= len then
                        local res = buf:sub(1, len)
                        buf = buf:sub(len + 1)
                        return res
                    end
                    coroutine.yield()
                end
            end)
            --log.debug('loaded proto', proto.method)
            if not proto then
                brave.push('protoerror', err)
                return
            end
            brave.push('proto', proto)
        end
    end)

    local lsclient = net.connect('tcp', '127.0.0.1', param.port)
    local lsmaster = net.connect('unix', param.unixPath)

    assert(lsclient)
    assert(lsmaster)

    function lsclient:on_data(data)
        buf = buf .. data
        coroutine.resume(parser)
    end

    function lsclient:on_error(...)
        log.error(...)
    end

    function lsmaster:on_data(data)
        lsclient:write(data)
        --net.update()
    end

    function lsmaster:on_error(...)
        log.error(...)
    end

    while true do
        net.update(10)
    end
end)

brave.on('timer', function (time)
    local thread = require 'bee.thread'
    while true do
        thread.sleep(math.floor(time * 1000))
        brave.push('wakeup')
    end
end)

brave.on('loadFile', function (path)
    local util    = require 'utility'
    return util.loadFile(path)
end)

brave.on('removeCaches', function (path)
    local fs  = require 'bee.filesystem'
    local fsu = require 'fs-utility'
    for dir in fs.pairs(fs.path(path)) do
        local lockFile = dir / '.lock'
        local f = io.open(lockFile:string(), 'wb')
        if f then
            f:close()
            fsu.fileRemove(dir)
        end
    end
end)

---@class brave.param.compile
---@field uri uri
---@field text string
---@field mode string
---@field version string
---@field options brave.param.compile.options

---@class brave.param.compile.options
---@field special table<string, string>
---@field unicodeName boolean
---@field nonstandardSymbol table<string, true>

---@param param brave.param.compile
brave.on('compile', function (param)
    local parser = require 'parser'
    local clock = os.clock()
    local state, err = parser.compile(param.text
        , param.mode
        , param.version
        , param.options
    )
    log.debug('Async compile', param.uri, 'takes:', os.clock() - clock)
    return {
        state = state,
        err   = err,
    }
end)
