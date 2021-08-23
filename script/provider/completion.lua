local proto  = require 'proto'
local nonil  = require 'without-check-nil'
local client = require 'client'
local config = require 'config'

local isEnable = false

local function allWords()
    local str = '\t\n.:(\'"[,#*@|=-{/\\ '
    local list = {}
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

config.watch(function (key, value)
    if key == 'Lua.completion.enable' then
        if value == true then
            enable()
        else
            disable()
        end
    end
end)

return {
    enable   = enable,
    disable  = disable,
    allWords = allWords,
}
