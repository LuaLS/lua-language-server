local nonil      = require 'without-check-nil'
local client     = require 'client'
local platform   = require 'bee.platform'
local completion = require 'provider.completion'
local define     = require 'proto.define'

require 'provider.semantic-tokens'
require 'provider.formatting'
require 'provider.inlay-hint'
require 'provider.code-lens'

local m = {}

m.fillings = {}
m.resolvedMap = {}

local function mergeFillings(provider)
    for _, filling in ipairs(m.fillings) do
        for k, v in pairs(filling) do
            if type(v) == 'table' then
                if not provider[k] then
                    provider[k] = {}
                end
                for kk, vv in pairs(v) do
                    provider[k][kk] = vv
                end
            else
                provider[k] = v
            end
        end
    end
end

local function resolve(t)
    for k, v in pairs(t) do
        if type(v) == 'table' then
            resolve(v)
        end
        if type(v) == 'string' then
            t[k] = v:gsub('%{(.-)%}', function (key)
                return m.resolvedMap[key] or ''
            end)
        end
        if type(v) == 'function' then
            t[k] = v()
        end
    end
end

function m.getProvider()
    local provider = {
        offsetEncoding = client.getOffsetEncoding(),
        -- 文本同步方式
        textDocumentSync = {
            -- 打开关闭文本时通知
            openClose = true,
            -- 文本增量更新
            change = 2,
        },
    }

    nonil.enable()
    if not client.info.capabilities.textDocument.completion.dynamicRegistration
    or not client.info.capabilities.workspace.configuration then
        provider.completionProvider = {
            resolveProvider = true,
            triggerCharacters = completion.allWords(),
        }
    end
    nonil.disable()

    mergeFillings(provider)
    resolve(provider)

    return provider
end

function m.filling(t)
    m.fillings[#m.fillings+1] = t
end

function m.resolve(key, value)
    m.resolvedMap[key] = value
end

return m
