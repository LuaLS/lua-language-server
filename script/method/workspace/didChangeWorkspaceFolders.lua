local rpc = require 'rpc'

--- @param lsp LSP
--- @param params table
return function (lsp, params)
    local event = params.event

    for _, removed in ipairs(event.removed) do
        lsp:removeWorkspace(removed.name, removed.uri)
    end

    for _, added in ipairs(event.added) do
        lsp:addWorkspace(added.name, added.uri)
    end

    local ws = lsp.workspaces[1]
    if ws then
        -- 请求工作目录
        local uri = ws.uri
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
end
