local thread     = require 'bee.thread'
local response, errlog
local proto_cache

local api = {
    log = function (data)
        local level = data.level
        local buf   = data.buf
        log[level](buf)
    end,
    proto = function (data)
        if not proto_cache then
            proto_cache = {}
        end
        proto_cache[#proto_cache+1] = data
    end,
}

local function on_tick()
    if not response then
        return
    end
    local ok, msg = errlog:pop()
    if ok then
        log.error(msg)
    end
    local ok, who, data = response:pop()
    if ok then
        api[who](data)
    end
end

local function require(name)
    if not response then
        thread.newchannel 'response'
        response = thread.channel 'response'
        errlog   = thread.channel 'errlog'
    end

    local buf = ("\z
        package.cpath = %q\n\z
        package.path = %q\n\z
        require %q\n\z
    "):format(package.cpath, package.path, name)
    return thread.thread(buf)
end

local function proto()
    if not proto_cache then
        return nil
    end
    return table.remove(proto_cache, 1)
end

return {
    require = require,
    on_tick = on_tick,
    proto   = proto,
    sleep   = thread.sleep,
}
