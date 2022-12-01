local net      = require 'service.net'
local timer    = require 'timer'
local config   = require 'config'
local client   = require 'client'
local nonil    = require 'without-check-nil'
local util     = require 'utility'
local platform = require 'bee.platform'
local proto    = require 'proto.proto'
local lang     = require 'language'
local define   = require 'proto.define'
local await    = require 'await'
local version  = require 'version'
local ws       = require 'workspace'

local tokenPath = (ROOT / 'log' / 'token'):string()
local token = util.loadFile(tokenPath)
if not token then
    token = ('%016X'):format(math.random(0, math.maxinteger))
    util.saveFile(tokenPath, token)
end

log.debug('Telemetry Token:', token)

local function getClientName()
    nonil.enable()
    local clientName    = client.info.clientInfo.name
    local clientVersion = client.info.clientInfo.version
    nonil.disable()
    return table.concat({clientName, clientVersion}, ' ')
end

local function send(link, msg)
    link:write(('s4'):pack(msg))
end

local function pushClientInfo(link)
    send(link, string.pack('zzz'
        , 'pulse'
        , token
        , getClientName()
    ))
end

local function pushPlatformInfo(link)
    send(link, string.pack('zzzzz'
        , 'platform'
        , token
        , ('%s %s'):format(platform.OS, platform.Arch)
        , ('%s %s'):format(platform.CRT, platform.CRTVersion)
        , ('%s %s'):format(platform.Compiler, platform.CompilerVersion)
    ))
end

local function pushVersion(link)
    send(link, string.pack('zzz'
        , 'version'
        , token
        , version.getVersion()
    ))
end

local function occlusionPath(str)
    return str:gsub('(%s*)([^:"\'%<%[%]\r\n]+)', function (left, chunk)
        if not chunk:find '[/\\]' then
            return
        end
        local newStr, count = chunk:gsub('.+([/\\]script[/\\])', '***%1')
        if count > 0 then
            return left .. newStr
        elseif chunk:sub(1, 1) == '\\'
        or     chunk:sub(1, 1) == '/'
        or     chunk:sub(1, 3) == '...' then
            return left .. '***'
        end
    end)
end

local function pushErrorLog(link)
    local err = log.firstError
    if not err then
        return
    end
    log.firstError = nil
    err = occlusionPath(err)
    send(link, string.pack('zzzz'
        , 'error'
        , token
        , getClientName()
        , ('%q'):format(err)
    ))
end

---@type boolean?
local isValid  = false

timer.wait(5, function ()
    timer.loop(300, function ()
        if isValid ~= true then
            return
        end
        local suc, link = pcall(net.connect, 'tcp', 'moe-moe.love', 11577)
        if not suc then
            suc, link = pcall(net.connect, 'tcp', '154.23.191.39', 11577)
        end
        if not suc or not link then
            return
        end
        function link:on_connect()
            pushClientInfo(link)
            pushPlatformInfo(link)
            pushVersion(link)
            pushErrorLog(link)
            self:close()
        end
    end)()
    timer.loop(1, function ()
        if isValid ~= true then
            return
        end
        net.update()
    end)
end)

local m = {}

function m.updateConfig()
    local enable = config.get(nil, 'Lua.telemetry.enable')
    assert(enable == true or enable == false or enable == nil)
    isValid = enable
    if isValid == false then
        return
    end
    for _, scp in ipairs(ws.folders) do
        if config.get(scp.uri, 'Lua.telemetry.enable') == false then
            isValid = false
            return
        end
    end
    for _, scp in ipairs(ws.folders) do
        if config.get(scp.uri, 'Lua.telemetry.enable') == true then
            isValid = true
            break
        end
    end
    if isValid ~= nil then
        return
    end
    if not client.getOption 'changeConfiguration' then
        return
    end
    if m.hasShowedMessage then
        return
    end
    m.hasShowedMessage = true

    await.call(function () ---@async
        local enableTitle  = lang.script.WINDOW_TELEMETRY_ENABLE
        local disableTitle = lang.script.WINDOW_TELEMETRY_DISABLE
        local item = proto.awaitRequest('window/showMessageRequest', {
            message = lang.script.WINDOW_TELEMETRY_HINT,
            type    = define.MessageType.Info,
            actions = {
                {
                    title = enableTitle,
                },
                {
                    title = disableTitle,
                },
            }
        })
        if not item then
            return
        end
        if item.title == enableTitle then
            client.setConfig {
                {
                    key      = 'Lua.telemetry.enable',
                    action   = 'set',
                    value    = true,
                    global   = true,
                }
            }
        elseif item.title == disableTitle then
            client.setConfig {
                {
                    key      = 'Lua.telemetry.enable',
                    action   = 'set',
                    value    = false,
                    global   = true,
                }
            }
        end
    end)
end

config.watch(function (uri, key, value)
    if key == 'Lua.telemetry.enable'
    or key == '' then
        m.updateConfig()
    end
end)

return m
