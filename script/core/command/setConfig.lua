local client = require 'provider.client'

return function (data)
    client.setConfig(data.key, data.action, data.value, data.isGlobal, data.uri)
end
