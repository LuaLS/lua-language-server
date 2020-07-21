if not DEVELOP then
    return
end

local fs = require 'bee.filesystem'
local extensionPath = fs.path(os.getenv 'USERPROFILE' or '') / '.vscode' / 'extensions'
log.debug('Search extensions at:', extensionPath:string())
if not fs.is_directory(extensionPath) then
    log.debug('Extension path is not a directory.')
    return
end

local luaDebugs = {}
for path in extensionPath:list_directory() do
    if fs.is_directory(path) then
        local name = path:filename():string()
        if name:find('actboy168.lua-debug-', 1, true) then
            luaDebugs[#luaDebugs+1] = name
        end
    end
end

if #luaDebugs == 0 then
    log.debug('Cant find "actboy168.lua-debug"')
    return
end

local function getVer(filename)
    local a, b, c = filename:match('(%d+)%.(%d+)%.(%d+)$')
    if not a then
        return 0
    end
    return a * 1000000 + b * 1000 + c
end

table.sort(luaDebugs, function (a, b)
    return getVer(a) > getVer(b)
end)

local debugPath = extensionPath / luaDebugs[1]
local cpath = "/runtime/win64/lua54/?.dll"
local path  = "/script/?.lua"

local function tryDebugger()
    local entry = assert(package.searchpath('debugger', debugPath:string() .. path))
    local root = debugPath:string()
    local addr = ("127.0.0.1:%d"):format(DBGPORT)
    local dbg = loadfile(entry)(root)
    dbg:start(addr)
    log.debug('Debugger startup, listen port:', DBGPORT)
    log.debug('Debugger args:', addr, root, path, cpath)
    if DBGWAIT then
        dbg:wait()
    end
    return dbg
end

xpcall(tryDebugger, log.debug)
