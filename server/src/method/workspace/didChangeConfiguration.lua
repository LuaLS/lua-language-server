local rpc = require 'rpc'

return function (lsp)
    local uri = lsp.workspace and lsp.workspace.uri
    -- 请求配置
    rpc:request('workspace/configuration', {
        items = {
            {
                scopeUri = uri,
                section = 'Lua',
            },
        },
    }, function (configs)
        lsp:onUpdateConfig(configs[1])
    end)
end
