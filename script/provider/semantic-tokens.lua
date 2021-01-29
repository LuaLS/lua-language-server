local proto          = require 'proto'
local define         = require 'proto.define'
local client         = require 'provider.client'
local json           = require "json"
local config         = require 'config'
local lang           = require 'language'

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
    if not client.info.capabilities.textDocument.semanticTokens then
        return
    end
    isEnable = true
    log.debug('Enable semantic tokens.')
    proto.awaitRequest('client/registerCapability', {
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
    if config.other.semantic == 'configuredByTheme' and not dontShowAgain then
        local item = proto.awaitRequest('window/showMessageRequest', {
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
        })
        if item then
            if item.title == lang.script.WINDOW_APPLY_SETTING then
                proto.notify('$/command', {
                    command   = 'lua.config',
                    data      = {
                        key    = 'editor.semanticHighlighting.enabled',
                        action = 'set',
                        value  = true,
                        global = true,
                    }
                })
            end
            if item.title == lang.script.WINDOW_DONT_SHOW_AGAIN then
                dontShowAgain = true
            end
        end
    end
end

local function disable()
    if not isEnable then
        return
    end
    isEnable = false
    log.debug('Disable semantic tokens.')
    proto.awaitRequest('client/unregisterCapability', {
        unregisterations = {
            {
                id = 'semantic-tokens',
                method = 'textDocument/semanticTokens',
            },
        }
    })
end

local function refresh()
    log.debug('Refresh semantic tokens.')
    proto.notify('workspace/semanticTokens/refresh', json.null)
end

return {
    enable  = enable,
    disable = disable,
    refresh = refresh,
}
