local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
loadfile((rootPath == '' and '.' or rootPath) .. '/platform.lua')('script')
local fs = require 'bee.filesystem'
ROOT = fs.path(rootPath)

local function loadArgs()
    for _, v in ipairs(arg) do
        local key, value = v:match '^%-%-([%w_]+)%=(.+)'
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
    end
end

loadArgs()

LOGPATH  = LOGPATH  or (ROOT:string() .. '/log')
METAPATH = METAPATH or (ROOT:string() .. '/meta')

debug.setcstacklimit(200)
collectgarbage('generational', 10, 100)
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
