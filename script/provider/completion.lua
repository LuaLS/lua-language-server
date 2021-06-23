local proto  = require 'proto'
local nonil  = require 'without-check-nil'
local client = require 'provider.client'

local isEnable = false

local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@|=-{ ]]
    local list = {'\t', '\n'}
    for c in str:gmatch '.' do
        list[#list+1] = c
    end
    return list
end

local function enable()
    if isEnable then
        return
    end
    nonil.enable()
    if not client.info.capabilities.textDocument.completion.dynamicRegistration then
        return
    end
    nonil.disable()
    isEnable = true
    log.debug('Enable completion.')
    proto.request('client/registerCapability', {
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

local function disable()
    if not isEnable then
        return
    end
    nonil.enable()
    if not client.info.capabilities.textDocument.completion.dynamicRegistration then
        return
    end
    nonil.disable()
    isEnable = false
    log.debug('Disable completion.')
    proto.request('client/unregisterCapability', {
        unregisterations = {
            {
                id = 'completion',
                method = 'textDocument/completion',
            },
        }
    })
end

return {
    enable   = enable,
    disable  = disable,
    allWords = allWords,
}
