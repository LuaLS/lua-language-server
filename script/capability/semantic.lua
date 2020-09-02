local rpc            = require 'rpc'
local TokenTypes     = require 'constant.TokenTypes'
local TokenModifiers = require 'constant.TokenModifiers'

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

local function enable(lsp)
    if isEnable then
        return
    end
    if not lsp.client.capabilities.textDocument.semanticTokens then
        return
    end
    isEnable = true
    log.debug('Enable semantic.')
    rpc:request('client/registerCapability', {
        registrations = {
            {
                id = 'semantic',
                method = 'textDocument/semanticTokens/full',
                registerOptions = {
                    legend = {
                        tokenTypes = toArray(TokenTypes),
                        tokenModifiers = toArray(TokenModifiers),
                    },
                    rangeProvider = false,
                    documentProvider = false,
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
    log.debug('Disable semantic.')
    rpc:request('client/unregisterCapability', {
        unregisterations = {
            {
                id = 'semantic',
                method = 'textDocument/semanticTokens/full',
            },
        }
    })
end

return {
    enable = enable,
    disable = disable,
}
