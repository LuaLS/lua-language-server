local rpc = require 'rpc'
local workspace = require 'workspace'

return function (lsp)
    rpc:request('workspace/workspaceFolders', nil, function (folders)
        if folders then
            local folder = folders[1]
            if folder then
                lsp.workspace = workspace(lsp, folder.name)
                lsp.workspace:init(folder.uri)
            end
        end
    end)
    -- 必须动态注册的事件：
    rpc:request('client/registerCapability', {
        registrations = {
            -- 监视文件变化
            {
                id = '0',
                method = 'workspace/didChangeWatchedFiles',
                registerOptions = {
                    watchers = {
                        {
                            globPattern = '**/*.lua',
                            kind = 1 | 4, -- Create | Change | Delete
                        },
                    },
                },
            },
        }
    }, function ()
        log.debug('client/registerCapability Success!')
    end)
    return true
end
