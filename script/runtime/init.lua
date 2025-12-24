local argparser = require 'runtime.argparser'
local version   = require 'runtime.version'
local platform  = require 'bee.platform'
local fs        = require 'bee.filesystem'

--启动时的命令行参数
---@class LuaLS.Args
ls.args = {
    -- 指定日志输出目录，默认为 `./log`
    LOGPATH = '$ROOT_PATH/log',
    -- 指定meta文件的生成目录，默认为 `./meta`
    METAPATH = '$ROOT_PATH/meta',
    -- 初始日志路径
    LOGFILE = '$LOG_PATH/service.log',
    -- 是否为开发模式
    DEVELOP = false,
    -- 调试器端口号，默认为 11411
    DBGPORT = 11411,
    -- 调试器地址，默认为 '127.0.0.1'
    DBGADDRESS = '127.0.0.1',
    -- 等待调试器连接
    DBGWAIT = false,
    -- 显示语言
    LOCALE = 'auto',
    -- 日志等级
    LOGLEVEL = 'debug',
    -- 全局配置文件的路径
    CONFIGPATH = '',
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
ls.util.tableMerge(ls.args, argparser.parse(arg, true))

---@return string
local function findRoot()
    local currentPath
    for i = 1, 100 do
        local info = debug.getinfo(i, 'S')
        if not info then
            break
        end
        currentPath = info.source
        if currentPath:sub(1, 1) == '@' then
            break
        end
    end
    assert(currentPath, 'Can not find root path')
    local rootPath = fs.path(currentPath:sub(2)):parent_path():parent_path():parent_path():string()
    if rootPath == '' or rootPath == '.' then
        rootPath = fs.current_path():string()
    end
    rootPath = rootPath:gsub('[/\\]', package.config:sub(1, 1))
    return rootPath
end

--环境变量
---@class LuaLS.Env
ls.env = {}
--语言服务器根路径
ls.env.ROOT_PATH   = ls.util.expandPath(findRoot())
ls.env.LOG_PATH    = ls.util.expandPath(ls.args.LOGPATH, ls.env)
ls.env.META_PATH   = ls.util.expandPath(ls.args.METAPATH, ls.env)
ls.env.LOG_FILE    = ls.util.expandPath(ls.args.LOGFILE, ls.env)
ls.env.ROOT_URI    = ls.uri.encode(ls.env.ROOT_PATH)
ls.env.LOG_URI     = ls.uri.encode(ls.env.LOG_PATH)
ls.env.META_URI    = ls.uri.encode(ls.env.META_PATH)
ls.env.IGNORE_CASE = ls.args.IGNORE_CASE

--启动时的版本号
ls.env.version = version.getVersion(ls.env.ROOT_PATH)
