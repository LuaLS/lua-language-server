local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,# ]]
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
            -- 支持“悬浮”
            hoverProvider = true,
            -- 支持“转到定义”
            definitionProvider = true,
            -- 支持“转到实现”
            implementationProvider = true,
            -- 支持“查找引用”
            referencesProvider = true,
            -- 支持“重命名”
            renameProvider = true,
            -- 支持“大纲”
            documentSymbolProvider = true,
            -- 支持“签名帮助”
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
            -- 自动完成
            completionProvider = {
                resolveProvider = false,
                triggerCharacters = allWords(),
            },
            -- 工作目录
            workspace = {
                workspaceFolders = {
                    supported = true,
                    changeNotifications = true,
                }
            },
        }
    }
end
