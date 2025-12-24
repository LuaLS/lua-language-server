local argparser = require 'runtime.argparser'
local platform  = require 'bee.platform'

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
    SAVE_CODER = false,

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
