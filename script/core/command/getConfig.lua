local config = require 'config'

return function (data)
    return config.get(data[1].uri, data[1].key)
end
