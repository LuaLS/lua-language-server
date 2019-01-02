local rpc = require 'rpc'
local config =require 'config'

return function (lsp)
    -- 请求配置
    rpc:request('workspace/configuration', {
        items = {
            {
                section = 'Lua',
            },
        },
    }, function (configs)
        config:setConfig(configs[1])
    end)
end
