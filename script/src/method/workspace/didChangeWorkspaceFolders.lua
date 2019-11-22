local rpc = require 'rpc'
local lang = require 'language'

return function ()
    -- 暂不支持多个工作目录，因此当工作目录切换时，暴力结束服务，让前端重启服务
    rpc:requestWait('window/showMessageRequest', {
        type = 3,
        message = lang.script('MWS_NOT_SUPPORT', '[Lua]'),
        actions = {
            {
                title = lang.script.MWS_RESTART,
            }
        }
    }, function ()
        os.exit(true)
    end)
    ac.wait(5, function ()
        os.exit(true)
    end)
end
