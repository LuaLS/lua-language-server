local version   = require 'runtime.version'
local fs        = require 'bee.filesystem'

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
