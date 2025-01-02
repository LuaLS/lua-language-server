local gc      = require 'gc'
local util    = require 'utility'
local proto   = require 'proto'
local await   = require 'await'
local timer   = require 'timer'
local pub     = require 'pub'
local json    = require 'json'
local define  = require 'proto.define'

require 'provider'

local counter = util.counter()

---@class languageClient
---@field _outs table
---@field _gc   gc
---@field _waiting table
---@field _methods table
---@field onSend function
local mt = {}
mt.__index = mt

function mt:__close()
    self:remove()
end

function mt:_fakeProto()
    ---@diagnostic disable-next-line: duplicate-set-field
    proto.send = function (data)
        self._outs[#self._outs+1] = data
        if self.onSend then
            self:onSend(data)
        end
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

function mt:_localLoadFile()
    local awaitTask = pub.awaitTask
    ---@async
    ---@param name   string
    ---@param params any
    ---@diagnostic disable-next-line: duplicate-set-field
    pub.awaitTask = function (name, params)
        if name == 'loadFile' then
            local path = params
            return util.loadFile(path)
        end
        return awaitTask(name, params)
    end
    self:gc(function ()
        pub.awaitTask = awaitTask
    end)
end

local defaultClientOptions = {
    initializationOptions = {
        changeConfiguration = true,
        viewDocument = true,
        trustByClient = true,
        useSemanticByRange = true,
    },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    tagSupport = {
                        valueSet = {
                            define.DiagnosticTag.Unnecessary,
                            define.DiagnosticTag.Deprecated,
                        },
                    },
                },
            },
        },
        workspace = {
            configuration = true,
        },
    },
}

---@async
function mt:initialize(params)
    local initParams = util.tableMerge(params or {}, defaultClientOptions)
    self:awaitRequest('initialize', initParams)
    self:notify('initialized', initParams)
end

function mt:reportHangs()
    local hangs = {}
    hangs[#hangs+1] = ('====== C -> S ======')
    for _, waiting in util.sortPairs(self._waiting) do
        hangs[#hangs+1] = ('%03d %s'):format(waiting.id, waiting.method)
    end
    hangs[#hangs+1] = ('====== S -> C ======')
    for _, waiting in util.sortPairs(proto.waiting) do
        hangs[#hangs+1] = ('%03d %s'):format(waiting.id, waiting.method)
    end
    hangs[#hangs+1] = ('====================')
    return table.concat(hangs, '\n')
end

---@param callback async fun(client: languageClient)
function mt:start(callback)
    CLI = true

    self:_fakeProto()
    self:_flushServer()
    self:_localLoadFile()

    local finished = false

    await.setErrorHandle(function (...)
        local msg = log.error(...)
        error(msg)
    end)

    ---@async
    await.call(function ()
        callback(self)
        finished = true
    end)

    local jumpedTime = 0

    while true do
        if finished and #self._outs == 0 then
            break
        end
        timer.update()
        if await.step() then
            goto CONTINUE
        end
        if self:update() then
            goto CONTINUE
        end
        timer.timeJump(1.0)
        jumpedTime = jumpedTime + 1.0
        if jumpedTime > 2 * 60 * 60 then
            error('two hours later ...\n' .. self:reportHangs())
        end
        ::CONTINUE::
    end

    self:remove()

    CLI = false
end

function mt:gc(obj)
    return self._gc:add(obj)
end

function mt:remove()
    self._gc:remove()
end

---@async
function mt:notify(method, params)
    proto.doMethod {
        method = method,
        params = params,
    }
    await.sleep(0.1)
end

---@async
function mt:request(method, params, callback)
    local id = counter()
    self._waiting[id] = {
        id       = id,
        params   = params,
        callback = callback,
    }
    proto.doMethod {
        id     = id,
        method = method,
        params = params,
    }
    await.sleep(0.1)
end

---@async
function mt:awaitRequest(method, params)
    return await.wait(function (waker)
        ---@async
        await.call(function ()
            self:request(method, params, function (result)
                if result == json.null then
                    result = nil
                end
                waker(result)
            end)
        end)
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
            if callback then
                local result = callback(out.params)
                await.call(function ()
                    if out.id then
                        proto.doResponse {
                            id     = out.id,
                            result = result,
                        }
                    end
                end)
            elseif out.method:sub(1, 2) ~= '$/' then
                error('Unknown method: ' .. out.method)
            end
        else
            local callback = self._waiting[out.id].callback
            self._waiting[out.id] = nil
            callback(out.result, out.error)
        end
    end
    return true
end

function mt:register(method, callback)
    self._methods[method] = callback
end

function mt:registerFakers()
    for _, method in ipairs {
        'textDocument/publishDiagnostics',
        'workspace/configuration',
        'workspace/semanticTokens/refresh',
        'workspace/diagnostic/refresh',
        'window/workDoneProgress/create',
        'window/showMessage',
        'window/showMessageRequest',
        'window/logMessage',
    } do
        self:register(method, function ()
            return nil
        end)
    end
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
