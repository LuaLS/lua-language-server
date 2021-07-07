local nonil     = require 'without-check-nil'
local util      = require 'utility'
local lang      = require 'language'
local proto     = require 'proto'
local define    = require 'proto.define'
local config    = require 'config'

local m = {}
m.watchList = {}

function m.client(newClient)
    if newClient then
        m._client = newClient
    else
        return m._client
    end
end

function m.isVSCode()
    if not m._client then
        return false
    end
    if m._isvscode == nil then
        local lname = m._client:lower()
        if lname:find 'vscode'
        or lname:find 'visual studio code' then
            m._isvscode = true
        else
            m._isvscode = false
        end
    end
    return m._isvscode
end

function m.getOption(name)
    nonil.enable()
    local option = m.info.initializationOptions[name]
    nonil.disable()
    return option
end

---show message to client
---@param type '"Error"'|'"Warning"'|'"Info"'|'"Log"'
---@param message any
function m.showMessage(type, message)
    proto.notify('window/showMessage', {
        type = define.MessageType[type] or 3,
        message = message,
    })
end

---set client config
---@param key string
---@param action '"set"'|'"add"'
---@param value any
---@param isGlobal boolean
---@param uri uri
function m.setConfig(key, action, value, isGlobal, uri)
    if action == 'add' then
        config.add(key, value)
    elseif action == 'set' then
        config.set(key, value)
    end
    m.event('updateConfig')
    if m.getOption 'changeConfiguration' then
        proto.notify('$/command', {
            command   = 'lua.config',
            data      = {
                key    = key,
                action = action,
                value  = value,
                global = isGlobal,
                uri    = uri,
            }
        })
    else
        -- TODO translate
        local message = lang.script('你的客户端不支持从服务侧修改设置，请手动修改如下设置：')
        if action == 'add' then
            message = message .. lang.script('为 `{key}` 添加值 `{value:q}`', {
                key   = key,
                value = value,
            })
        else
            message = message .. lang.script('将 `{key}` 的值设置为 `{value:q}`', {
                key   = key,
                value = value,
            })
        end
        m.showMessage('Info', message)
    end
end

function m.event(ev, ...)
    for _, callback in ipairs(m.watchList) do
        callback(ev, ...)
    end
end

function m.watch(callback)
    m.watchList[#m.watchList+1] = callback
end

function m.init(t)
    log.debug('Client init', util.dump(t))
    m.info = t
    nonil.enable()
    m.client(t.clientInfo.name)
    nonil.disable()
    lang(LOCALE or t.locale)
end

return m
