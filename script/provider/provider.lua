local util       = require 'utility'
local cap        = require 'provider.capability'
local await      = require 'await'
local files      = require 'files'
local proto      = require 'proto.proto'
local define     = require 'proto.define'
local workspace  = require 'workspace'
local config     = require 'config'
local library    = require 'library'
local client     = require 'client'
local pub        = require 'pub'
local lang       = require 'language'
local progress   = require 'progress'
local tm         = require 'text-merger'
local cfgLoader  = require 'config.loader'
local converter  = require 'proto.converter'
local filewatch  = require 'filewatch'
local json       = require 'json'

local function mergeConfig(a, b)
    for k, v in pairs(b) do
        if a[k] == nil then
            a[k] = v
        end
    end
end

---@async
local function updateConfig()
    local merged = {}

    local cfg = cfgLoader.loadLocalConfig(CONFIGPATH)
    if cfg then
        log.debug('load config from local', CONFIGPATH)
        -- watch directory
        filewatch.watch(workspace.getAbsolutePath(CONFIGPATH):gsub('[^/\\]+$', ''))
        mergeConfig(merged, cfg)
    end

    local rc = cfgLoader.loadRCConfig('.luarc.json')
    if rc then
        log.debug('load config from luarc')
        mergeConfig(merged, rc)
    end

    local clientConfig = cfgLoader.loadClientConfig()
    if clientConfig then
        log.debug('load config from client')
        mergeConfig(merged, clientConfig)
    end

    for k, v in pairs(merged) do
        if v == json.null then
            merged[k] = nil
        end
    end

    config.update(merged)
    log.debug('loaded config dump:', util.dump(merged))
end

---@class provider
local m = {}

m.attributes = {}

function m.register(method)
    return function (attrs)
        m.attributes[method] = attrs
        proto.on(method, attrs[1])
    end
end

filewatch.event(function (changes) ---@async
    local configPath = CONFIGPATH and workspace.getAbsolutePath(CONFIGPATH)
    local rcPath     = workspace.getAbsolutePath('.luarc.json')
    for _, change in ipairs(changes) do
        if change.path == configPath
        or change.path == rcPath then
            updateConfig()
            return
        end
    end
end)

m.register 'initialize' {
    function (params)
        client.init(params)
        config.init()
        workspace.initPath(params.rootUri)
        return {
            capabilities = cap.getIniter(),
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
        local _ <close> = progress.create(lang.script.WINDOW_INITIALIZING, 0.5)
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
        library.init()
        workspace.init()
        return true
    end
}

m.register 'exit' {
    function ()
        log.info('Server exited.')
        os.exit(true)
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
        log.debug('workspace/didCreateFiles', util.dump(params))
        for _, file in ipairs(params.files) do
            if workspace.isValidLuaUri(file.uri) then
                files.setText(file.uri, pub.awaitTask('loadFile', file.uri), false)
            end
        end
    end
}

m.register 'workspace/didDeleteFiles' {
    function (params)
        log.debug('workspace/didDeleteFiles', util.dump(params))
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
        log.debug('workspace/didRenameFiles', util.dump(params))
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

m.register 'textDocument/didOpen' {
    ---@async
    function (params)
        workspace.awaitReady()
        local doc   = params.textDocument
        local uri   = files.getRealUri(doc.uri)
        local text  = doc.text
        log.debug('didOpen', uri)
        files.setText(uri, text, true)
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
        workspace.awaitReady()
        local doc     = params.textDocument
        local changes = params.contentChanges
        local uri     = files.getRealUri(doc.uri)
        --log.debug('changes', util.dump(changes))
        local text = files.getOriginText(uri) or ''
        local rows = files.getCachedRows(uri)
        text, rows = tm(text, rows, changes)
        files.setText(uri, text, true)
        files.setCachedRows(uri, rows)
    end
}

m.register 'textDocument/hover' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        local doc    = params.textDocument
        local uri    = files.getRealUri(doc.uri)
        if not workspace.isReady() then
            local count, max = workspace.getLoadProcess()
            return {
                contents = {
                    value = lang.script('HOVER_WS_LOADING', count, max),
                    kind  = 'markdown',
                }
            }
        end
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_HOVER, 0.5)
        local core = require 'core.hover'
        if not files.exists(uri) then
            return nil
        end
        local pos = converter.unpackPosition(uri, params.position)
        local hover, source = core.byUri(uri, pos)
        if not hover then
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
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_DEFINITION, 0.5)
        local core   = require 'core.definition'
        local uri    = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
        local pos = converter.unpackPosition(uri, params.position)
        local result = core(uri, pos)
        if not result then
            return nil
        end
        local response = {}
        for i, info in ipairs(result) do
            local targetUri = info.uri
            if targetUri then
                if files.exists(targetUri) then
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
        end
        return response
    end
}

m.register 'textDocument/typeDefinition' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_TYPE_DEFINITION, 0.5)
        local core   = require 'core.type-definition'
        local uri    = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
        local pos = converter.unpackPosition(uri, params.position)
        local result = core(uri, pos)
        if not result then
            return nil
        end
        local response = {}
        for i, info in ipairs(result) do
            local targetUri = info.uri
            if targetUri then
                if files.exists(targetUri) then
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
        end
        return response
    end
}

m.register 'textDocument/references' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_REFERENCE, 0.5)
        local core   = require 'core.reference'
        local uri    = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
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
    abortByFileUpdate = true,
    function (params)
        local core = require 'core.highlight'
        local uri  = files.getRealUri(params.textDocument.uri)
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
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_RENAME, 0.5)
        local core = require 'core.rename'
        local uri  = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
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
        if not workspace.isReady() then
            local count, max = workspace.getLoadProcess()
            return {
                {
                    label = lang.script('HOVER_WS_LOADING', count, max),textEdit         = {
                        range   = {
                            start   = params.position,
                            ['end'] = params.position,
                        },
                        newText = '',
                    },
                }
            }
        end
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_COMPLETION, 0.5)
        --log.info(util.dump(params))
        local core  = require 'core.completion'
        --log.debug('textDocument/completion')
        --log.debug('completion:', params.context and params.context.triggerKind, params.context and params.context.triggerCharacter)
        if not files.exists(uri) then
            return nil
        end
        local triggerCharacter = params.context and params.context.triggerCharacter
        if config.get 'editor.acceptSuggestionOnEnter' ~= 'off' then
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
                sortText         = ('%04d'):format(i),
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
        return {
            isIncomplete = not result.complete,
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
    abortByFileUpdate = true,
    ---@async
    function (params)
        if not config.get 'Lua.signatureHelp.enable' then
            return nil
        end
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SIGNATURE, 0.5)
        local uri = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
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
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SYMBOL, 0.5)
        local core = require 'core.document-symbol'
        local uri   = files.getRealUri(params.textDocument.uri)

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
                symbol.name = lang.script.SYMBOL_ANONYMOUS
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
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_WS_SYMBOL, 0.5)
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

m.register 'textDocument/semanticTokens/full' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SEMANTIC_FULL, 0.5)
        local core = require 'core.semantic-tokens'
        local results = core(uri, 0, math.huge)
        return {
            data = results
        }
    end
}

m.register 'textDocument/semanticTokens/range' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        local uri = files.getRealUri(params.textDocument.uri)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SEMANTIC_RANGE, 0.5)
        local core = require 'core.semantic-tokens'
        local cache  = files.getOpenedCache(uri)
        local start, finish
        if cache and not cache['firstSemantic'] then
            cache['firstSemantic'] = true
            start  = 0
            finish = math.huge
        else
            start, finish = converter.unpackRange(uri, params.range)
        end
        local results = core(uri, start, finish)
        return {
            data = results
        }
    end
}

m.register 'textDocument/foldingRange' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        local core    = require 'core.folding'
        local uri     = files.getRealUri(params.textDocument.uri)
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

m.register 'window/workDoneProgress/cancel' {
    function (params)
        log.debug('close proto(cancel):', params.token)
        progress.cancel(params.token)
    end
}

m.register '$/didChangeVisibleRanges' {
    ---@async
    function (params)
        local uri = files.getRealUri(params.uri)
        await.close('visible:' .. uri)
        await.setID('visible:' .. uri)
        await.delay()
        files.setVisibles(uri, params.ranges)
    end
}

m.register '$/status/click' {
    ---@async
    function ()
        -- TODO: translate
        local titleDiagnostic = '进行工作区诊断'
        local result = client.awaitRequestMessage('Info', 'xxx', {
            titleDiagnostic,
        })
        if not result then
            return
        end
        if result == titleDiagnostic then
            local diagnostic = require 'provider.diagnostic'
            diagnostic.diagnosticsAll(true)
        end
    end
}

m.register 'textDocument/onTypeFormatting' {
    abortByFileUpdate = true,
    ---@async
    function (params)
        workspace.awaitReady()
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_TYPE_FORMATTING, 0.5)
        local ch     = params.ch
        local uri    = files.getRealUri(params.textDocument.uri)
        if not files.exists(uri) then
            return nil
        end
        local core   = require 'core.type-formatting'
        local pos    = converter.unpackPosition(uri, params.position)
        local edits  = core(uri, pos, ch)
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
        proto.close(params.id, define.ErrorCodes.RequestCancelled)
    end
}

m.register '$/requestHint' {
    ---@async
    function (params)
        local core = require 'core.hint'
        if not config.get 'Lua.hint.enable' then
            return
        end
        workspace.awaitReady()
        local uri           = files.getRealUri(params.textDocument.uri)
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

-- Hint
do
    ---@async
    local function updateHint(uri)
        if not config.get 'Lua.hint.enable' then
            return
        end
        local id = 'updateHint' .. uri
        await.close(id)
        await.setID(id)
        workspace.awaitReady()
        local visibles = files.getVisibles(uri)
        if not visibles then
            return
        end
        await.close(id)
        await.setID(id)
        await.delay()
        workspace.awaitReady()
        local edits = {}
        local hint = require 'core.hint'
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_HINT, 0.5)
        for _, visible in ipairs(visibles) do
            local piece = hint(uri, visible.start, visible.finish)
            if piece then
                for _, edit in ipairs(piece) do
                    edits[#edits+1] = {
                        text = edit.text,
                        pos  = converter.packPosition(uri, edit.offset),
                    }
                end
            end
        end

        proto.notify('$/hint', {
            uri   = uri,
            edits = edits,
        })
    end

    files.watch(function (ev, uri)
        if ev == 'update'
        or ev == 'updateVisible' then
            await.call(function () ---@async
                updateHint(uri)
            end)
        end
    end)
end

local function refreshStatusBar()
    local value = config.get 'Lua.window.statusBar'
    if value then
        proto.notify('$/status/show')
    else
        proto.notify('$/status/hide')
    end
end

config.watch(function (key, value)
    if key == 'Lua.window.statusBar' then
        refreshStatusBar()
    end
end)

m.register '$/status/refresh' { refreshStatusBar }

files.watch(function (ev, uri)
    if not workspace.isReady() then
        return
    end
    if ev == 'update'
    or ev == 'remove' then
        for id, p in pairs(proto.holdon) do
            if m.attributes[p.method].abortByFileUpdate then
                log.debug('close proto(ContentModified):', id, p.method)
                proto.close(id, define.ErrorCodes.ContentModified)
            end
        end
    end
end)
