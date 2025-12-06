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
    self.idles   = ls.tools.linkedTable.create()
    self.queue   = ls.tools.linkedTable.create()
    self.useDebugger = useDebugger

    for i = 1, num do
        local workerName = '{}-{}' % { name, i }
        self.workers[i] = New 'Async.Worker' (workerName, entry, useDebugger)
        self.idles:pushHead(self.workers[i])
    end
end

---@private
function M:pickJob()
    local job    = self.queue:getHead()
    ---@type Async.Worker
    local worker = self.idles:getHead()
    if not job or not worker then
        return
    end
    self.queue:pop(job)
    self.idles:pop(worker)

    if job.callback then
        worker:request(job.method, job.params, function (...)
            -- 完成一个请求的worker一定很空闲，放到队首
            self.idles:pushHead(worker)
            job.callback(...)
            self:pickJob()
        end)
    else
        worker:notify(job.method, job.params)
        -- 不确定执行通知的worker是否空闲，放到队尾
        self.idles:pushTail(worker)
    end
    return self:pickJob()
end

---@param method string
---@param params table
---@param callback function
function M:request(method, params, callback)
    self.queue:pushTail {
        method   = method,
        params   = params,
        callback = callback,
    }
    self:pickJob()
end

---@param method string
---@param params table
function M:notify(method, params)
    self.queue:pushTail {
        method   = method,
        params   = params,
    }
    self:pickJob()
end

---@async
---@param method string
---@param params table
---@return any
function M:awaitRequest(method, params)
    return ls.await.yield(function (resume)
        self:request(method, params, resume)
    end)
end

---@param name string
---@param num integer
---@param entry string
---@param useDebugger? boolean
---@return Async.Master
function ls.async.create(name, num, entry, useDebugger)
    return New 'Async.Master' (name, num, entry, useDebugger)
end
