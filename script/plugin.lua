local fs        = require 'bee.filesystem'
local rpc       = require 'rpc'
local config    = require 'config'
local glob      = require 'glob'
local platform  = require 'bee.platform'
local sandbox   = require 'sandbox'

local Plugins

local function showError(msg)
    local traceback = log.error(msg)
    rpc:notify('window/showMessage', {
        type = 3,
        message = traceback,
    })
    return traceback
end

local function showWarn(msg)
    log.warn(msg)
    rpc:notify('window/showMessage', {
        type = 3,
        message = msg,
    })
    return msg
end

local function scan(path, callback)
    if fs.is_directory(path) then
        for p in path:list_directory() do
            scan(p, callback)
        end
    else
        callback(path)
    end
end

local function loadPluginFrom(path, root)
    log.info('Load plugin from:', path:string())
    local env = setmetatable({}, { __index = _G })
    sandbox(path:filename():string(), root:string(), io.open, package.loaded, env)
    Plugins[#Plugins+1] = env
end

local function load(workspace)
    Plugins = nil

    if not config.config.plugin.enable then
        return
    end
    local suc, path = xpcall(fs.path, showWarn, config.config.plugin.path)
    if not suc then
        return
    end

    Plugins = {}
    local pluginPath
    if workspace then
        pluginPath = fs.absolute(workspace.root / path)
    else
        pluginPath = fs.absolute(path)
    end
    if not fs.is_directory(pluginPath) then
        pluginPath = pluginPath:parent_path()
    end

    local pattern = {config.config.plugin.path}
    local options = {
        ignoreCase = platform.OS == 'Windows'
    }
    local parser = glob.glob(pattern, options)

    scan(pluginPath:parent_path(), function (filePath)
        if parser(filePath:string()) then
            loadPluginFrom(filePath, pluginPath)
        end
    end)
end

local function call(name, ...)
    if not Plugins then
        return nil
    end
    for _, plugin in ipairs(Plugins) do
        if type(plugin[name]) == 'function' then
            local suc, res = xpcall(plugin[name], showError, ...)
            if suc and res ~= nil then
                return res
            end
        end
    end
    return nil
end

return {
    load = load,
    call = call,
}
