local proto          = require 'proto'
local client         = require 'client'
local json           = require "json"
local config         = require 'config'

local function refresh()
    if not client.isReady() then
        return
    end
    if not client.getAbility 'workspace.inlayHint.refreshSupport' then
        return
    end
    log.debug('Refresh inlay hints.')
    proto.request('workspace/inlayHint/refresh', json.null)
end

config.watch(function (uri, key, value, oldValue)
    if key == '' then
        refresh()
    end
    if key:find '^Lua.runtime'
    or key:find '^Lua.workspace'
    or key:find '^Lua.hint'
    or key:find '^files' then
        refresh()
    end
end)

return {}
