if not DEVELOP then
    return
end

local fs = require 'bee.filesystem'
local luaDebugs = {}

for _, vscodePath in ipairs {'.vscode', '.vscode-insiders', '.vscode-server-insiders'} do
    local extensionPath = fs.path(os.getenv 'USERPROFILE' or os.getenv 'HOME') / vscodePath / 'extensions'
    log.debug('Search extensions at:', extensionPath:string())

    if fs.exists(extensionPath) then
        for path in fs.pairs(extensionPath) do
            if fs.is_directory(path) then
                local name = path:filename():string()
                if name:find('actboy168.lua-debug-', 1, true) then
                    luaDebugs[#luaDebugs+1] = path:string()
                end
            end
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

local debugPath = luaDebugs[1]
local cpath = "/runtime/win64/lua54/?.dll;/runtime/win64/lua54/?.so"
local path  = "/script/?.lua"

local function tryDebugger()
    local entry = assert(package.searchpath('debugger', debugPath .. path))
    local root = debugPath
    local addr = ("127.0.0.1:%d"):format(DBGPORT)
    local dbg = loadfile(entry)(root)
    dbg:start {
        address = addr,
    }
    log.debug('Debugger startup, listen port:', DBGPORT)
    log.debug('Debugger args:', addr, root, path, cpath)
    if DBGWAIT then
        dbg:event('wait')
    end
    return dbg
end

xpcall(tryDebugger, log.debug)
