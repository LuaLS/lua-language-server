local rpc = require 'rpc'
local config = require 'config'

local EXISTS = {}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    end
    return a == b
end

local function copyTable(a)
    local t = {}
    for k, v in pairs(a) do
        if type(v) == 'table' then
            t[k] = copyTable(v)
        else
            t[k] = v
        end
    end
    return t
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
        local oldConfig = copyTable(config.config)
        config:setConfig(configs[1])
        local newConfig = config.config
        if not eq(oldConfig.diagnostics, newConfig.diagnostics) then
            log.debug('reDiagnostic')
            lsp:reDiagnostic()
        end
        if not eq(oldConfig.workspace, newConfig.workspace) then
            lsp:clearAllFiles()
            lsp.workspace:scanFiles()
        end
    end)
end
