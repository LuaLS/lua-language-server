local proto          = require 'proto'
local client         = require 'client'
local json           = require 'json'
local config         = require 'config'

local function refresh()
    if not client.isReady() then
        return
    end
    if not client.getAbility 'workspace.codeLens.refreshSupport' then
        return
    end
    log.debug('Refresh codeLens.')
    proto.request('workspace/codeLens/refresh', json.null)
end

config.watch(function (_uri, key, _value, _oldValue)
    if key == '' then
        refresh()
    end
    if key:find '^Lua.runtime'
    or key:find '^Lua.workspace'
    or key:find '^Lua.codeLens'
    or key:find '^files' then
        refresh()
    end
end)

return {}
