local rpc = require 'rpc'
local workspace = require 'workspace'
local config = require 'config'

local function initAfterConfig(lsp) 
    -- 请求工作目录
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
    -- 请求配置
    rpc:request('workspace/configuration', {
        items = {
            {
                section = 'Lua',
            },
        },
    }, function (configs)
        lsp:onUpdateConfig(configs[1])
        initAfterConfig(lsp)
    end)
    return true
end
