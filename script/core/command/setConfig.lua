local client = require 'provider.client'

return function (data)
    client.setConfig {data}
end
