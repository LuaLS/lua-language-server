local client = require 'client'
local await  = require 'await'

---@async
---@param changes config.change[]
return function (changes)
    while not client:isReady() do
        await.sleep(0.1)
    end
    client.setConfig(changes)
end
