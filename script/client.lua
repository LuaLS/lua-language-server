local nonil     = require 'without-check-nil'
local util      = require 'utility'
local lang      = require 'language'
local proto     = require 'proto'
local define    = require 'proto.define'
local config    = require 'config'
local converter = require 'proto.converter'
local json      = require 'json-beautify'

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
    if not m.info
    or not m.info.capabilities then
        return nil
    end
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

function m.getOffsetEncoding()
    if m._offsetEncoding then
        return m._offsetEncoding
    end
    local clientEncodings = m.getAbility 'offsetEncoding'
    if type(clientEncodings) == 'table' then
        for _, encoding in ipairs(clientEncodings) do
            if encoding == 'utf-8' then
                m._offsetEncoding = 'utf-8'
                return m._offsetEncoding
            end
        end
    end
    m._offsetEncoding = 'utf-16'
    return m._offsetEncoding
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
---@return integer index
---@async
function m.awaitRequestMessage(type, message, titles)
    proto.notify('window/logMessage', {
        type = define.MessageType[type] or 3,
        message = message,
    })
    local map = {}
    local actions = {}
    for i, title in ipairs(titles) do
        actions[i] = {
            title = title,
        }
        map[title] = i
    end
    local item = proto.awaitRequest('window/showMessageRequest', {
        type    = define.MessageType[type] or 3,
        message = message,
        actions = actions,
    })
    if not item then
        return nil
    end
    return item.title, map[item.title]
end

---@param type message.type
function m.logMessage(type, ...)
    local message = packMessage(...)
    proto.notify('window/logMessage', {
        type = define.MessageType[type] or 4,
        message = message,
    })
end

function m.watchFiles(path)
    path = path:gsub('\\', '/')
               :gsub('[%[%]%{%}%*%?]', '\\%1')
    local registration = {
        id              = path,
        method          = 'workspace/didChangeWatchedFiles',
        registerOptions = {
            watchers = {
                {
                    globPattern = path .. '/**',
                    kind = 1 | 2 | 4,
                },
            },
        },
    }
    proto.request('client/registerCapability', {
        registrations = {
            registration,
        }
    })

    return function ()
        local unregisteration = {
            id     = path,
            method = 'workspace/didChangeWatchedFiles',
        }
        proto.request('client/registerCapability', {
            unregisterations = {
                unregisteration,
            }
        })
    end
end

---@class config.change
---@field key       string
---@field prop?     string
---@field value     any
---@field action    '"add"'|'"set"'|'"prop"'
---@field isGlobal? boolean
---@field uri?      uri

---@param cfg table
---@param changes config.change[]
local function applyConfig(cfg, changes)
    for _, change in ipairs(changes) do
        cfg[change.key] = config.getRaw(change.key)
    end
end

local function tryModifySpecifiedConfig(finalChanges)
    if #finalChanges == 0 then
        return false
    end
    local workspace = require 'workspace'
    local loader    = require 'config.loader'
    if loader.lastLocalType ~= 'json' then
        return false
    end
    applyConfig(loader.lastLocalConfig, finalChanges)
    local path = workspace.getAbsolutePath(CONFIGPATH)
    util.saveFile(path, json.beautify(loader.lastLocalConfig, { indent = '    ' }))
    return true
end

local function tryModifyRC(finalChanges, create)
    if #finalChanges == 0 then
        return false
    end
    local workspace = require 'workspace'
    local loader    = require 'config.loader'
    local path = workspace.getAbsolutePath '.luarc.json'
    if not path then
        return false
    end
    local buf = util.loadFile(path)
    if not buf and not create then
        return false
    end
    local rc = loader.lastRCConfig or {
        ['$schema'] = lang.id == 'zh-cn' and [[https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema-zh-cn.json]] or [[https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json]]
    }
    applyConfig(rc, finalChanges)
    util.saveFile(path, json.beautify(rc, { indent = '    ' }))
    return true
end

local function tryModifyClient(finalChanges)
    if #finalChanges == 0 then
        return false
    end
    if not m.getOption 'changeConfiguration' then
        return false
    end
    proto.notify('$/command', {
        command   = 'lua.config',
        data      = finalChanges,
    })
    return true
end

---@param finalChanges config.change[]
local function tryModifyClientGlobal(finalChanges)
    if #finalChanges == 0 then
        return
    end
    if not m.getOption 'changeConfiguration' then
        return
    end
    local changes = {}
    for i = #finalChanges, 1, -1 do
        local change = finalChanges[i]
        if change.isGlobal then
            changes[#changes+1] = change
            finalChanges[i] = finalChanges[#finalChanges]
            finalChanges[#finalChanges] = nil
        end
    end
    proto.notify('$/command', {
        command   = 'lua.config',
        data      = changes,
    })
end

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
    xpcall(function ()
        tryModifyClientGlobal(finalChanges)
        if tryModifySpecifiedConfig(finalChanges) then
            return
        end
        if tryModifyRC(finalChanges) then
            return
        end
        if tryModifyClient(finalChanges) then
            return
        end
        tryModifyRC(finalChanges, true)
    end, log.error)
end

---@alias textEditor {start: integer, finish: integer, text: string}

---@param uri   uri
---@param edits textEditor[]
function m.editText(uri, edits)
    local files     = require 'files'
    local textEdits = {}
    for i, edit in ipairs(edits) do
        textEdits[i] = converter.textEdit(converter.packRange(uri, edit.start, edit.finish), edit.text)
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
    converter.setOffsetEncoding(m.getOffsetEncoding())
    hookPrint()
end

return m
