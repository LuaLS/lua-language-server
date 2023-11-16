
local argparser = require 'runtime.argparser'
local version   = require 'runtime.version'

---@class LuaLS.Runtime
local M = {}

--启动时的命令行参数
---@class LuaLS.Runtime.Args
---@field DEVELOP? boolean # 是否为开发模式
---@field DBGPORT? integer # 调试器端口号，默认为 11411
---@field DBGADDRESS? string # 调试器地址，默认为 '127.0.0.1'
M.args = {
    --指定日志输出目录，默认为 `./log`
    LOGPATH = '${LUALS}/log',
    --指定meta文件的生成目录，默认为 `./meta`
    METAPATH = '${LUALS}/meta',
    --是否为开发模式
    DEVELOP = false,
    --调试器端口号，默认为 11411
    DBGPORT = 11411,
    --调试器地址，默认为 '127.0.0.1'
    DBGADDRESS = '127.0.0.1',
    --等待调试器连接
    DBGWAIT = false,
    --显示语言
    LOCALE = 'en-us',
    --全局配置文件的路径
    CONFIGPATH = '',
    --在日志中记录RPC信息
    RPCLOG = false,
    --使用socket来连接客户端，指定端口号
    SOCKET = 0,
    --强制接受工作区。默认情况下会拒绝根目录与Home目录作为工作区
    FORCE_ACCEPT_WORKSPACE = false,

    --命令行：诊断指定工作区
    CHECK = '',
    --诊断工作区时需要报告的诊断等级
    ---@type 'Error' | 'Warning' | 'Information' | 'Hint'
    CHECKLEVEL = 'Warning',
    --诊断报告生成的文件路径（json），默认为 `$LOGPATH/check.json`
    CHECK_OUT_PATH = '${LOGPATH}/check.json',

    --命令行：生成文档
    DOC = '',
}
luals.util.tableMerge(M.args, argparser.parse(arg, true))

--启动时的版本号
M.version = version.getVersion()

--路径相关
---@class LuaLS.Path
M.path = {}

---@return string
local function findRoot()
    local lastPath
    for i = 1, 10 do
        local currentPath = debug.getinfo(i, 'S').source
        if currentPath:sub(1, 1) ~= '@' then
            break
        end
        lastPath = currentPath:sub(2)
    end
    assert(lastPath, 'Can not find root path')
    local rootPath = lastPath:gsub('[/\\]*[^/\\]-$', '')
    rootPath = (rootPath == '' and '.' or rootPath)
    return rootPath
end

--语言服务器根路径
M.rootUri = luals.uri.encode(luals.util.expandPath(findRoot()))
M.logUri  = luals.uri.encode(luals.util.expandPath(M.args.LOGPATH))
M.metaUri = luals.uri.encode(luals.util.expandPath(M.args.METAPATH))

return M
