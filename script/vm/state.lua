local util   = require 'utility'
local guide  = require 'parser.guide'
local global = require 'vm.node.global'

---@class vm.state
local m = {}
---@type table<string, vm.node.global>
m.globals = util.defaultTable(global)
---@type table<uri, { globals: table }>
m.subscriptions = util.defaultTable(function ()
    return {
        globals = {},
    }
end)

---@param name   string
---@param uri    uri
---@param source parser.guide.object
---@return vm.node.global
function m.declareGlobal(name, uri, source)
    m.subscriptions[uri].globals[name] = true
    local node = m.globals[name]
    node:addSet(uri, source)
    return node
end

---@param name string
---@param uri? uri
---@return vm.node.global
function m.getGlobal(name, uri)
    if uri then
        m.subscriptions[uri].globals[name] = true
    end
    return m.globals[name]
end

---@param uri uri
function m.dropUri(uri)
    local subscription = m.subscriptions[uri]
    m.subscriptions[uri] = nil
    for name in pairs(subscription) do
        m.globals[name]:dropUri(uri)
    end
end

return m
