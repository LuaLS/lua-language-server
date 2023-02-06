local config = require 'config'
local ws     = require 'workspace'

---@async
return function (data)
    local uri = data[1].uri
    local key = data[1].key
    ws.awaitReady(uri)
    return config.get(uri, key)
end
