local rpc = require 'rpc'

local isEnable = false

local function enable()
    if isEnable then
        return
    end
    isEnable = true
    log.debug('Enable semantic.')
    rpc:request('client/registerCapability', {
        registrations = {
            {
                id = 'semantic',
                method = 'textDocument/semanticTokens',
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
                method = 'textDocument/semanticTokens',
            },
        }
    })
end

return {
    enable = enable,
    disable = disable,
}
