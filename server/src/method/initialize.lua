local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@| ]]
    local list = {}
    for c in str:gmatch '.' do
        list[#list+1] = c
    end
    return list
end

return function (lsp)
    lsp._inited = true
    return {
        capabilities = {
            hoverProvider = true,
            definitionProvider = true,
            referencesProvider = true,
            renameProvider = true,
            documentSymbolProvider = true,
            documentHighlightProvider = true,
            codeActionProvider = true,
            foldingRangeProvider = true,
            signatureHelpProvider = {
                triggerCharacters = { '(', ',' },
            },
            -- 文本同步方式
            textDocumentSync = {
                -- 打开关闭文本时通知
                openClose = true,
                -- 文本改变时完全通知 TODO 支持差量更新（2）
                change = 1,
            },
            workspace = {
                workspaceFolders = {
                    supported = true,
                    changeNotifications = true,
                }
            },
            documentOnTypeFormattingProvider = {
                firstTriggerCharacter = '}',
            },
            executeCommandProvider = {
                commands = {
                    'config',
                    'removeSpace',
                    'solve',
                },
            },
        }
    }
end
