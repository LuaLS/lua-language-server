local subprocess = require 'bee.subprocess'
local util       = require 'utility'
local await      = require 'await'
local pub        = require 'pub'
local jsonrpc    = require 'jsonrpc'
local define     = require 'proto.define'
local timer      = require 'timer'
local json       = require 'json'

local reqCounter = util.counter()

local m = {}

m.ability = {}
m.waiting = {}
m.holdon  = {}

function m.getMethodName(proto)
    if proto.method:sub(1, 2) == '$/' then
        return proto.method:sub(3), true
    else
        return proto.method, false
    end
end

function m.on(method, callback)
    m.ability[method] = callback
end

function m.response(id, res)
    if id == nil then
        log.error('Response id is nil!', util.dump(res))
        return
    end
    assert(m.holdon[id])
    m.holdon[id] = nil
    local data  = {}
    data.id     = id
    data.result = res == nil and json.null or res
    local buf = jsonrpc.encode(data)
    --log.debug('Response', id, #buf)
    io.stdout:write(buf)
end

function m.responseErr(id, code, message)
    if id == nil then
        log.error('Response id is nil!', util.dump(message))
        return
    end
    local buf = jsonrpc.encode {
        id    = id,
        error = {
            code    = code,
            message = message,
        }
    }
    --log.debug('ResponseErr', id, #buf)
    io.stdout:write(buf)
end

function m.notify(name, params)
    local buf = jsonrpc.encode {
        method = name,
        params = params,
    }
    --log.debug('Notify', name, #buf)
    io.stdout:write(buf)
end

function m.awaitRequest(name, params)
    local id  = reqCounter()
    local buf = jsonrpc.encode {
        id     = id,
        method = name,
        params = params,
    }
    --log.debug('Request', name, #buf)
    io.stdout:write(buf)
    local result, error = await.wait(function (resume)
        m.waiting[id] = resume
    end)
    if error then
        log.warn(('Response of [%s] error [%d]: %s'):format(name, error.code, error.message))
    end
    return result
end

function m.request(name, params, callback)
    local id  = reqCounter()
    local buf = jsonrpc.encode {
        id     = id,
        method = name,
        params = params,
    }
    --log.debug('Request', name, #buf)
    io.stdout:write(buf)
    m.waiting[id] = function (result, error)
        if error then
            log.warn(('Response of [%s] error [%d]: %s'):format(name, error.code, error.message))
        end
        if callback then
            callback(result)
        end
    end
end

function m.doMethod(proto)
    local method, optional = m.getMethodName(proto)
    local abil = m.ability[method]
    if not abil then
        if not optional then
            log.warn('Recieved unknown proto: ' .. method)
        end
        if proto.id then
            m.responseErr(proto.id, define.ErrorCodes.MethodNotFound, method)
        end
        return
    end
    if proto.id then
        m.holdon[proto.id] = method
    end
    await.call(function ()
        --log.debug('Start method:', method)
        local clock = os.clock()
        local ok = true
        local res
        -- 任务可能在执行过程中被中断，通过close来捕获
        local response <close> = function ()
            local passed = os.clock() - clock
            if passed > 0.2 then
                log.debug(('Method [%s] takes [%.3f]sec.'):format(method, passed))
            end
            --log.debug('Finish method:', method)
            if not proto.id then
                return
            end
            if ok then
                m.response(proto.id, res)
            else
                m.responseErr(proto.id, define.ErrorCodes.InternalError, res)
            end
        end
        ok, res = xpcall(abil, log.error, proto.params)
    end)
end

function m.doResponse(proto)
    local id = proto.id
    local resume = m.waiting[id]
    if not resume then
        log.warn('Response id not found: ' .. util.dump(proto))
        return
    end
    m.waiting[id] = nil
    if proto.error then
        resume(nil, proto.error)
        return
    end
    resume(proto.result)
end

function m.listen()
    subprocess.filemode(io.stdin,  'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf  'no'
    io.stdout:setvbuf 'no'
    pub.task('loadProto')
end

return m
