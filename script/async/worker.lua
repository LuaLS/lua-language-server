local thread  = require 'bee.thread'
local channel = require 'bee.channel'

---@class Async.Worker
local M = Class 'Async.Worker'

M.requestID = 0
M.hang = 0

---@param name string
---@param entry string
---@param useDebugger? boolean
function M:__init(name, entry, useDebugger)
    self.name = name
    log.info('Create channel: {}' % { name .. '-request' })
    self.requestChannel  = channel.create(name .. '-request')
    log.info('Create channel: {}' % { name .. '-response' })
    self.responseChannel = channel.create(name .. '-response')
    self.requestMap = {}

    self.thread = thread.create([[
local options = ...
local root = options.root
package.path = {packagepath:q}

package.searchers[2] = function (name)
    local filename, err = package.searchpath(name, package.path)
    if not filename then
        return err
    end
    local f = io.open(filename)
    if not f then
        return 'cannot open file:' .. filename
    end
    local buf = f:read '*a'
    f:close()
    local relative = filename:sub(1, #root) == root and filename:sub(#root + 2) or filename
    local init, err = load(buf, '@' .. relative)
    if not init then
        return err
    end
    return init, filename
end

require 'async.worker-init' (options)
    ]] % {
        packagepath = package.path,
    }, {
        name = name,
        root = ls.env.ROOT_PATH,
        entry = entry,
        logLevel = log.level,
        debugger = useDebugger and ls.args.DEVELOP and {
            address = ls.args.DBGADDRESS .. ':' .. tostring(ls.args.DBGPORT),
            wait    = ls.args.DBGWAIT,
        }
    } or false)

    ls.eventLoop.addTask(function ()
        if not next(self.requestMap) then
            return
        end
        while true do
            local ok, data = self.responseChannel:pop()
            if not ok then
                break
            end
            self.hang = self.hang - 1
            local callback = self.requestMap[data.id]
            if not callback then
                goto continue
            end
            self.requestMap[data.id] = nil
            if data.error then
                log.warn(data.error)
                xpcall(callback, log.error, nil)
                goto continue
            end
            xpcall(callback, log.error, table.unpack(data.result, 1, data.result.n))
            ::continue::
        end
    end)
end

---@param method string
---@param params table
---@param callback function
---@return any
function M:request(method, params, callback)
    self.requestID = self.requestID + 1
    self.hang = self.hang + 1
    local data = {
        id = self.requestID,
        method = method,
        params = params,
    }
    self.requestChannel:push(data)
    self.requestMap[self.requestID] = callback
end


---@param method string
---@param params table
function M:notify(method, params)
    local data = {
        method = method,
        params = params,
    }
    self.requestChannel:push(data)
end
