require 'async.worker'

---@class Async.Master
local M = Class 'Async.Master'

---@param name string
---@param num integer
---@param entry string
---@param useDebugger? boolean
function M:__init(name, num, entry, useDebugger)
    self.name    = name
    self.num     = num
    self.entry   = entry
    self.workers = {}
    ---@type Async.Worker[]
    self.idles   = {}
    self.useDebugger = useDebugger

    for i = 1, num do
        local workerName = '{}-{}' % { name, i }
        self.workers[i] = New 'Async.Worker' (workerName, entry, useDebugger)
        self.idles[i] = self.workers[i]
    end
end

---@param method string
---@param params table
---@param callback function
function M:request(method, params, callback)
    local idles = self.idles
    ---@type Async.Worker
    local idle = table.remove(idles)
    if not idle then
        idle = self.workers[math.random(1, self.num)]
    end
    idle:request(method, params, function (...)
        table.insert(idles, idle)
        callback(...)
    end)
end

---@async
---@param method string
---@param params table
---@return any
function M:awaitRequest(method, params)
    return ls.await.yield(function (resume)
        self:request(method, params, function (...)
            resume(...)
        end)
    end)
end
---@param method string
---@param params table
function M:notify(method, params)
    local idles = self.idles
    ---@type Async.Worker
    local idle = idles[#idles]
    if not idle then
        idle = self.workers[math.random(1, self.num)]
    end
    idle:notify(method, params)
end

---@param name string
---@param num integer
---@param entry string
---@param useDebugger? boolean
---@return Async.Master
function ls.async.create(name, num, entry, useDebugger)
    return New 'Async.Master' (name, num, entry, useDebugger)
end
