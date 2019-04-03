local rpc = require 'rpc'

return function (lsp)
    -- 请求配置
    rpc:request('workspace/configuration', {
        items = {
            {
                section = 'Lua',
            },
        },
    }, function (configs)
        lsp:onUpdateConfig(configs[1])
    end)
end
