local lclient = require 'lclient'
local util    = require 'utility'
local ws      = require 'workspace'
local json    = require 'json'

---@async
lclient():start(function (client)
    client:registerFakers()

    client:initialize()

    local text = util.loadFile((ROOT / 'test' / 'example' / 'meta.json'):string())
    local meta = json.decode(text)

    client:notify('$/api/report', meta)

    ws.awaitReady()
end)
