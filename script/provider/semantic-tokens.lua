local proto          = require 'proto'
local define         = require 'proto.define'
local client         = require 'client'
local json           = require "json"
local config         = require 'config'
local lang           = require 'language'
local nonil          = require 'without-check-nil'

local isEnable = false

local function toArray(map)
    local array = {}
    for k in pairs(map) do
        array[#array+1] = k
    end
    table.sort(array, function (a, b)
        return map[a] < map[b]
    end)
    return array
end

local dontShowAgain = false
local function enable()
    if isEnable then
        return
    end
    nonil.enable()
    if not client.info.capabilities.textDocument.semanticTokens.dynamicRegistration then
        return
    end
    nonil.disable()
    isEnable = true
    log.debug('Enable semantic tokens.')
    proto.request('client/registerCapability', {
        registrations = {
            {
                id = 'semantic-tokens',
                method = 'textDocument/semanticTokens',
                registerOptions = {
                    legend = {
                        tokenTypes     = toArray(define.TokenTypes),
                        tokenModifiers = toArray(define.TokenModifiers),
                    },
                    range = true,
                    full  = false,
                },
            },
        }
    })
    if config.get 'editor.semanticHighlighting.enabled' == 'configuredByTheme' and not dontShowAgain then
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
            if item.title == lang.script.WINDOW_DONT_SHOW_AGAIN then
                dontShowAgain = true
            end
        end)
    end
end

local function disable()
    if not isEnable then
        return
    end
    nonil.enable()
    if not client.info.capabilities.textDocument.semanticTokens.dynamicRegistration then
        return
    end
    nonil.disable()
    isEnable = false
    log.debug('Disable semantic tokens.')
    proto.request('client/unregisterCapability', {
        unregisterations = {
            {
                id = 'semantic-tokens',
                method = 'textDocument/semanticTokens',
            },
        }
    })
end

local function refresh()
    if not isEnable then
        return
    end
    log.debug('Refresh semantic tokens.')
    proto.request('workspace/semanticTokens/refresh', json.null)
end

config.watch(function (key, value, oldValue)
    if key == 'Lua.color.mode' then
        if value == 'Semantic' or value == 'SemanticEnhanced' then
            if isEnable and value ~= oldValue then
                refresh()
            else
                enable()
            end
        else
            disable()
        end
    end
    if key:find '^Lua.runtime'
    or key:find '^Lua.workspace'
    or key:find '^files' then
        refresh()
    end
end)

return {
    enable  = enable,
    disable = disable,
    refresh = refresh,
}
