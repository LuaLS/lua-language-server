local rpc       = require 'rpc'
local workspace = require 'workspace'

local function initAfterConfig(lsp)
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
                            globPattern = '**/',
                            kind = 1 | 2 | 4,
                        }
                    },
                },
            },
            -- 配置变化
            {
                id = '1',
                method = 'workspace/didChangeConfiguration',
            }
        }
    }, function ()
        log.debug('client/registerCapability Success!')
    end)
end

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
        initAfterConfig(lsp)
    end)
    return true
end
