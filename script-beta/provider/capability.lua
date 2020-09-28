local sp = require 'bee.subprocess'

local m = {}

m.initer = {
    -- 文本同步方式
    textDocumentSync = {
        -- 打开关闭文本时通知
        openClose = true,
        -- 文本改变时完全通知 TODO 支持差量更新（2）
        change = 1,
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
    codeActionProvider = true,
    signatureHelpProvider = {
        triggerCharacters = { '(', ',' },
    },
    executeCommandProvider = {
        commands = {
            'lua.removeSpace:' .. sp:get_id(),
            'lua.solve:' .. sp:get_id(),
        },
    },
    --documentOnTypeFormattingProvider = {
    --    firstTriggerCharacter = '}',
    --},
}

return m
