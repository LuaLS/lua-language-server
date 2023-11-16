
local argparser = require 'runtime.argparser'

---@class LuaLS.Runtime
local M = {}

--启动时的命令行参数
M.args = argparser.parse(arg, true)

--路径相关
---@class LuaLS.Path
M.path = {}

local function findRoot()
    local lastPath
    for i = 1, 10 do
        local currentPath = debug.getinfo(i, 'S').source
        if currentPath:sub(1, 1) ~= '@' then
            break
        end
        lastPath = currentPath:sub(2)
    end
    return lastPath
end

--语言服务器根路径
M.path.root = findRoot()

return M
