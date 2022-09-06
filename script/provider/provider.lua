local util       = require 'utility'
local cap        = require 'provider.capability'
local await      = require 'await'
local files      = require 'files'
local proto      = require 'proto.proto'
local define     = require 'proto.define'
local workspace  = require 'workspace'
local config     = require 'config'
local client     = require 'client'
local pub        = require 'pub'
local lang       = require 'language'
local progress   = require 'progress'
local tm         = require 'text-merger'
local cfgLoader  = require 'config.loader'
local converter  = require 'proto.converter'
local filewatch  = require 'filewatch'
local json       = require 'json'
local scope      = require 'workspace.scope'
local furi       = require 'file-uri'
local inspect    = require 'inspect'
local guide      = require 'parser.guide'
local fs        = require 'bee.filesystem'

require 'library'

---@async
local function updateConfig(uri)
    config.addNullSymbol(json.null)
    local specified = cfgLoader.loadLocalConfig(uri, CONFIGPATH)
    if specified then
        log.info('Load config from specified', CONFIGPATH)
        log.info(inspect(specified))
        -- watch directory
        filewatch.watch(workspace.getAbsolutePath(uri, CONFIGPATH):gsub('[^/\\]+$', ''))
        config.update(scope.override, specified)
    end

    for _, folder in ipairs(scope.folders) do
        local clientConfig = cfgLoader.loadClientConfig(folder.uri)
        if clientConfig then
            log.info('Load config from client', folder.uri)
            log.info(inspect(clientConfig))
        end

        local rc = cfgLoader.loadRCConfig(folder.uri, '.luarc.json')
                or cfgLoader.loadRCConfig(folder.uri, '.luarc.jsonc')
        if rc then
            log.info('Load config from .luarc.json/.luarc.jsonc', folder.uri)
            log.info(inspect(rc))
        end

        config.update(folder, clientConfig, rc)
    end

    local global = cfgLoader.loadClientConfig()
    log.info('Load config from client', 'fallback')
    log.info(inspect(global))
    config.update(scope.fallback, global)
end

---@class provider
local m = {}

m.attributes = {}

function m.register(method)
    return function (attrs)
        m.attributes[method] = attrs
        if attrs.preview and not PREVIEW then
            return
        end
        if attrs.capability then
            cap.filling(attrs.capability)
        end
        proto.on(method, attrs[1])
    end
end

filewatch.event(function (ev, path) ---@async
    if (CONFIGPATH and util.stringEndWith(path, CONFIGPATH)) then
        for _, scp in ipairs(workspace.folders) do
            local configPath = workspace.getAbsolutePath(scp.uri, CONFIGPATH)
            if path == configPath then
                updateConfig(scp.uri)
            end
        end
    end
    if util.stringEndWith(path, '.luarc.json') then
        for _, scp in ipairs(workspace.folders) do
            local rcPath     = workspace.getAbsolutePath(scp.uri, '.luarc.json')
            if path == rcPath then
                updateConfig(scp.uri)
            end
        end
    end
    if util.stringEndWith(path, '.luarc.jsonc') then
        for _, scp in ipairs(workspace.folders) do
            local rcPath     = workspace.getAbsolutePath(scp.uri, '.luarc.jsonc')
            if path == rcPath then
                updateConfig(scp.uri)
            end
        end
    end
end)

m.register 'initialize' {
    function(params)
        client.init(params)

        if params.rootUri then
            workspace.initRoot(params.rootUri)
        end

        if params.workspaceFolders then
            for _, folder in ipairs(params.workspaceFolders) do
                workspace.create(folder.uri)
            end
        elseif params.rootUri then
            workspace.create(params.rootUri)
        end

        return {
            capabilities = cap.getProvider(),
            serverInfo   = {
                name    = 'sumneko.lua',
            },
        }
    end
}

m.register 'initialized'{
    ---@async
    function (params)
        files.init()
        local _ <close> = progress.create(workspace.getFirstScope().uri, lang.script.WINDOW_INITIALIZING, 0.5)
        updateConfig()
        local registrations = {}

        if client.getAbility 'workspace.didChangeConfiguration.dynamicRegistration' then
            -- 监视配置变化
            registrations[#registrations+1] = {
                id = 'workspace/didChangeConfiguration',
                method = 'workspace/didChangeConfiguration',
            }
        end

        if #registrations ~= 0 then
            proto.awaitRequest('client/registerCapability', {
                registrations = registrations
            })
        end
        client.setReady()
        workspace.init()
        return true
    end
}

m.register 'exit' {
    function ()
        log.info('Server exited.')
        os.exit(0, true)
    end
}

m.register 'shutdown' {
    function ()
        log.info('Server shutdown.')
        return true
    end
}

m.register 'workspace/didChangeConfiguration' {
    function () ---@async
        if CONFIGPATH then
            return
        end
        updateConfig()
    end
}

m.register 'workspace/didCreateFiles' {
    ---@async
    function (params)
        log.debug('workspace/didCreateFiles', inspect(params))
        for _, file in ipairs(params.files) do
            if workspace.isValidLuaUri(file.uri) then
                files.setText(file.uri, util.loadFile(furi.decode(file.uri)), false)
            end
        end
    end
}

m.register 'workspace/didDeleteFiles' {
    function (params)
        log.debug('workspace/didDeleteFiles', inspect(params))
        for _, file in ipairs(params.files) do
            files.remove(file.uri)
            local childs = files.getChildFiles(file.uri)
            for _, uri in ipairs(childs) do
                log.debug('workspace/didDeleteFiles#child', uri)
                files.remove(uri)
            end
        end
    end
}

m.register 'workspace/didRenameFiles' {
    ---@async
    function (params)
        log.debug('workspace/didRenameFiles', inspect(params))
        for _, file in ipairs(params.files) do
            local text = files.getOriginText(file.oldUri)
            if text then
                files.remove(file.oldUri)
                if workspace.isValidLuaUri(file.newUri) then
                    files.setText(file.newUri, text, false)
                end
            end
            local childs = files.getChildFiles(file.oldUri)
            for _, uri in ipairs(childs) do
                local ctext = files.getOriginText(uri)
                if ctext then
                    local ouri = uri
                    local tail = ouri:sub(#file.oldUri)
                    local nuri = file.newUri .. tail
                    log.debug('workspace/didRenameFiles#child', ouri, nuri)
                    files.remove(uri)
                    if workspace.isValidLuaUri(nuri) then
                        files.setText(nuri, text, false)
                    end
                end
            end
        end
    end
}

m.register 'workspace/didChangeWorkspaceFolders' {
    capability = {
        workspace = {
            workspaceFolders = {
                supported = true,
                changeNotifications = true,
            },
        },
    },
    ---@async
    function (params)
        log.debug('workspace/didChangeWorkspaceFolders', inspect(params))
        for _, folder in ipairs(params.event.added) do
            workspace.create(folder.uri)
            updateConfig()
            workspace.reload(scope.getScope(folder.uri))
        end
        for _, folder in ipairs(params.event.removed) do
            workspace.remove(folder.uri)
        end
    end
}

m.register 'textDocument/didOpen' {
    function (params)
        local doc      = params.textDocument
        local scheme   = furi.split(doc.uri)
        local supports = config.get(doc.uri, 'Lua.workspace.supportScheme')
        if not util.arrayHas(supports, scheme) then
            return
        end
        local uri    = files.getRealUri(doc.uri)
        log.debug('didOpen', uri)
        local text  = doc.text
        files.setText(uri, text, true, function (file)
            file.version = doc.version
        end)
        files.open(uri)
    end
}

m.register 'textDocument/didClose' {
    function (params)
        local doc   = params.textDocument
        local uri   = files.getRealUri(doc.uri)
        log.debug('didClose', uri)
        files.close(uri)
        if not files.isLua(uri) then
            files.remove(uri)
        end
    end
}

m.register 'textDocument/didChange' {
    ---@async
    function (params)
        local doc      = params.textDocument
        local scheme   = furi.split(doc.uri)
        local supports = config.get(doc.uri, 'Lua.workspace.supportScheme')
        if not util.arrayHas(supports, scheme) then
            return
        end
        local changes = params.contentChanges
        local uri     = files.getRealUri(doc.uri)
        local text = files.getOriginText(uri)
        if not text then
            files.setText(uri, pub.awaitTask('loadFile', furi.decode(uri)), false)
            return
        end
        local rows = files.getCachedRows(uri)
        text, rows = tm(text, rows, changes)
        files.setText(uri, text, true, function (file)
            file.version = doc.version
        end)
        files.setCachedRows(uri, rows)
    end
}

m.register 'textDocument/hover' {
    capability = {
        hoverProvider = true,
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local doc    = params.textDocument
        local uri    = files.getRealUri(doc.uri)
        if not config.get(uri, 'Lua.hover.enable') then
            return
        end
        if not workspace.isReady(uri) then
            local count, max = workspace.getLoadingProcess(uri)
            return {
                contents = {
                    value = lang.script('HOVER_WS_LOADING', count, max),
                    kind  = 'markdown',
                }
            }
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_HOVER, 0.5)
        local core = require 'core.hover'
        if not files.exists(uri) then
            return nil
        end
        local pos = converter.unpackPosition(uri, params.position)
        local hover, source = core.byUri(uri, pos)
        if not hover or not source then
            return nil
        end
        return {
            contents = {
                value = tostring(hover),
                kind  = 'markdown',
            },
            range = converter.packRange(uri, source.start, source.finish),
        }
    end
}

m.register 'textDocument/definition' {
    capability = {
        definitionProvider = true,
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri    = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_DEFINITION, 0.5)
        local core   = require 'core.definition'
        local pos = converter.unpackPosition(uri, params.position)
        local result = core(uri, pos)
        if not result then
            return nil
        end
        local response = {}
        for i, info in ipairs(result) do
            local targetUri = info.uri
            if targetUri then
                if client.getAbility 'textDocument.definition.linkSupport' then
                    response[i] = converter.locationLink(targetUri
                        , converter.packRange(targetUri, info.target.start, info.target.finish)
                        , converter.packRange(targetUri, info.target.start, info.target.finish)
                        , converter.packRange(uri,       info.source.start, info.source.finish)
                    )
                else
                    response[i] = converter.location(targetUri
                        , converter.packRange(targetUri, info.target.start, info.target.finish)
                    )
                end
            end
        end
        return response
    end
}

m.register 'textDocument/typeDefinition' {
    capability = {
        typeDefinitionProvider = true,
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri    = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_TYPE_DEFINITION, 0.5)
        local core   = require 'core.type-definition'
        local pos = converter.unpackPosition(uri, params.position)
        local result = core(uri, pos)
        if not result then
            return nil
        end
        local response = {}
        for i, info in ipairs(result) do
            local targetUri = info.uri
            if targetUri then
                if client.getAbility 'textDocument.typeDefinition.linkSupport' then
                    response[i] = converter.locationLink(targetUri
                        , converter.packRange(targetUri, info.target.start, info.target.finish)
                        , converter.packRange(targetUri, info.target.start, info.target.finish)
                        , converter.packRange(uri,       info.source.start, info.source.finish)
                    )
                else
                    response[i] = converter.location(targetUri
                        , converter.packRange(targetUri, info.target.start, info.target.finish)
                    )
                end
            end
        end
        return response
    end
}

m.register 'textDocument/references' {
    capability = {
        referencesProvider = true,
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri    = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_REFERENCE, 0.5)
        local core   = require 'core.reference'
        local pos    = converter.unpackPosition(uri, params.position)
        local result = core(uri, pos)
        if not result then
            return nil
        end
        local response = {}
        for i, info in ipairs(result) do
            local targetUri = info.uri
            response[i] = converter.location(targetUri
                , converter.packRange(targetUri, info.target.start, info.target.finish)
            )
        end
        return response
    end
}

m.register 'textDocument/documentHighlight' {
    capability = {
        documentHighlightProvider = true,
    },
    ---@async
    function (params)
        local core = require 'core.highlight'
        local uri  = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local pos    = converter.unpackPosition(uri, params.position)
        local result = core(uri, pos)
        if not result then
            return nil
        end
        local response = {}
        for _, info in ipairs(result) do
            response[#response+1] = {
                range = converter.packRange(uri, info.start, info.finish),
                kind  = info.kind,
            }
        end
        return response
    end
}

m.register 'textDocument/rename' {
    capability = {
        renameProvider = {
            prepareProvider = true,
        },
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri  = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_RENAME, 0.5)
        local core = require 'core.rename'
        local pos    = converter.unpackPosition(uri, params.position)
        local result = core.rename(uri, pos, params.newName)
        if not result then
            return nil
        end
        local workspaceEdit = {
            changes = {},
        }
        for _, info in ipairs(result) do
            local ruri   = info.uri
            if not workspaceEdit.changes[ruri] then
                workspaceEdit.changes[ruri] = {}
            end
            local textEdit = converter.textEdit(converter.packRange(ruri, info.start, info.finish), info.text)
            workspaceEdit.changes[ruri][#workspaceEdit.changes[ruri]+1] = textEdit
        end
        return workspaceEdit
    end
}

m.register 'textDocument/prepareRename' {
    abortByFileUpdate = true,
    function (params)
        local core = require 'core.rename'
        local uri  = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
        local pos    = converter.unpackPosition(uri, params.position)
        local result = core.prepareRename(uri, pos)
        if not result then
            return nil
        end
        return {
            range       = converter.packRange(uri, result.start, result.finish),
            placeholder = result.text,
        }
    end
}

m.register 'textDocument/completion' {
    ---@async
    function (params)
        local uri  = files.getRealUri(params.textDocument.uri)
        if not workspace.isReady(uri) then
            local count, max = workspace.getLoadingProcess(uri)
            return {
                {
                    label = lang.script('HOVER_WS_LOADING', count, max),
                    textEdit    = {
                        range   = {
                            start   = params.position,
                            ['end'] = params.position,
                        },
                        newText = '',
                    },
                }
            }
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_COMPLETION, 0.5)
        --log.info(util.dump(params))
        local core  = require 'core.completion'
        --log.debug('textDocument/completion')
        --log.debug('completion:', params.context and params.context.triggerKind, params.context and params.context.triggerCharacter)
        if not files.exists(uri) then
            return nil
        end
        local triggerCharacter = params.context and params.context.triggerCharacter
        if config.get(uri, 'editor.acceptSuggestionOnEnter') ~= 'off' then
            if triggerCharacter == '\n'
            or triggerCharacter == '{'
            or triggerCharacter == ',' then
                return
            end
        end
        --await.setPriority(1000)
        local clock  = os.clock()
        local pos    = converter.unpackPosition(uri, params.position)
        local result = core.completion(uri, pos, triggerCharacter)
        local passed = os.clock() - clock
        if passed > 0.1 then
            log.warn(('Completion takes %.3f sec.'):format(passed))
        end
        if not result then
            return nil
        end
        tracy.ZoneBeginN 'completion make'
        local _ <close> = tracy.ZoneEnd
        local easy = false
        local items = {}
        for i, res in ipairs(result) do
            local item = {
                label            = res.label,
                kind             = res.kind,
                detail           = res.detail,
                deprecated       = res.deprecated,
                sortText         = res.sortText or ('%04d'):format(i),
                filterText       = res.filterText,
                insertText       = res.insertText,
                insertTextFormat = 2,
                commitCharacters = res.commitCharacters,
                command          = res.command,
                textEdit         = res.textEdit and {
                    range   = converter.packRange(
                        uri,
                        res.textEdit.start,
                        res.textEdit.finish
                    ),
                    newText = res.textEdit.newText,
                },
                additionalTextEdits = res.additionalTextEdits and (function ()
                    local t = {}
                    for j, edit in ipairs(res.additionalTextEdits) do
                        t[j] = {
                            range   = converter.packRange(
                                uri,
                                edit.start,
                                edit.finish
                            ),
                            newText = edit.newText,
                        }
                    end
                    return t
                end)(),
                documentation    = res.description and {
                    value = tostring(res.description),
                    kind  = 'markdown',
                },
            }
            if res.id then
                if easy and os.clock() - clock < 0.05 then
                    local resolved = core.resolve(res.id)
                    if resolved then
                        item.detail = resolved.detail
                        item.documentation = resolved.description and {
                            value = tostring(resolved.description),
                            kind  = 'markdown',
                        }
                    end
                else
                    easy = false
                    item.data = {
                        uri     = uri,
                        id      = res.id,
                    }
                end
            end
            items[i] = item
        end
        if result.incomplete == nil then
            result.incomplete = false
        end
        return {
            isIncomplete = result.incomplete,
            items        = items,
        }
    end
}

m.register 'completionItem/resolve' {
    ---@async
    function (item)
        local core = require 'core.completion'
        if not item.data then
            return item
        end
        local id            = item.data.id
        local uri           = item.data.uri
        --await.setPriority(1000)
        local resolved = core.resolve(id)
        if not resolved then
            return nil
        end
        item.detail = resolved.detail or item.detail
        item.documentation = resolved.description and {
            value = tostring(resolved.description),
            kind  = 'markdown',
        } or item.documentation
        item.additionalTextEdits = resolved.additionalTextEdits and (function ()
            local t = {}
            for j, edit in ipairs(resolved.additionalTextEdits) do
                t[j] = {
                    range   = converter.packRange(
                        uri,
                        edit.start,
                        edit.finish
                    ),
                    newText = edit.newText,
                }
            end
            return t
        end)() or item.additionalTextEdits
        return item
    end
}

m.register 'textDocument/signatureHelp' {
    capability = {
        signatureHelpProvider = {
            triggerCharacters = { '(', ',' },
        },
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri = files.getRealUri(params.textDocument.uri)
        if not config.get(uri, 'Lua.signatureHelp.enable') then
            return nil
        end
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_SIGNATURE, 0.5)
        local pos = converter.unpackPosition(uri, params.position)
        local core = require 'core.signature'
        local results = core(uri, pos)
        if not results then
            return nil
        end
        local infos = {}
        for i, result in ipairs(results) do
            local parameters = {}
            for j, param in ipairs(result.params) do
                parameters[j] = {
                    label = {
                        param.label[1],
                        param.label[2],
                    }
                }
            end
            infos[i] = {
                label           = result.label,
                parameters      = parameters,
                activeParameter = result.index - 1,
                documentation   = result.description and {
                    value = tostring(result.description),
                    kind  = 'markdown',
                },
            }
        end
        return {
            signatures = infos,
        }
    end
}

m.register 'textDocument/documentSymbol' {
    capability = {
        documentSymbolProvider = true,
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri   = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_SYMBOL, 0.5)

        local core = require 'core.document-symbol'
        local symbols = core(uri)
        if not symbols then
            return nil
        end

        ---@async
        local function convert(symbol)
            await.delay()
            symbol.range = converter.packRange(
                uri,
                symbol.range[1],
                symbol.range[2]
            )
            symbol.selectionRange = converter.packRange(
                uri,
                symbol.selectionRange[1],
                symbol.selectionRange[2]
            )
            if symbol.name == '' then
                symbol.name = ' '
            end
            symbol.valueRange = nil
            if symbol.children then
                for _, child in ipairs(symbol.children) do
                    convert(child)
                end
            end
        end

        for _, symbol in ipairs(symbols) do
            convert(symbol)
        end

        return symbols
    end
}

m.register 'textDocument/codeAction' {
    capability = {
        codeActionProvider = {
            codeActionKinds = {
                '',
                'quickfix',
                'refactor.rewrite',
                'refactor.extract',
            },
            resolveProvider = false,
        },
    },
    abortByFileUpdate = true,
    function (params)
        local core        = require 'core.code-action'
        local uri         = files.getRealUri(params.textDocument.uri)
        local range       = params.range
        local diagnostics = params.context.diagnostics
        if not files.exists(uri) then
            return nil
        end

        local start, finish = converter.unpackRange(uri, range)
        local results = core(uri, start, finish, diagnostics)

        if not results or #results == 0 then
            return nil
        end

        for _, res in ipairs(results) do
            if res.edit then
                for turi, changes in pairs(res.edit.changes) do
                    for _, change in ipairs(changes) do
                        change.range = converter.packRange(turi, change.start, change.finish)
                        change.start  = nil
                        change.finish = nil
                    end
                end
            end
        end

        return results
    end
}

m.register 'workspace/executeCommand' {
    capability = {
        executeCommandProvider = {
            commands = {
                'lua.removeSpace',
                'lua.solve',
                'lua.jsonToLua',
                'lua.setConfig',
                'lua.autoRequire',
            },
        },
    },
    ---@async
    function (params)
        local command = params.command:gsub(':.+', '')
        if     command == 'lua.removeSpace' then
            local core = require 'core.command.removeSpace'
            return core(params.arguments[1])
        elseif command == 'lua.solve' then
            local core = require 'core.command.solve'
            return core(params.arguments[1])
        elseif command == 'lua.jsonToLua' then
            local core = require 'core.command.jsonToLua'
            return core(params.arguments[1])
        elseif command == 'lua.setConfig' then
            local core = require 'core.command.setConfig'
            return core(params.arguments[1])
        elseif command == 'lua.autoRequire' then
            local core = require 'core.command.autoRequire'
            return core(params.arguments[1])
        end
    end
}

m.register 'workspace/symbol' {
    capability = {
        workspaceSymbolProvider = true,
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local _ <close> = progress.create(workspace.getFirstScope().uri, lang.script.WINDOW_PROCESSING_WS_SYMBOL, 0.5)
        local core = require 'core.workspace-symbol'

        local symbols = core(params.query)
        if not symbols or #symbols == 0 then
            return nil
        end

        local function convert(symbol)
            symbol.location = converter.location(
                symbol.uri,
                converter.packRange(
                    symbol.uri,
                    symbol.range[1],
                    symbol.range[2]
                )
            )
            symbol.uri = nil
        end

        for _, symbol in ipairs(symbols) do
            convert(symbol)
        end

        return symbols
    end
}

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

client.event(function (ev)
    if ev == 'init' then
        if not client.isVSCode() then
            m.register 'textDocument/semanticTokens/full' {
                capability = {
                    semanticTokensProvider = {
                        legend = {
                            tokenTypes     = toArray(define.TokenTypes),
                            tokenModifiers = toArray(define.TokenModifiers),
                        },
                        full  = true,
                    },
                },
                ---@async
                function (params)
                    log.debug('textDocument/semanticTokens/full')
                    local uri = files.getRealUri(params.textDocument.uri)
                    workspace.awaitReady(uri)
                    local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_SEMANTIC_FULL, 0.5)
                    local core = require 'core.semantic-tokens'
                    local results = core(uri, 0, math.huge)
                    return {
                        data = results
                    }
                end
            }
        end
    end
end)

m.register 'textDocument/semanticTokens/range' {
    capability = {
        semanticTokensProvider = {
            legend = {
                tokenTypes     = toArray(define.TokenTypes),
                tokenModifiers = toArray(define.TokenModifiers),
            },
            range = true,
        },
    },
    ---@async
    function (params)
        log.debug('textDocument/semanticTokens/range')
        local uri = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_SEMANTIC_RANGE, 0.5)
        local core = require 'core.semantic-tokens'
        local start, finish = converter.unpackRange(uri, params.range)
        local results = core(uri, start, finish)
        return {
            data = results
        }
    end
}

m.register 'textDocument/foldingRange' {
    capability = {
        foldingRangeProvider = true,
    },
    ---@async
    function (params)
        local core    = require 'core.folding'
        local uri     = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local regions = core(uri)
        if not regions then
            return nil
        end

        local results = {}
        for _, region in ipairs(regions) do
            local startLine = converter.packPosition(uri, region.start).line
            local endLine   = converter.packPosition(uri, region.finish).line
            if not region.hideLastLine then
                endLine = endLine - 1
            end
            if startLine < endLine then
                results[#results+1] = {
                    startLine      = startLine,
                    endLine        = endLine,
                    kind           = region.kind,
                }
            end
        end

        return results
    end
}

m.register 'textDocument/documentColor' {
    capability = {
        colorProvider = true
    },
    ---@async
    function (params)
        local color = require 'core.color'
        local uri     = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        if not files.exists(uri) then
            return nil
        end
        local colors = color.colors(uri)
        if not colors then
            return nil
        end
        local results = {}
        for _, colorValue in ipairs(colors) do
            results[#results+1] = {
                range = converter.packRange(uri, colorValue.start, colorValue.finish),
                color = colorValue.color
            }
        end
        return results
    end
}

m.register 'textDocument/colorPresentation' {
    function (params)
        local color = (require 'core.color').colorToText(params.color)
        return {{label = color}}
    end
}

m.register 'window/workDoneProgress/cancel' {
    function (params)
        log.debug('close proto(cancel):', params.token)
        progress.cancel(params.token)
    end
}

m.register '$/status/click' {
    ---@async
    function ()
        local titleDiagnostic = lang.script.WINDOW_LUA_STATUS_DIAGNOSIS_TITLE
        local result = client.awaitRequestMessage('Info', lang.script.WINDOW_LUA_STATUS_DIAGNOSIS_MSG, {
            titleDiagnostic,
            DEVELOP and 'Restart Server',
        })
        if not result then
            return
        end
        if result == titleDiagnostic then
            local diagnostic = require 'provider.diagnostic'
            for _, scp in ipairs(workspace.folders) do
                diagnostic.diagnosticsScope(scp.uri, true)
            end
        elseif result == 'Restart Server' then
            local diag = require 'provider.diagnostic'
            diag.clearAll(true)
            os.exit(0, true)
        end
    end
}

m.register 'textDocument/formatting' {
    capability = {
        documentFormattingProvider = true,
    },
    ---@async
    function(params)
        local uri = files.getRealUri(params.textDocument.uri)

        if not files.exists(uri) then
            return nil
        end

        if not config.get(uri, 'Lua.format.enable') then
            return nil
        end

        local pformatting = require 'provider.formatting'
        pformatting.updateConfig(uri)

        local core = require 'core.formatting'
        local edits = core(uri, params.options)
        if not edits or #edits == 0 then
            return nil
        end

        local results = {}
        for i, edit in ipairs(edits) do
            results[i] = {
                range   = converter.packRange(uri, edit.start, edit.finish),
                newText = edit.text,
            }
        end

        return results
    end
}

m.register 'textDocument/rangeFormatting' {
    capability = {
        documentRangeFormattingProvider = true,
    },
    ---@async
    function(params)
        local uri = files.getRealUri(params.textDocument.uri)

        if not files.exists(uri) then
            return nil
        end

        if not config.get(uri, 'Lua.format.enable') then
            return nil
        end

        local pformatting = require 'provider.formatting'
        pformatting.updateConfig(uri)

        local core = require 'core.rangeformatting'
        local edits = core(uri, params.range, params.options)
        if not edits or #edits == 0 then
            return nil
        end

        local results = {}
        for i, edit in ipairs(edits) do
            results[i] = {
                range   = converter.packRange(uri, edit.start, edit.finish),
                newText = edit.text,
            }
        end

        return results
    end
}

m.register 'textDocument/onTypeFormatting' {
    capability = {
        documentOnTypeFormattingProvider = {
            firstTriggerCharacter = '\n',
            moreTriggerCharacter  = nil, -- string[]
        },
    },
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri    = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        local _ <close> = progress.create(uri, lang.script.WINDOW_PROCESSING_TYPE_FORMATTING, 0.5)
        local ch     = params.ch
        if not files.exists(uri) then
            return nil
        end
        local core   = require 'core.type-formatting'
        local pos    = converter.unpackPosition(uri, params.position)
        local edits  = core(uri, pos, ch, params.options)
        if not edits or #edits == 0 then
            return nil
        end
        local tab = '\t'
        if params.options.insertSpaces then
            tab = (' '):rep(params.options.tabSize)
        end
        local results = {}
        for i, edit in ipairs(edits) do
            results[i] = {
                range   = converter.packRange(uri, edit.start, edit.finish),
                newText = edit.text:gsub('\t', tab),
            }
        end
        return results
    end
}

m.register '$/cancelRequest' {
    function (params)
        proto.close(params.id, define.ErrorCodes.RequestCancelled, 'Request cancelled.')
    end
}

m.register '$/requestHint' {
    ---@async
    function (params)
        local uri  = files.getRealUri(params.textDocument.uri)
        if not config.get(uri, 'Lua.hint.enable') then
            return
        end
        workspace.awaitReady(uri)
        local core = require 'core.hint'
        local start, finish = converter.unpackRange(uri, params.range)
        local results = core(uri, start, finish)
        local hintResults = {}
        for i, res in ipairs(results) do
            hintResults[i] = {
                text = res.text,
                pos  = converter.packPosition(uri, res.offset),
                kind = res.kind,
            }
        end
        return hintResults
    end
}

m.register 'textDocument/inlayHint' {
    capability = {
        inlayHintProvider = {
            resolveProvider = true,
        },
    },
    ---@async
    function (params)
        local uri  = files.getRealUri(params.textDocument.uri)
        if not config.get(uri, 'Lua.hint.enable') then
            return
        end
        workspace.awaitReady(uri)
        local core = require 'core.hint'
        local start, finish = converter.unpackRange(uri, params.range)
        local results = core(uri, start, finish)
        local hintResults = {}
        for i, res in ipairs(results) do
            hintResults[i] = {
                label        = {
                    {
                        value    = res.text,
                        tooltip  = res.tooltip,
                        location = res.source and converter.location(
                                    guide.getUri(res.source),
                                    converter.packRange(
                                        guide.getUri(res.source),
                                        res.source.start,
                                        res.source.finish
                                    )
                                ),
                    },
                },
                position     = converter.packPosition(uri, res.offset),
                kind         = res.kind,
                paddingLeft  = true,
                paddingRight = true,
            }
        end
        return hintResults
    end
}

m.register 'inlayHint/resolve' {
    capability = {
        inlayHintProvider = {
            resolveProvider = true,
        },
    },
    ---@async
    function (hint)
        return hint
    end
}

m.register 'textDocument/diagnostic' {
    preview = true,
    capability = {
        diagnosticProvider = {
            identifier            = 'identifier',
            interFileDependencies = true,
            workspaceDiagnostics  = false,
        }
    },
    ---@async
    function (params)
        local uri = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady(uri)
        local core = require 'provider.diagnostic'
        -- TODO: do some trick
        core.doDiagnostic(uri)

        return {
            kind = 'unchanged',
            resultId = uri,
        }

        --if not params.previousResultId then
        --    core.clearCache(uri)
        --end
        --local results, unchanged = core.pullDiagnostic(uri, false)
        --if unchanged then
        --    return {
        --        kind = 'unchanged',
        --        resultId = uri,
        --    }
        --else
        --    return {
        --        kind = 'full',
        --        resultId = uri,
        --        items = results or {},
        --    }
        --end
    end
}

m.register 'workspace/diagnostic' {
    --preview = true,
    --capability = {
    --    diagnosticProvider = {
    --        workspaceDiagnostics  = false,
    --    }
    --},
    ---@async
    function (params)
        local core = require 'provider.diagnostic'
        local excepts = {}
        for _, id in ipairs(params.previousResultIds) do
            excepts[#excepts+1] = id.value
        end
        core.clearCacheExcept(excepts)
        local function convertItem(result)
            if result.unchanged then
                return {
                    kind     = 'unchanged',
                    resultId = result.uri,
                    uri      = result.uri,
                    version  = result.version,
                }
            else
                return {
                    kind     = 'full',
                    resultId = result.uri,
                    items    = result.result or {},
                    uri      = result.uri,
                    version  = result.version,
                }
            end
        end
        core.pullDiagnosticScope(function (result)
            proto.notify('$/progress', {
                token = params.partialResultToken,
                value = {
                    items = {
                        convertItem(result)
                    }
                }
            })
        end)
        return { items = {} }
    end
}

m.register '$/api/report' {
    ---@async
    function (params)
        local buildMeta = require 'provider.build-meta'
        local SDBMHash  = require 'SDBMHash'
        await.close 'api/report'
        await.setID 'api/report'
        local name = params.name or 'default'
        local uri  = workspace.getFirstScope().uri
        local hash = uri and ('%08x'):format(SDBMHash():hash(uri))
        local encoding = config.get(nil, 'Lua.runtime.fileEncoding')
        local nameBuf = {}
        nameBuf[#nameBuf+1] = name
        nameBuf[#nameBuf+1] = hash
        nameBuf[#nameBuf+1] = encoding
        local fileDir = METAPATH .. '/' ..  table.concat(nameBuf, ' ')
        fs.create_directories(fs.path(fileDir))
        buildMeta.build(fileDir, params)
        client.setConfig {
            {
                key    = 'Lua.workspace.library',
                action = 'add',
                value  = fileDir,
                uri    = uri,
            }
        }
    end
}

local function refreshStatusBar()
    local valid = config.get(nil, 'Lua.window.statusBar')
    for _, scp in ipairs(workspace.folders) do
        if not config.get(scp.uri, 'Lua.window.statusBar') then
            valid = false
            break
        end
    end
    if valid then
        proto.notify('$/status/show')
    else
        proto.notify('$/status/hide')
    end
end

config.watch(function (uri, key, value)
    if key == 'Lua.window.statusBar'
    or key == '' then
        refreshStatusBar()
    end
end)

m.register '$/status/refresh' { refreshStatusBar }

files.watch(function (ev, uri)
    if not workspace.isReady(uri) then
        return
    end
    if ev == 'update'
    or ev == 'remove' then
        for id, p in pairs(proto.holdon) do
            if m.attributes[p.method].abortByFileUpdate then
                log.debug('close proto(ContentModified):', id, p.method)
                proto.close(id, define.ErrorCodes.ContentModified, 'Content modified.')
            end
        end
    end
end)
