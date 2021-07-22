local nonil     = require 'without-check-nil'
local util      = require 'utility'
local lang      = require 'language'
local proto     = require 'proto'
local define    = require 'proto.define'
local config    = require 'config'

local m = {}

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

function m.getAbility(name)
    local current = m.info.capabilities
    while true do
        local parent, nextPos = name:match '^([^%.]+)()'
        if not parent then
            break
        end
        current = current[parent]
        if not current then
            return nil
        end
        if nextPos > #name then
            break
        else
            name = name:sub(nextPos + 1)
        end
    end
    return current
end

local function packMessage(...)
    local strs = table.pack(...)
    for i = 1, strs.n do
        strs[i] = tostring(strs[i])
    end
    return table.concat(strs, '\t')
end

---@alias message.type '"Error"'|'"Warning"'|'"Info"'|'"Log"'

---show message to client
---@param type message.type
function m.showMessage(type, ...)
    local message = packMessage(...)
    proto.notify('window/showMessage', {
        type = define.MessageType[type] or 3,
        message = message,
    })
    proto.notify('window/logMessage', {
        type = define.MessageType[type] or 3,
        message = message,
    })
end

---@param type message.type
---@param message string
---@param titles  string[]
---@return string action
function m.awaitRequestMessage(type, message, titles)
    proto.notify('window/logMessage', {
        type = define.MessageType[type] or 3,
        message = message,
    })
    local actions = {}
    for i, title in ipairs(titles) do
        actions[i] = {
            title = title,
        }
    end
    local item = proto.awaitRequest('window/showMessageRequest', {
        type    = type,
        message = message,
        actions = actions,
    })
    if not item then
        return nil
    end
    return item.title
end

---@param type message.type
function m.logMessage(type, ...)
    local message = packMessage(...)
    proto.notify('window/logMessage', {
        type = define.MessageType[type] or 4,
        message = message,
    })
end

---@class config.change
---@field key       string
---@field prop?     string
---@field value     any
---@field action    '"add"'|'"set"'|'"prop"'
---@field isGlobal? boolean
---@field uri?      uri

---@param changes config.change[]
---@param onlyMemory boolean
function m.setConfig(changes, onlyMemory)
    local finalChanges = {}
    for _, change in ipairs(changes) do
        if change.action == 'add' then
            local suc = config.add(change.key, change.value)
            if suc then
                finalChanges[#finalChanges+1] = change
            end
        elseif change.action == 'set' then
            local suc = config.set(change.key, change.value)
            if suc then
                finalChanges[#finalChanges+1] = change
            end
        elseif change.action == 'prop' then
            local suc = config.prop(change.key, change.prop, change.value)
            if suc then
                finalChanges[#finalChanges+1] = change
            end
        end
        change.uri = m.info.rootUri
    end
    if onlyMemory then
        return
    end
    if #finalChanges == 0 then
        return
    end
    if m.getOption 'changeConfiguration' then
        proto.notify('$/command', {
            command   = 'lua.config',
            data      = finalChanges,
        })
    else
        local messages = {}
        messages[1] = lang.script('WINDOW_CLIENT_NOT_SUPPORT_CONFIG')
        for _, change in ipairs(finalChanges) do
            if change.action == 'add' then
                messages[#messages+1] = lang.script('WINDOW_MANUAL_CONFIG_ADD', change)
            elseif change.action == 'set' then
                messages[#messages+1] = lang.script('WINDOW_MANUAL_CONFIG_SET', change)
            elseif change.action == 'prop' then
                messages[#messages+1] = lang.script('WINDOW_MANUAL_CONFIG_PROP', change)
            end
        end
        local message = table.concat(messages, '\n')
        m.showMessage('Info', message)
    end
end

---@alias textEdit {start: integer, finish: integer, text: string}

---@param uri   uri
---@param edits textEdit[]
function m.editText(uri, edits)
    local files     = require 'files'
    local textEdits = {}
    uri = files.getOriginUri(uri)
    for i, edit in ipairs(edits) do
        textEdits[i] = define.textEdit(files.range(uri, edit.start, edit.finish), edit.text)
    end
    proto.request('workspace/applyEdit', {
        edit = {
            changes = {
                [uri] = textEdits,
            }
        }
    })
end

local function hookPrint()
    if TEST then
        return
    end
    print = function (...)
        m.logMessage('Log', ...)
    end
end

function m.init(t)
    log.debug('Client init', util.dump(t))
    m.info = t
    nonil.enable()
    m.client(t.clientInfo.name)
    nonil.disable()
    lang(LOCALE or t.locale)
    hookPrint()
end

return m
