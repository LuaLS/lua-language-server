local jsonrpc = require 'transport.jsonrpc'
local stdio = require 'transport.stdio'

---@class Transport
local M = Class 'Transport'

---@param method string
---@param params? table
function M:notify(method, params)
    error('Not implemented')
end

---@param method string
---@param params? table
function M:request(method, params)
    error('Not implemented')
end

function M:onData(callback)
    error('Not implemented')
end

function M:useStdio()
    self.io = stdio.create()
end

---@class Transport.API
local API = {}

function API.create()
    return New 'Transport' ()
end

return API
