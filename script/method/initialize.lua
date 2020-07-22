local workspace = require 'workspace'
local nonil = require 'without-check-nil'
local client = require 'client'
local json = require 'json'

local function allWords()
    local str = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:('"[,#*@| ]]
    local list = {}
    for c in str:gmatch '.' do
        list[#list+1] = c
    end
    return list
end

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    lsp._inited = true
    lsp.client = params
    client.init(params)
    log.info(table.dump(params))

    if params.workspaceFolders and params.workspaceFolders ~= json.null then
        for _, folder in ipairs(params.workspaceFolders) do
            lsp:addWorkspace(folder.name, folder.uri)
        end
    elseif params.rootUri and params.rootUri ~= json.null then
        lsp:addWorkspace('root', params.rootUri)
    end

    local server = {
        capabilities = {
            hoverProvider = true,
            definitionProvider = true,
            referencesProvider = true,
            renameProvider = true,
            documentSymbolProvider = true,
            documentHighlightProvider = true,
            codeActionProvider = true,
            foldingRangeProvider = true,
            workspaceSymbolProvider = true,
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
                },
            },
            documentOnTypeFormattingProvider = {
                firstTriggerCharacter = '}',
            },
            executeCommandProvider = {
                commands = {
                    'lua.removeSpace',
                    'lua.solve',
                },
            },
        }
    }

    nonil.enable()
    if not params.capabilities.textDocument.completion.dynamicRegistration then
        server.capabilities.completionProvider = {
            triggerCharacters = allWords(),
        }
    end
    nonil.disable()

    return server
end
