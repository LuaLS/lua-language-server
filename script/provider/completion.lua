local proto = require 'proto'

local isEnable = false

local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@|=- ]]
    local list = {}
    for c in str:gmatch '.' do
        list[#list+1] = c
    end
    return list
end

local function enable()
    -- TODO 检查客户端是否支持动态注册自动完成
    if isEnable then
        return
    end
    isEnable = true
    log.debug('Enable completion.')
    proto.awaitRequest('client/registerCapability', {
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
    isEnable = false
    log.debug('Disable completion.')
    proto.awaitRequest('client/unregisterCapability', {
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
