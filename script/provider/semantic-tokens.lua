local proto          = require 'proto'
local define         = require 'proto.define'
local client         = require 'provider.client'
local json           = require "json"

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
