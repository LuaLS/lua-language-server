local fs        = require 'bee.filesystem'
local nonil     = require 'without-check-nil'
local util      = require 'utility'
local lang      = require 'language'
local proto     = require 'proto'
local define    = require 'proto.define'
local config    = require 'config'
local converter = require 'proto.converter'
local await     = require 'await'
local scope     = require 'workspace.scope'
local inspect   = require 'inspect'
local jsone     = require 'json-edit'
local jsonc     = require 'jsonc'

local m = {}
m._eventList = {}

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
            return current
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
    log.info('ShowMessage', type, message)
end

---@param type message.type
---@param message string
---@param titles  string[]
---@param callback fun(action?: string, index?: integer)
function m.requestMessage(type, message, titles, callback)
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
    log.info('requestMessage', type, message)
    proto.request('window/showMessageRequest', {
        type    = define.MessageType[type] or 3,
        message = message,
        actions = actions,
    }, function (item)
        log.info('responseMessage', message, item and item.title or nil)
        if item then
            callback(item.title, map[item.title])
        else
            callback(nil, nil)
        end
    end)
end

---@param type message.type
---@param message string
---@param titles  string[]
---@return string action
---@return integer index
---@async
function m.awaitRequestMessage(type, message, titles)
    return await.wait(function (waker)
        m.requestMessage(type, message, titles, waker)
    end)
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
---@field global?   boolean
---@field uri?      uri

---@param uri uri?
---@param changes config.change[]
---@return config.change[]
local function getValidChanges(uri, changes)
    local newChanges = {}
    if not uri then
        return changes
    end
    local scp = scope.getScope(uri)
    for _, change in ipairs(changes) do
        if scp:isChildUri(change.uri)
        or scp:isLinkedUri(change.uri) then
            newChanges[#newChanges+1] = change
        end
    end
    return newChanges
end

---@class json.patch
---@field op 'add' | 'remove' | 'replace'
---@field path string
---@field value any

---@class json.patchInfo
---@field key string
---@field value any

---@param cfg table
---@param rawKey string
---@return json.patchInfo
local function searchPatchInfo(cfg, rawKey)

    ---@param key string
    ---@param parentKey string
    ---@param parentValue table
    ---@return json.patchInfo?
    local function searchOnce(key, parentKey, parentValue)
        if parentValue == nil then
            return nil
        end
        if type(parentValue) ~= 'table' then
            return {
                key   = parentKey,
                value = parentValue,
            }
        end
        if parentValue[key] then
            return {
                key   = parentKey .. '/' .. key,
                value = parentValue[key],
            }
        end
        for pos in key:gmatch '()%.' do
            local k = key:sub(1, pos - 1)
            local v = parentValue[k]
            local info = searchOnce(key:sub(pos + 1), parentKey .. '/' .. k, v)
            if info then
                return info
            end
        end
        return nil
    end

    return searchOnce(rawKey, '', cfg)
        or searchOnce(rawKey:gsub('^Lua%.', ''), '', cfg)
        or {
            key   = '/' .. rawKey:gsub('^Lua%.', ''),
            value = nil,
        }
end

---@param uri? uri
---@param cfg table
---@param change config.change
---@return json.patch?
local function makeConfigPatch(uri, cfg, change)
    local info  = searchPatchInfo(cfg, change.key)
    if change.action == 'add' then
        if type(info.value) == 'table' and #info.value > 0 then
            return {
                op    = 'add',
                path  = info.key .. '/-',
                value = change.value,
            }
        else
            return makeConfigPatch(uri, cfg, {
                action = 'set',
                key    = change.key,
                value  = config.get(uri, change.key),
            })
        end
    elseif change.action == 'set' then
        if info.value ~= nil then
            return {
                op    = 'replace',
                path  = info.key,
                value = change.value,
            }
        else
            return {
                op    = 'add',
                path  = info.key,
                value = change.value,
            }
        end
    elseif change.action == 'prop' then
        if type(info.value) == 'table' and next(info.value) then
            return {
                op    = 'add',
                path  = info.key .. '/' .. change.prop,
                value = change.value,
            }
        else
            return makeConfigPatch(uri, cfg, {
                action = 'set',
                key    = change.key,
                value  = config.get(uri, change.key),
            })
        end
    end
    return nil
end

---@param uri? uri
---@param path string
---@param changes config.change[]
---@return string?
local function editConfigJson(uri, path, changes)
    local text = util.loadFile(path)
    if not text then
        m.showMessage('Error', lang.script('CONFIG_LOAD_FAILED', path))
        return nil
    end
    local suc, res = pcall(jsonc.decode_jsonc, text)
    if not suc then
        m.showMessage('Error', lang.script('CONFIG_MODIFY_FAIL_SYNTAX_ERROR', path .. res:match 'ERROR(.+)$'))
        return nil
    end
    if type(res) ~= 'table' then
        res = {}
    end
    ---@cast res table
    for _, change in ipairs(changes) do
        local patch = makeConfigPatch(uri, res, change)
        if patch then
            text = jsone.edit(text, patch, { indent = '    ' })
        end
    end
    return text
end

---@param changes config.change[]
---@param applied config.change[]
local function removeAppliedChanges(changes, applied)
    local appliedMap = {}
    for _, change in ipairs(applied) do
        appliedMap[change] = true
    end
    for i = #changes, 1, -1 do
        if appliedMap[changes[i]] then
            table.remove(changes, i)
        end
    end
end

local function tryModifySpecifiedConfig(uri, finalChanges)
    if #finalChanges == 0 then
        return false
    end
    log.info('tryModifySpecifiedConfig', uri, inspect(finalChanges))
    local workspace = require 'workspace'
    local scp = scope.getScope(uri)
    if scp:get('lastLocalType') ~= 'json' then
        log.info('lastLocalType ~= json')
        return false
    end
    local validChanges = getValidChanges(uri, finalChanges)
    if #validChanges == 0 then
        log.info('No valid changes')
        return false
    end
    local path = workspace.getAbsolutePath(uri, CONFIGPATH)
    if not path then
        log.info('Can not get absolute path')
        return false
    end
    local newJson = editConfigJson(uri, path, validChanges)
    if not newJson then
        log.info('Can not edit config json')
        return false
    end
    util.saveFile(path, newJson)
    log.info('Apply changes to config file', inspect(validChanges))
    removeAppliedChanges(finalChanges, validChanges)
    return true
end

local function tryModifyRC(uri, finalChanges, create)
    if #finalChanges == 0 then
        return false
    end
    log.info('tryModifyRC', uri, inspect(finalChanges))
    local workspace = require 'workspace'
    local path = workspace.getAbsolutePath(uri, '.luarc.jsonc')
    if not path then
        log.info('Can not get absolute path of .luarc.jsonc')
        return false
    end
    path = fs.exists(fs.path(path)) and path or workspace.getAbsolutePath(uri, '.luarc.json')
    if not path then
        log.info('Can not get absolute path of .luarc.json')
        return false
    end
    local buf = util.loadFile(path)
    if not buf and not create then
        log.info('Can not load .luarc.json and not create')
        return false
    end
    local validChanges = getValidChanges(uri, finalChanges)
    if #validChanges == 0 then
        log.info('No valid changes')
        return false
    end
    if not buf then
        util.saveFile(path, '')
    end
    local newJson = editConfigJson(uri, path, validChanges)
    if not newJson then
        log.info('Can not edit config json')
        return false
    end
    util.saveFile(path, newJson)
    log.info('Apply changes to .luarc.json', inspect(validChanges))
    removeAppliedChanges(finalChanges, validChanges)
    return true
end

local function tryModifyClient(uri, finalChanges)
    if #finalChanges == 0 then
        return false
    end
    log.info('tryModifyClient', uri, inspect(finalChanges))
    if not m.getOption 'changeConfiguration' then
        return false
    end
    local scp = scope.getScope(uri)
    local scpChanges = {}
    for _, change in ipairs(finalChanges) do
        if  change.uri
        and (scp:isChildUri(change.uri) or scp:isLinkedUri(change.uri)) then
            scpChanges[#scpChanges+1] = change
        end
    end
    if #scpChanges == 0 then
        log.info('No changes in client scope')
        return false
    end
    proto.notify('$/command', {
        command   = 'lua.config',
        data      = scpChanges,
    })
    log.info('Apply client changes', uri, inspect(scpChanges))
    removeAppliedChanges(finalChanges, scpChanges)
    return true
end

---@param finalChanges config.change[]
local function tryModifyClientGlobal(finalChanges)
    if #finalChanges == 0 then
        return
    end
    log.info('tryModifyClientGlobal', inspect(finalChanges))
    if not m.getOption 'changeConfiguration' then
        log.info('Client dose not support modifying config')
        return
    end
    local changes = {}
    for _, change in ipairs(finalChanges) do
        if change.global then
            changes[#changes+1] = change
        end
    end
    if #changes == 0 then
        log.info('No global changes')
        return
    end
    proto.notify('$/command', {
        command   = 'lua.config',
        data      = changes,
    })
    log.info('Apply client global changes', inspect(changes))
    removeAppliedChanges(finalChanges, changes)
end

---@param changes config.change[]
---@return string
local function buildMaunuallyMessage(changes)
    local message = {}
    for _, change in ipairs(changes) do
        if change.action == 'add' then
            message[#message+1] = '* ' .. lang.script('WINDOW_MANUAL_CONFIG_ADD', change.key, change.value)
        elseif change.action == 'set' then
            message[#message+1] = '* ' .. lang.script('WINDOW_MANUAL_CONFIG_SET', change.key, change.value)
        elseif change.action == 'prop' then
            message[#message+1] = '* ' .. lang.script('WINDOW_MANUAL_CONFIG_PROP', change.key, change.prop, change.value)
        end
    end
    return table.concat(message, '\n')
end

---@param changes config.change[]
---@param onlyMemory? boolean
function m.setConfig(changes, onlyMemory)
    local finalChanges = {}
    for _, change in ipairs(changes) do
        if     change.action == 'add' then
            local suc = config.add(change.uri, change.key, change.value)
            if suc then
                finalChanges[#finalChanges+1] = change
            end
        elseif change.action == 'set' then
            local suc = config.set(change.uri, change.key, change.value)
            if suc then
                finalChanges[#finalChanges+1] = change
            end
        elseif change.action == 'prop' then
            local suc = config.prop(change.uri, change.key, change.prop, change.value)
            if suc then
                finalChanges[#finalChanges+1] = change
            end
        end
    end
    if onlyMemory then
        return
    end
    if #finalChanges == 0 then
        return
    end
    log.info('Modify config', inspect(finalChanges))
    xpcall(function ()
        local ws = require 'workspace'
        tryModifyClientGlobal(finalChanges)
        if #ws.folders == 0 then
            tryModifySpecifiedConfig(nil, finalChanges)
            tryModifyClient(nil, finalChanges)
            if #finalChanges > 0 then
                local manuallyModifyConfig = buildMaunuallyMessage(finalChanges)
                m.showMessage('Warning', lang.script('CONFIG_MODIFY_FAIL_NO_WORKSPACE', manuallyModifyConfig))
            end
        else
            for _, scp in ipairs(ws.folders) do
                tryModifySpecifiedConfig(scp.uri, finalChanges)
                tryModifyRC(scp.uri, finalChanges, false)
                tryModifyClient(scp.uri, finalChanges)
                tryModifyRC(scp.uri, finalChanges, true)
            end
            if #finalChanges > 0 then
                m.showMessage('Warning', lang.script('CONFIG_MODIFY_FAIL', buildMaunuallyMessage(finalChanges)))
                log.warn('Config modify fail', inspect(finalChanges))
            end
        end
    end, log.error)
end

---@alias textEditor {start: integer, finish: integer, text: string}

---@param uri   uri
---@param edits textEditor[]
function m.editText(uri, edits)
    local files = require 'files'
    local state = files.getState(uri)
    if not state then
        return
    end
    local textEdits = {}
    for i, edit in ipairs(edits) do
        textEdits[i] = converter.textEdit(converter.packRange(state, edit.start, edit.finish), edit.text)
    end
    local params = {
        edit = {
            changes = {
                [uri] = textEdits,
            }
        }
    }
    proto.request('workspace/applyEdit', params)
    log.info('workspace/applyEdit', inspect(params))
end

---@alias textMultiEditor {uri: uri, start: integer, finish: integer, text: string}

---@param editors textMultiEditor[]
function m.editMultiText(editors)
    local files = require 'files'
    local changes = {}
    for _, editor in ipairs(editors) do
        local uri = editor.uri
        local state = files.getState(uri)
        if state then
            if not changes[uri] then
                changes[uri] = {}
            end
            local edit = converter.textEdit(converter.packRange(state, editor.start, editor.finish), editor.text)
            table.insert(changes[uri], edit)
        end
    end
    local params = {
        edit = {
            changes = changes,
        }
    }
    proto.request('workspace/applyEdit', params)
    log.info('workspace/applyEdit', inspect(params))
end

---@param callback async fun(ev: string)
function m.event(callback)
    m._eventList[#m._eventList+1] = callback
end

function m._callEvent(ev)
    for _, callback in ipairs(m._eventList) do
        await.call(function ()
            callback(ev)
        end)
    end
end

function m.setReady()
    m._ready = true
    m._callEvent('ready')
end

function m.isReady()
    return m._ready == true
end

local function hookPrint()
    if TEST or CLI then
        return
    end
    print = function (...)
        m.logMessage('Log', ...)
    end
end

function m.init(t)
    log.info('Client init', inspect(t))
    m.info = t
    nonil.enable()
    m.client(t.clientInfo.name)
    nonil.disable()
    lang(LOCALE or t.locale)
    converter.setOffsetEncoding(m.getOffsetEncoding())
    hookPrint()
    m._callEvent('init')
end

return m
