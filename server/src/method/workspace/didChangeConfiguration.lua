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
            {
                scopeUri = uri,
                section = 'files.associations',
            },
            {
                scopeUri = uri,
                section = 'files.exclude',
            }
        },
    }, function (configs)
        lsp:onUpdateConfig(configs[1], {
            associations = configs[2],
            exclude      = configs[3],
        })
    end)
end
