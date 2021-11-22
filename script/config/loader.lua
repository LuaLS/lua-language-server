local fs        = require 'bee.filesystem'
local fsu       = require 'fs-utility'
local json      = require 'json'
local proto     = require 'proto'
local lang      = require 'language'
local util      = require 'utility'
local workspace = require 'workspace'

local function errorMessage(msg)
    proto.notify('window/showMessage', {
        type = 3,
        message = msg,
    })
    log.error(msg)
end

local m = {}

function m.loadRCConfig(filename)
    local path = workspace.getAbsolutePath(filename)
    if not path then
        m.lastRCConfig = nil
        return nil
    end
    local buf = util.loadFile(path)
    if not buf then
        m.lastRCConfig = nil
        return nil
    end
    local suc, res = pcall(json.decode, buf)
    if not suc then
        errorMessage(lang.script('CONFIG_LOAD_ERROR', res))
        return m.lastRCConfig
    end
    m.lastRCConfig = res
    return res
end

function m.loadLocalConfig(filename)
    local path = workspace.getAbsolutePath(filename)
    if not path then
        m.lastLocalConfig = nil
        m.lastLocalType = nil
        return nil
    end
    local buf  = util.loadFile(path)
    if not buf then
        errorMessage(lang.script('CONFIG_LOAD_FAILED', path))
        m.lastLocalConfig = nil
        m.lastLocalType = nil
        return nil
    end
    local firstChar = buf:match '%S'
    if firstChar == '{' then
        local suc, res = pcall(json.decode, buf)
        if not suc then
            errorMessage(lang.script('CONFIG_LOAD_ERROR', res))
            return m.lastLocalConfig
        end
        m.lastLocalConfig = res
        m.lastLocalType = 'json'
        return res
    else
        local suc, res = pcall(function ()
            return assert(load(buf, '@' .. path, 't'))()
        end)
        if not suc then
            errorMessage(lang.script('CONFIG_LOAD_ERROR', res))
            return m.lastLocalConfig
        end
        m.lastLocalConfig = res
        m.lastLocalType = 'lua'
        return res
    end
end

---@async
function m.loadClientConfig()
    local configs = proto.awaitRequest('workspace/configuration', {
        items = {
            {
                scopeUri = workspace.uri,
                section = 'Lua',
            },
            {
                scopeUri = workspace.uri,
                section = 'files.associations',
            },
            {
                scopeUri = workspace.uri,
                section = 'files.exclude',
            },
            {
                scopeUri = workspace.uri,
                section = 'editor.semanticHighlighting.enabled',
            },
            {
                scopeUri = workspace.uri,
                section = 'editor.acceptSuggestionOnEnter',
            },
        },
    })
    if not configs or not configs[1] then
        log.warn('No config?', util.dump(configs))
        return nil
    end

    local newConfig = {
        ['Lua']                                 = configs[1],
        ['files.associations']                  = configs[2],
        ['files.exclude']                       = configs[3],
        ['editor.semanticHighlighting.enabled'] = configs[4],
        ['editor.acceptSuggestionOnEnter']      = configs[5],
    }

    return newConfig
end

return m
