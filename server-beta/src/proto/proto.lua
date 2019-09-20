local subprocess = require 'bee.subprocess'
local util       = require 'utility'
local task       = require 'task'
local pub        = require 'pub'
local jsonrpc    = require 'jsonrpc'
local ErrorCodes = require 'define.ErrorCodes'

local m = {}

m.ability = {}

local function isOptionalMethod(method)
    return method:sub(1, 2) == '$/'
end

function m.on(method, callback)
    m.ability[method] = callback
end

function m.response(id, res)
    -- res 可能是nil，为了转成json时保留nil，使用 container 容器
    local data = util.container()
    data.id     = id
    data.result = res
    local buf = jsonrpc.encode(data)
    io.stdout:write(buf)
end

function m.responseErr(id, code, message)
    local buf = jsonrpc.encode {
        id    = id,
        error = {
            code    = code,
            message = message,
        }
    }
    io.stdout:write(buf)
end

function m.doProto(proto)
    local method = proto.method
    local abil = m.ability[method]
    if not abil then
        if not isOptionalMethod(method) then
            log.warn('Recieved unknown proto: ' .. method)
        end
        if proto.id then
            m.responseErr(proto.id, ErrorCodes.MethodNotFound, method)
        end
        return
    end
    task.create(function ()
        local clock = os.clock()
        local ok, res = xpcall(abil, log.error, proto.params)
        local passed = os.clock() - clock
        if passed > 0.2 then
            log.debug(('Method [%s] takes [%.3f]sec.'):format(method, passed))
        end
        if ok then
            m.response(proto.id, res)
        else
            m.responseErr(proto.id, ErrorCodes.InternalError, res)
        end
    end)
end

function m.listen()
    subprocess.filemode(io.stdin,  'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf  'no'
    io.stdout:setvbuf 'no'
    task.create(function ()
        while true do
            local proto = pub.task('loadProto')
            m.doProto(proto)
        end
    end)
end

return m
