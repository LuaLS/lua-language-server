local proto          = require 'proto'
local tokenTypes     = require 'define.TokenTypes'
local tokenModifiers = require 'define.TokenModifiers'
local client         = require 'provider.client'

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
                method = 'textDocument/semanticTokens/full',
                registerOptions = {
                    legend = {
                        tokenTypes     = toArray(tokenTypes),
                        tokenModifiers = toArray(tokenModifiers),
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
                method = 'textDocument/semanticTokens/full',
            },
        }
    })
end

return {
    enable = enable,
    disable = disable,
}
