local sp     = require 'bee.subprocess'
local nonil  = require 'without-check-nil'
local client = require 'provider.client'

local m = {}

local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@|=- ]]
    local list = {}
    for c in str:gmatch '.' do
        list[#list+1] = c
    end
    return list
end

function m.getIniter()
    local initer = {
        -- 文本同步方式
        textDocumentSync = {
            -- 打开关闭文本时通知
            openClose = true,
            -- 文本增量更新
            change = 2,
        },

        hoverProvider = true,
        definitionProvider = true,
        referencesProvider = true,
        renameProvider = {
            prepareProvider = true,
        },
        documentSymbolProvider = true,
        workspaceSymbolProvider = true,
        documentHighlightProvider = true,
        codeActionProvider = {
            codeActionKinds = {
                '',
                'quickfix',
                'refactor.rewrite',
                'refactor.extract',
            },
            resolveProvider = false,
        },
        signatureHelpProvider = {
            triggerCharacters = { '(', ',' },
        },
        executeCommandProvider = {
            commands = {
                'lua.removeSpace:' .. sp:get_id(),
                'lua.solve:' .. sp:get_id(),
            },
        },
        foldingRangeProvider = true,
        --documentOnTypeFormattingProvider = {
        --    firstTriggerCharacter = '}',
        --},
    }

    nonil.enable()
    if not client.info.capabilities.textDocument.completion.dynamicRegistration then
        initer.completionProvider = {
            triggerCharacters = allWords(),
        }
    end
    nonil.disable()

    return initer
end

return m
