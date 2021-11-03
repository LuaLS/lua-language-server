local fs      = require 'bee.filesystem'
local util    = require 'utility'
local version = require 'version'

local function loadArgs()
    for _, v in ipairs(arg) do
        ---@type string
        local key, tail = v:match '^%-%-([%w_]+)(.*)$'
        if not key then
            goto CONTINUE
        end
        local value = tail:match '=(.+)'
        if value == 'true' or value == nil then
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

local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
rootPath = (rootPath == '' and '.' or rootPath)
ROOT     = fs.path(util.expandPath(rootPath))
LOGPATH  = LOGPATH  and util.expandPath(LOGPATH)  or (ROOT:string() .. '/log')
METAPATH = METAPATH and util.expandPath(METAPATH) or (ROOT:string() .. '/meta')

if _G['VERSION'] then
    print(version.getVersion())
    return
end

---@diagnostic disable-next-line: deprecated
debug.setcstacklimit(200)
--collectgarbage('generational', 5, 25)
collectgarbage('incremental', 120, 120, 0)

---@diagnostic disable-next-line: lowercase-global
log = require 'log'
log.init(ROOT, fs.path(LOGPATH) / 'service.log')
log.info('Lua Lsp startup, root: ', ROOT)
log.debug('ROOT:', ROOT:string())
log.debug('LOGPATH:', LOGPATH)
log.debug('METAPATH:', METAPATH)
log.debug('VERSION:', version.getVersion())

require 'tracy'

xpcall(dofile, log.debug, (ROOT / 'debugger.lua'):string())

local _, service = xpcall(require, log.error, 'service')

service.start()
