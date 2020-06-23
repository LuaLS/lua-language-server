local rpc = require 'rpc'
local nonil = require 'without-check-nil'

local isEnable = false

local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@| ]]
    local list = {}
    for c in str:gmatch '.' do
        list[#list+1] = c
    end
    return list
end

local function enable(lsp)
    if isEnable then
        return
    end

    nonil.enable()
    if not lsp.client.capabilities.textDocument.completion.dynamicRegistration then
        return
    end
    nonil.disable()

    isEnable = true
    log.debug('Enable completion.')
    rpc:request('client/registerCapability', {
        registrations = {
            {
                id = 'completion',
                method = 'textDocument/completion',
                registerOptions = {
                    resolveProvider = true,
                    triggerCharacters = allWords(),
                },
            },
        }
    })
end

local function disable(lsp)
    if not isEnable then
        return
    end

    nonil.enable()
    if not lsp.client.capabilities.textDocument.completion.dynamicRegistration then
        return
    end
    nonil.disable()

    isEnable = false
    log.debug('Disable completion.')
    rpc:request('client/unregisterCapability', {
        unregisterations = {
            {
                id = 'completion',
                method = 'textDocument/completion',
            },
        }
    })
end

return {
    enable = enable,
    disable = disable,
}
