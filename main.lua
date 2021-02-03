local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
rootPath = (rootPath == '' and '.' or rootPath)
loadfile(rootPath .. '/platform.lua')('script')
local fs = require 'bee.filesystem'

local function expanduser(path)
    if path:sub(1, 1) == '~' then
        local home = os.getenv('HOME')
        if not home then -- has to be Windows
            home = os.getenv 'USERPROFILE' or (os.getenv 'HOMEDRIVE' .. os.getenv 'HOMEPATH')
        end
        return home .. path:sub(2)
    else
        return path
    end
end

local function loadArgs()
    for _, v in ipairs(arg) do
        local key, value = v:match '^%-%-([%w_]+)%=(.+)'
        if not key then
            goto CONTINUE
        end
        if value == 'true' then
            value = true
        elseif value == 'false' then
            value = false
        elseif tonumber(value) then
            value = tonumber(value)
        elseif value:sub(1, 1) == '"' and value:sub(-1, -1) == '"' then
            value = value:sub(2, -2)
        end
        _G[key:upper()] = value
        ::CONTINUE::
    end
end

loadArgs()

ROOT     = fs.path(expanduser(rootPath))
LOGPATH  = LOGPATH  and expanduser(LOGPATH)  or (ROOT:string() .. '/log')
METAPATH = METAPATH and expanduser(METAPATH) or (ROOT:string() .. '/meta')

debug.setcstacklimit(200)
collectgarbage('generational', 10, 50)
--collectgarbage('incremental', 120, 120, 0)

log = require 'log'
log.init(ROOT, fs.path(LOGPATH) / 'service.log')
log.info('Lua Lsp startup, root: ', ROOT)
log.debug('ROOT:', ROOT:string())
log.debug('LOGPATH:', LOGPATH)
log.debug('METAPATH:', METAPATH)

require 'tracy'

xpcall(dofile, log.debug, rootPath .. '/debugger.lua')

local service = require 'service'

service.start()
