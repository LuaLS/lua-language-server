local rpc = require 'rpc'

local isEnable = false

local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@| ]]
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
    isEnable = true
    log.debug('Enable completion.')
    rpc:request('client/registerCapability', {
        registrations = {
            {
                id = 'completion',
                method = 'textDocument/completion',
                registerOptions = {
                    resolveProvider = false,
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
