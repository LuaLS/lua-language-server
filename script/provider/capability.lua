local nonil      = require 'without-check-nil'
local client     = require 'client'
local platform   = require 'bee.platform'
local completion = require 'provider.completion'
local define     = require 'proto.define'

require 'provider.semantic-tokens'

local function toArray(map)
    local array = {}
    for k in pairs(map) do
        array[#array+1] = k
    end
    table.sort(array, function (a, b)
        return map[a] < map[b]
    end)
    return array
end

local m = {}

local function testFileEvents(initer)
    initer.fileOperations = {
        didCreate = {
            filters = {
                {
                    pattern = {
                        glob = '**',
                        --matches = 'file',
                        options = platform.OS == 'Windows',
                    }
                }
            }
        },
        didDelete = {
            filters = {
                {
                    pattern = {
                        glob = '**',
                        --matches = 'file',
                        options = platform.OS == 'Windows',
                    }
                }
            }
        },
        didRename = {
            filters = {
                {
                    pattern = {
                        glob = '**',
                        --matches = 'file',
                        options = platform.OS == 'Windows',
                    }
                }
            }
        },
    }
end

function m.getIniter()
    local initer = {
        offsetEncoding = client.getOffsetEncoding(),
        -- 文本同步方式
        textDocumentSync = {
            -- 打开关闭文本时通知
            openClose = true,
            -- 文本增量更新
            change = 2,
        },

        hoverProvider = true,
        definitionProvider = true,
        typeDefinitionProvider = true,
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
                'lua.removeSpace',
                'lua.solve',
                'lua.jsonToLua',
                'lua.setConfig',
                'lua.autoRequire',
            },
        },
        foldingRangeProvider = true,
        documentOnTypeFormattingProvider = {
            firstTriggerCharacter = '\n',
            moreTriggerCharacter  = nil, -- string[]
        },
        semanticTokensProvider = {
            legend = {
                tokenTypes     = toArray(define.TokenTypes),
                tokenModifiers = toArray(define.TokenModifiers),
            },
            range = true,
            full  = false,
        },
        --documentOnTypeFormattingProvider = {
        --    firstTriggerCharacter = '}',
        --},
    }

    --testFileEvents()

    nonil.enable()
    if not client.info.capabilities.textDocument.completion.dynamicRegistration
    or not client.info.capabilities.workspace.configuration then
        initer.completionProvider = {
            resolveProvider = true,
            triggerCharacters = completion.allWords(),
        }
    end
    nonil.disable()

    return initer
end

return m
