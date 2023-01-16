local proto     = require 'proto'
local lang      = require 'language'
local util      = require 'utility'
local workspace = require 'workspace'
local scope     = require 'workspace.scope'
local inspect   = require 'inspect'
local jsonc     = require 'jsonc'

local function errorMessage(msg)
    proto.notify('window/showMessage', {
        type = 3,
        message = msg,
    })
    log.error(msg)
end

---@class config.loader
local m = {}

---@return table?
function m.loadRCConfig(uri, filename)
    local scp  = scope.getScope(uri)
    local path = workspace.getAbsolutePath(uri, filename)
    if not path then
        scp:set('lastRCConfig', nil)
        return nil
    end
    local buf = util.loadFile(path)
    if not buf then
        scp:set('lastRCConfig', nil)
        return nil
    end
    local suc, res = pcall(jsonc.decode_jsonc, buf)
    if not suc then
        errorMessage(lang.script('CONFIG_LOAD_ERROR', res))
        return scp:get('lastRCConfig')
    end
    ---@cast res table
    scp:set('lastRCConfig', res)
    return res
end

---@return table?
function m.loadLocalConfig(uri, filename)
    if not filename then
        return nil
    end
    local scp  = scope.getScope(uri)
    local path = workspace.getAbsolutePath(uri, filename)
    if not path then
        scp:set('lastLocalConfig', nil)
        scp:set('lastLocalType', nil)
        return nil
    end
    local buf = util.loadFile(path)
    if not buf then
        --errorMessage(lang.script('CONFIG_LOAD_FAILED', path))
        scp:set('lastLocalConfig', nil)
        scp:set('lastLocalType', nil)
        return nil
    end
    local firstChar = buf:match '%S'
    if firstChar == '{' then
        local suc, res = pcall(jsonc.decode_jsonc, buf)
        if not suc then
            errorMessage(lang.script('CONFIG_LOAD_ERROR', res))
            return scp:get('lastLocalConfig')
        end
        ---@cast res table
        scp:set('lastLocalConfig', res)
        scp:set('lastLocalType', 'json')
        return res
    else
        local suc, res = pcall(function ()
            return assert(load(buf, '@' .. path, 't'))()
        end)
        if not suc then
            errorMessage(lang.script('CONFIG_LOAD_ERROR', res))
            scp:set('lastLocalConfig', res)
        end
        scp:set('lastLocalConfig', res)
        scp:set('lastLocalType', 'lua')
        return res
    end
end

---@async
---@param uri? uri
---@return table?
function m.loadClientConfig(uri)
    local configs = proto.awaitRequest('workspace/configuration', {
        items = {
            {
                scopeUri = uri,
                section = 'Lua',
            },
            {
                scopeUri = uri,
                section = 'files.associations',
            },
            {
                scopeUri = uri,
                section = 'files.exclude',
            },
            {
                scopeUri = uri,
                section = 'editor.semanticHighlighting.enabled',
            },
            {
                scopeUri = uri,
                section = 'editor.acceptSuggestionOnEnter',
            },
        },
    })
    if not configs or not configs[1] then
        log.warn('No config?', inspect(configs))
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
