
local argparser = require 'runtime.argparser'
local version   = require 'runtime.version'
local platform  = require 'bee.platform'

---@class LuaLS.Runtime
local M = {}

--启动时的命令行参数
---@class LuaLS.Runtime.Args
M.args = {
    -- 指定日志输出目录，默认为 `./log`
    LOGPATH = '$LUALSPATH/log',
    -- 指定meta文件的生成目录，默认为 `./meta`
    METAPATH = '$LUALSPATH/meta',
    -- 是否为开发模式
    DEVELOP = false,
    -- 调试器端口号，默认为 11411
    DBGPORT = 11411,
    -- 调试器地址，默认为 '127.0.0.1'
    DBGADDRESS = '127.0.0.1',
    -- 等待调试器连接
    DBGWAIT = false,
    -- 显示语言
    LOCALE = 'en-us',
    -- 全局配置文件的路径
    CONFIGPATH = '',
    -- 在日志中记录RPC信息
    RPCLOG = false,
    -- 使用socket来连接客户端，指定端口号
    SOCKET = 0,
    -- 强制接受工作区。默认情况下会拒绝根目录与Home目录作为工作区
    FORCE_ACCEPT_WORKSPACE = false,
    -- 文件名是否区分大小写
    IGNORE_CASE = platform.os == 'windows'
               or platform.os == 'macos'
               or false,

    -- 命令行：诊断指定工作区
    CHECK = '',
    -- 诊断工作区时需要报告的诊断等级
    ---@type 'Error' | 'Warning' | 'Information' | 'Hint'
    CHECKLEVEL = 'Warning',
    -- 诊断报告生成的文件路径（json），默认为 `$LOGPATH/check.json`
    CHECK_OUT_PATH = '$LOGPATH/check.json',

    -- 命令行：生成文档
    DOC = '',
}
ls.util.tableMerge(M.args, argparser.parse(arg, true))

---@return string
local function findRoot()
    local currentPath
    for i = 1, 100 do
        local info = debug.getinfo(i, 'S')
        if not info then
            break
        end
        currentPath = info.source
        if currentPath:match '@%a:' then
            break
        end
    end
    assert(currentPath, 'Can not find root path')
    local rootPath = currentPath:sub(2):gsub('[/\\]*[^/\\]-$', '')
    rootPath = (rootPath == '' and '.' or rootPath)
    return rootPath
end

--环境变量
M.env = {}
--语言服务器根路径
M.rootPath        = ls.util.expandPath(findRoot())
M.env.LUALSPATH   = M.rootPath
M.logPath         = ls.util.expandPath(M.args.LOGPATH, M.env)
M.env.LOGPATH     = M.logPath
M.metaPath        = ls.util.expandPath(M.args.METAPATH, M.env)
M.env.METAPATH    = M.metaPath
M.rootUri         = ls.uri.encode(M.rootPath)
M.logUri          = ls.uri.encode(M.logPath)
M.metaUri         = ls.uri.encode(M.metaPath)
M.env.IGNORE_CASE = M.args.IGNORE_CASE

--启动时的版本号
M.version = version.getVersion(M.rootPath)

return M
