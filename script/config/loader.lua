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

function m.loadLocalConfig(filename)
    local path = fs.path(filename)
    if path:is_relative() then
        if workspace.path then
            path = fs.path(workspace.path) / path
        end
    end
    local ext  = path:extension():string():lower()
    local buf  = fsu.loadFile(path)
    if not buf then
        errorMessage(lang.script('无法读取设置文件：{}', path:string()))
        return
    end
    if ext == '.json' then
        local suc, res = pcall(json.decode, buf)
        if not suc then
            errorMessage(lang.script('设置文件加载错误：{}', res))
            return
        end
        return res
    elseif ext == '.lua' then
        local suc, res = pcall(function ()
            return assert(load(buf, '@' .. path:string(), 't'))()
        end)
        if not suc then
            errorMessage(lang.script('设置文件加载错误：{}', res))
            return
        end
        return res
    else
        errorMessage(lang.script('设置文件必须是lua或json格式：{}', path:string()))
        return
    end
end

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
        return
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
