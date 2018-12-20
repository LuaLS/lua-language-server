local rpc = require 'rpc'

return function ()
    -- 暂不支持多个工作目录，因此当工作目录切换时，暴力结束服务，让前端重启服务
    rpc:requestWait('window/showMessageRequest', {
        type = 3,
        message = '[Lua] dose not support multi workspace now, I may need to restart to support the new workspace ...',
        actions = {
            {
                title = 'Restart'
            }
        }
    }, function ()
        os.exit(true)
    end)
end
