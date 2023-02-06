local client = require 'client'
local ws     = require 'workspace'

---@async
---@param changes config.change[]
return function (changes)
    for _, change in ipairs(changes) do
        ws.awaitReady(change.uri)
    end
    client.setConfig(changes)
end
