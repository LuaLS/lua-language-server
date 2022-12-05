local subprocess = require 'bee.subprocess'
local util       = require 'utility'
local await      = require 'await'
local pub        = require 'pub'
local jsonrpc    = require 'jsonrpc'
local define     = require 'proto.define'
local json       = require 'json'
local inspect    = require 'inspect'

local reqCounter = util.counter()

local function logSend(buf)
    if not RPCLOG then
        return
    end
    log.info('rpc send:', buf)
end

local function logRecieve(proto)
    if not RPCLOG then
        return
    end
    log.info('rpc recieve:', json.encode(proto))
end

local m = {}

m.ability = {}
m.waiting = {}
m.holdon  = {}

function m.getMethodName(proto)
    if proto.method:sub(1, 2) == '$/' then
        return proto.method, true
    else
        return proto.method, false
    end
end

---@param callback async fun()
function m.on(method, callback)
    m.ability[method] = callback
end

function m.send(data)
    local buf = jsonrpc.encode(data)
    logSend(buf)
    io.write(buf)
end

function m.response(id, res)
    if id == nil then
        log.error('Response id is nil!', inspect(res))
        return
    end
    assert(m.holdon[id])
    m.holdon[id] = nil
    local data  = {}
    data.id     = id
    data.result = res == nil and json.null or res
    m.send(data)
end

function m.responseErr(id, code, message)
    if id == nil then
        log.error('Response id is nil!', inspect(message))
        return
    end
    assert(m.holdon[id])
    m.holdon[id] = nil
    m.send {
        id    = id,
        error = {
            code    = code,
            message = message,
        }
    }
end

function m.notify(name, params)
    m.send {
        method = name,
        params = params,
    }
end

---@async
function m.awaitRequest(name, params)
    local id  = reqCounter()
    m.send {
        id     = id,
        method = name,
        params = params,
    }
    local result, error = await.wait(function (resume)
        m.waiting[id] = {
            id     = id,
            method = name,
            params = params,
            resume = resume,
        }
    end)
    if error then
        log.warn(('Response of [%s] error [%d]: %s'):format(name, error.code, error.message))
    end
    return result
end

function m.request(name, params, callback)
    local id  = reqCounter()
    m.send {
        id     = id,
        method = name,
        params = params,
    }
    m.waiting[id] = {
        id     = id,
        method = name,
        params = params,
        resume = function (result, error)
            if error then
                log.warn(('Response of [%s] error [%d]: %s'):format(name, error.code, error.message))
            end
            if callback then
                callback(result)
            end
        end
    }
end

local secretOption = {
    process = function (item, path)
        if  path[1] == 'params'
        and path[2] == 'textDocument'
        and path[3] == 'text'
        and path[4] == nil then
            return '"***"'
        end
        return item
    end
}

function m.doMethod(proto)
    logRecieve(proto)
    local method, optional = m.getMethodName(proto)
    local abil = m.ability[method]
    if proto.id then
        m.holdon[proto.id] = proto
    end
    if not abil then
        if not optional then
            log.warn('Recieved unknown proto: ' .. method)
        end
        if proto.id then
            m.responseErr(proto.id, define.ErrorCodes.MethodNotFound, method)
        end
        return
    end
    await.call(function () ---@async
        --log.debug('Start method:', method)
        if proto.id then
            await.setID('proto:' .. proto.id)
        end
        local clock = os.clock()
        local ok = false
        local res
        -- 任务可能在执行过程中被中断，通过close来捕获
        local response <close> = function ()
            local passed = os.clock() - clock
            if passed > 0.5 then
                log.warn(('Method [%s] takes [%.3f]sec. %s'):format(method, passed, inspect(proto, secretOption)))
            end
            --log.debug('Finish method:', method)
            if not proto.id then
                return
            end
            await.close('proto:' .. proto.id)
            if ok then
                m.response(proto.id, res)
            else
                m.responseErr(proto.id, proto._closeReason or define.ErrorCodes.InternalError, proto._closeMessage or res)
            end
        end
        ok, res = xpcall(abil, log.error, proto.params)
        await.delay()
    end)
end

function m.close(id, reason, message)
    local proto = m.holdon[id]
    if not proto then
        return
    end
    proto._closeReason = reason
    proto._closeMessage = message
    await.close('proto:' .. id)
end

function m.doResponse(proto)
    logRecieve(proto)
    local id = proto.id
    local waiting = m.waiting[id]
    if not waiting then
        log.warn('Response id not found: ' .. inspect(proto))
        return
    end
    m.waiting[id] = nil
    if proto.error then
        waiting.resume(nil, proto.error)
        return
    end
    waiting.resume(proto.result)
end

function m.listen()
    subprocess.filemode(io.stdin,  'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf  'no'
    io.stdout:setvbuf 'no'
    pub.task('loadProto')
end

return m
