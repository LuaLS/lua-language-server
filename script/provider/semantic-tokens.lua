local proto          = require 'proto'
local define         = require 'proto.define'
local client         = require 'client'
local json           = require "json"
local config         = require 'config'
local lang           = require 'language'
local nonil          = require 'without-check-nil'

local dontShowAgain = false
local function check(uri)
    if dontShowAgain then
        return
    end
    dontShowAgain = true
    nonil.disable()
    if config.get(uri, 'editor.semanticHighlighting.enabled') == 'configuredByTheme' then
        proto.request('window/showMessageRequest', {
            type    = define.MessageType.Info,
            message = lang.script.WINDOW_CHECK_SEMANTIC,
            actions = {
                {
                    title = lang.script.WINDOW_APPLY_SETTING,
                },
                {
                    title = lang.script.WINDOW_DONT_SHOW_AGAIN,
                },
            }
        }, function (item)
            if not item then
                return
            end
            if item.title == lang.script.WINDOW_APPLY_SETTING then
                client.setConfig {
                    {
                        key      = 'editor.semanticHighlighting.enabled',
                        action   = 'set',
                        value    = true,
                        global   = true,
                    }
                }
            end
        end)
    end
end

local function refresh()
    if not client.isReady() then
        return
    end
    log.debug('Refresh semantic tokens.')
    proto.request('workspace/semanticTokens/refresh', json.null)
    --check()
end

config.watch(function (uri, key, value, oldValue)
    if key == '' then
        refresh()
    end
    if key:find '^Lua.runtime'
    or key:find '^Lua.workspace'
    or key:find '^Lua.semantic'
    or key:find '^files' then
        refresh()
    end
end)

return {}
