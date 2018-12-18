local rpc = require 'rpc'
local workspace = require 'workspace'

return function (lsp)
    lsp.workspace = workspace()
    -- 必须动态注册的事件：
    rpc:request('client/registerCapability', {
        registrations = {
            -- 监事文件变化
            {
                id = '0',
                method = 'workspace/didChangeWatchedFiles',
                registerOptions = {
                    watchers = {
                        {
                            globPattern = '**/*.lua',
                            kind = 1 | 2 | 4, -- Create | Delete
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
