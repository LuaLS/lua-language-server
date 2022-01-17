local gc      = require 'gc'
local util    = require 'utility'
local proto   = require 'proto'
local await   = require 'await'
local timer   = require 'timer'

require 'provider'

local counter = util.counter()

---@class languageClient
---@field _outs table
---@field _gc   gc
---@field _waiting table
---@field _methods table
local mt = {}
mt.__index = mt

function mt:__close()
    self:remove()
end

function mt:_fakeProto()
    proto.send = function (data)
        self._outs[#self._outs+1] = data
    end
end

function mt:_flushServer()
    -- reset scopes
    local ws    = require 'workspace'
    local scope = require 'workspace.scope'
    local files = require 'files'
    ws.reset()
    scope.reset()
    files.reset()
end

---@param callback async fun(client: languageClient)
function mt:start(callback)
    self:_fakeProto()
    self:_flushServer()

    local finished = false

    ---@async
    await.call(function ()
        callback(self)
        finished = true
    end)

    while true do
        if finished then
            break
        end
        if await.step() then
            goto CONTINUE
        end
        timer.update()
        if await.step() then
            goto CONTINUE
        end
        if self:update() then
            goto CONTINUE
        end
        timer.timeJump(1.0)
        ::CONTINUE::
    end

    self:remove()
end

function mt:gc(obj)
    return self._gc:add(obj)
end

function mt:remove()
    self._gc:remove()
end

function mt:notify(method, params)
    proto.doMethod {
        method = method,
        params = params,
    }
end

function mt:request(method, params, callback)
    local id = counter()
    self._waiting[id] = callback
    proto.doMethod {
        id     = id,
        method = method,
        params = params,
    }
end

---@async
function mt:awaitRequest(method, params)
    return await.wait(function (waker)
        self:request(method, params, waker)
    end)
end

function mt:update()
    local outs = self._outs
    if #outs == 0 then
        return false
    end
    self._outs = {}
    for _, out in ipairs(outs) do
        if out.method then
            local callback = self._methods[out.method]
            proto.doResponse {
                id     = out.id,
                params = callback(out.params),
            }
        else
            local callback = self._waiting[out.id]
            self._waiting[out.id] = nil
            callback(out.result, out.error)
        end
    end
    return true
end

function mt:register(name, callback)
    self._methods[name] = callback
end

---@return languageClient
return function ()
    local self = setmetatable({
        _gc      = gc(),
        _outs    = {},
        _waiting = {},
        _methods = {},
    }, mt)
    return self
end
