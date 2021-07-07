local client = require 'client'

return function (data)
    client.setConfig {data}
end
