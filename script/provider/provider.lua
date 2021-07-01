local util      = require 'utility'
local cap       = require 'provider.capability'
local completion= require 'provider.completion'
local semantic  = require 'provider.semantic-tokens'
local await     = require 'await'
local files     = require 'files'
local proto     = require 'proto.proto'
local define    = require 'proto.define'
local workspace = require 'workspace'
local config    = require 'config'
local library   = require 'library'
local markdown  = require 'provider.markdown'
local client    = require 'provider.client'
local furi      = require 'file-uri'
local pub       = require 'pub'
local fs        = require 'bee.filesystem'
local lang      = require 'language'
local plugin    = require 'plugin'
local progress  = require 'progress'
local tm        = require 'text-merger'
local vm        = require 'vm'
local nonil     = require 'without-check-nil'
local cfgLoader = require 'config.loader'

local function updateConfig()
    local diagnostics = require 'provider.diagnostic'
    local telemetry   = require 'service.telemetry'
    local new
    if CONFIGPATH then
        new = cfgLoader.loadLocalConfig(CONFIGPATH)
        log.debug('load config from local', CONFIGPATH)
    else
        new = cfgLoader.loadClientConfig()
        log.debug('load config from client')
    end
    if not new then
        log.warn('load config failed!')
        return
    end
    log.debug('loaded config dump:', util.dump(new))

    local oldConfig = config.dump()
    config.update(new)
    local newConfig = config.dump()
    log.debug('config updated:', util.dump(newConfig))

    if not util.equal(oldConfig.Lua.runtime, newConfig.Lua.runtime) then
        library.init()
        workspace.reload()
        semantic.refresh()
    end
    if not util.equal(oldConfig.Lua.diagnostics, newConfig.Lua.diagnostics) then
        diagnostics.diagnosticsAll()
    end
    if not util.equal(oldConfig.Lua.workspace, newConfig.Lua.workspace)
    or not util.equal(oldConfig.files,     newConfig.files)
    then
        workspace.reload()
        semantic.refresh()
    end

    if newConfig.Lua.completion.enable then
        completion.enable()
    else
        completion.disable()
    end
    if newConfig.Lua.color.mode == 'Semantic' then
        semantic.enable()
    else
        semantic.disable()
    end
    if newConfig.Lua.window.statusBar then
        proto.notify('$/status/show')
    else
        proto.notify('$/status/hide')
    end
    telemetry.updateConfig()
end

proto.on('initialize', function (params)
    client.init(params)
    library.init()
    workspace.init(params.rootUri)
    return {
        capabilities = cap.getIniter(),
        serverInfo   = {
            name    = 'sumneko.lua',
        },
    }
end)

proto.on('initialized', function (params)
    files.init()
    local _ <close> = progress.create(lang.script.WINDOW_INITIALIZING, 0.5)
    updateConfig()
    local registrations = {}

    nonil.enable()
    if client.info.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration then
        -- 监视文件变化
        registrations[#registrations+1] = {
            id = 'workspace/didChangeWatchedFiles',
            method = 'workspace/didChangeWatchedFiles',
            registerOptions = {
                watchers = {
                    {
                        globPattern = '**/',
                        kind = 1 | 2 | 4,
                    }
                },
            },
        }
    end

    if client.info.capabilities.workspace.didChangeConfiguration.dynamicRegistration then
        -- 监视配置变化
        registrations[#registrations+1] = {
            id = 'workspace/didChangeConfiguration',
            method = 'workspace/didChangeConfiguration',
        }
    end

    nonil.disable()

    if #registrations ~= 0 then
        proto.awaitRequest('client/registerCapability', {
            registrations = registrations
        })
    end
    workspace.reload()
    return true
end)

proto.on('exit', function ()
    log.info('Server exited.')
    os.exit(true)
end)

proto.on('shutdown', function ()
    log.info('Server shutdown.')
    return true
end)

proto.on('workspace/didChangeConfiguration', function ()
    if CONFIGPATH then
        return
    end
    updateConfig()
end)

proto.on('workspace/didChangeWatchedFiles', function (params)
    for _, change in ipairs(params.changes) do
        local uri = change.uri
        if not workspace.isWorkspaceUri(uri) then
            goto CONTINUE
        end
        if     change.type == define.FileChangeType.Created then
            log.debug('FileChangeType.Created', uri)
            workspace.awaitLoadFile(uri)
        elseif change.type == define.FileChangeType.Deleted then
            log.debug('FileChangeType.Deleted', uri)
            files.remove(uri)
            local childs = files.getChildFiles(uri)
            for _, curi in ipairs(childs) do
                log.debug('FileChangeType.Deleted.Child', curi)
                files.remove(curi)
            end
        elseif change.type == define.FileChangeType.Changed then
            -- 如果文件处于关闭状态，则立即更新；否则等待didChange协议来更新
            if  files.isLua(uri)
            and not files.isOpen(uri)
            and (not workspace.isIgnored(uri) or files.isLibrary(uri)) then
                plugin.awaitReady()
                files.setText(uri, pub.awaitTask('loadFile', uri), false)
            else
                local path = furi.decode(uri)
                local filename = fs.path(path):filename():string()
                -- 排除类文件发生更改需要重新扫描
                if files.eq(filename, '.gitignore')
                or files.eq(filename, '.gitmodules') then
                    workspace.reload()
                    break
                end
            end
        end
        ::CONTINUE::
    end
end)

proto.on('workspace/didCreateFiles', function (params)
    log.debug('workspace/didCreateFiles', util.dump(params))
    plugin.awaitReady()
    for _, file in ipairs(params.files) do
        if files.isLua(file.uri) then
            files.setText(file.uri, pub.awaitTask('loadFile', file.uri), false)
        end
    end
end)

proto.on('workspace/didDeleteFiles', function (params)
    log.debug('workspace/didDeleteFiles', util.dump(params))
    for _, file in ipairs(params.files) do
        files.remove(file.uri)
        local childs = files.getChildFiles(file.uri)
        for _, uri in ipairs(childs) do
            log.debug('workspace/didDeleteFiles#child', uri)
            files.remove(uri)
        end
    end
end)

proto.on('workspace/didRenameFiles', function (params)
    log.debug('workspace/didRenameFiles', util.dump(params))
    plugin.awaitReady()
    for _, file in ipairs(params.files) do
        local text = files.getOriginText(file.oldUri)
        if text then
            files.remove(file.oldUri)
            files.setText(file.newUri, text, false)
        end
        local childs = files.getChildFiles(file.oldUri)
        for _, uri in ipairs(childs) do
            local ctext = files.getOriginText(uri)
            if ctext then
                local ouri = files.getOriginUri(uri)
                local tail = ouri:sub(#file.oldUri)
                local nuri = file.newUri .. tail
                log.debug('workspace/didRenameFiles#child', ouri, nuri)
                files.remove(uri)
                files.setText(nuri, text, false)
            end
        end
    end
end)

proto.on('textDocument/didOpen', function (params)
    local doc   = params.textDocument
    local uri   = doc.uri
    local text  = doc.text
    log.debug('didOpen', uri)
    files.open(uri)
    plugin.awaitReady()
    if not files.isOpen(uri) then
        return
    end
    files.setText(uri, text, true)
end)

proto.on('textDocument/didClose', function (params)
    local doc   = params.textDocument
    local uri   = doc.uri
    log.debug('didClose', uri)
    files.close(uri)
    if not files.isLua(uri) then
        files.remove(uri)
    end
end)

proto.on('textDocument/didChange', function (params)
    local doc     = params.textDocument
    local changes = params.contentChanges
    local uri     = doc.uri
    plugin.awaitReady()
    if not files.isLua(uri) and not files.isOpen(uri) then
        return
    end
    --log.debug('changes', util.dump(changes))
    local text = tm(uri, changes)
    files.setText(uri, text, true)
end)

proto.on('textDocument/hover', function (params)
    await.close 'hover'
    await.setID 'hover'
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
    local doc    = params.textDocument
    local uri    = doc.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local hover = core.byUri(uri, offset)
    if not hover then
        return nil
    end
    local md = markdown()
    md:add('lua', hover.label)
    md:splitLine()
    md:add('md',  hover.description)
    return {
        contents = {
            value = md:string(),
            kind  = 'markdown',
        },
        range = files.range(uri, hover.source.start, hover.source.finish),
    }
end)

proto.on('textDocument/definition', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_DEFINITION, 0.5)
    local core   = require 'core.definition'
    local uri    = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for i, info in ipairs(result) do
        local targetUri = info.uri
        if targetUri then
            if files.exists(targetUri) then
                response[i] = define.locationLink(targetUri
                    , files.range(targetUri, info.target.start, info.target.finish)
                    , files.range(targetUri, info.target.start, info.target.finish)
                    , files.range(uri,       info.source.start, info.source.finish)
                )
            end
        end
    end
    return response
end)

proto.on('textDocument/typeDefinition', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_TYPE_DEFINITION, 0.5)
    local core   = require 'core.type-definition'
    local uri    = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for i, info in ipairs(result) do
        local targetUri = info.uri
        if targetUri then
            if files.exists(targetUri) then
                response[i] = define.locationLink(targetUri
                    , files.range(targetUri, info.target.start, info.target.finish)
                    , files.range(targetUri, info.target.start, info.target.finish)
                    , files.range(uri,       info.source.start, info.source.finish)
                )
            end
        end
    end
    return response
end)

proto.on('textDocument/references', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_REFERENCE, 0.5)
    local core   = require 'core.reference'
    local uri    = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for i, info in ipairs(result) do
        local targetUri = info.uri
        response[i] = define.location(targetUri
            , files.range(targetUri, info.target.start, info.target.finish)
        )
    end
    return response
end)

proto.on('textDocument/documentHighlight', function (params)
    local core = require 'core.highlight'
    local uri  = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for _, info in ipairs(result) do
        response[#response+1] = {
            range = files.range(uri, info.start, info.finish),
            kind  = info.kind,
        }
    end
    return response
end)

proto.on('textDocument/rename', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_RENAME, 0.5)
    local core = require 'core.rename'
    local uri  = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local result = core.rename(uri, offset, params.newName)
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
        local textEdit = define.textEdit(files.range(ruri, info.start, info.finish), info.text)
        workspaceEdit.changes[ruri][#workspaceEdit.changes[ruri]+1] = textEdit
    end
    return workspaceEdit
end)

proto.on('textDocument/prepareRename', function (params)
    local core = require 'core.rename'
    local uri  = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local offset = files.offsetOfWord(uri, params.position)
    local result = core.prepareRename(uri, offset)
    if not result then
        return nil
    end
    return {
        range       = files.range(uri, result.start, result.finish),
        placeholder = result.text,
    }
end)

proto.on('textDocument/completion', function (params)
    await.close 'completion'
    await.setID 'completion'
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
    local uri  = params.textDocument.uri
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
    await.setPriority(1000)
    local clock  = os.clock()
    local offset = files.offset(uri, params.position)
    local result = core.completion(uri, offset - 1, triggerCharacter)
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
                range   = files.range(
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
                        range   = files.range(
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
                value = res.description,
                kind  = 'markdown',
            },
        }
        if res.id then
            if easy and os.clock() - clock < 0.05 then
                local resolved = core.resolve(res.id)
                if resolved then
                    item.detail = resolved.detail
                    item.documentation = resolved.description and {
                        value = resolved.description,
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
        isIncomplete = false,
        items        = items,
    }
end)

proto.on('completionItem/resolve', function (item)
    local core = require 'core.completion'
    if not item.data then
        return item
    end
    await.close 'completion.resolve'
    await.setID 'completion.resolve'
    local id            = item.data.id
    local uri           = item.data.uri
    --await.setPriority(1000)
    local resolved = core.resolve(id)
    if not resolved then
        return nil
    end
    item.detail = resolved.detail or item.detail
    item.documentation = resolved.description and {
        value = resolved.description,
        kind  = 'markdown',
    } or item.documentation
    item.additionalTextEdits = resolved.additionalTextEdits and (function ()
        local t = {}
        for j, edit in ipairs(resolved.additionalTextEdits) do
            t[j] = {
                range   = files.range(
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
end)

proto.on('textDocument/signatureHelp', function (params)
    if not config.get 'Lua.signatureHelp.enable' then
        return nil
    end
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SIGNATURE, 0.5)
    local uri = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    await.close('signatureHelp')
    await.setID('signatureHelp')
    local offset = files.offset(uri, params.position)
    local core = require 'core.signature'
    local results = core(uri, offset - 1)
    if not results then
        return nil
    end
    local infos = {}
    for i, result in ipairs(results) do
        local parameters = {}
        for j, param in ipairs(result.params) do
            parameters[j] = {
                label = {
                    param.label[1] - 1,
                    param.label[2],
                }
            }
        end
        infos[i] = {
            label           = result.label,
            parameters      = parameters,
            activeParameter = result.index - 1,
            documentation   = result.description and {
                value = result.description,
                kind  = 'markdown',
            },
        }
    end
    return {
        signatures = infos,
    }
end)

proto.on('textDocument/documentSymbol', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SYMBOL, 0.5)
    local core = require 'core.document-symbol'
    local uri   = params.textDocument.uri

    local symbols = core(uri)
    if not symbols then
        return nil
    end

    local function convert(symbol)
        await.delay()
        symbol.range = files.range(
            uri,
            symbol.range[1],
            symbol.range[2]
        )
        symbol.selectionRange = files.range(
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
end)

proto.on('textDocument/codeAction', function (params)
    local core        = require 'core.code-action'
    local uri         = params.textDocument.uri
    local range       = params.range
    local diagnostics = params.context.diagnostics
    if not files.exists(uri) then
        return nil
    end

    local start, finish = files.unrange(uri, range)
    local results = core(uri, start, finish, diagnostics)

    if not results or #results == 0 then
        return nil
    end

    for _, res in ipairs(results) do
        if res.edit then
            for turi, changes in pairs(res.edit.changes) do
                for _, change in ipairs(changes) do
                    change.range = files.range(turi, change.start, change.finish)
                    change.start  = nil
                    change.finish = nil
                end
            end
        end
    end

    return results
end)

proto.on('workspace/executeCommand', function (params)
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
    end
end)

proto.on('workspace/symbol', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_WS_SYMBOL, 0.5)
    local core = require 'core.workspace-symbol'

    await.close('workspace/symbol')
    await.setID('workspace/symbol')

    local symbols = core(params.query)
    if not symbols or #symbols == 0 then
        return nil
    end

    local function convert(symbol)
        symbol.location = define.location(
            symbol.uri,
            files.range(
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
end)


proto.on('textDocument/semanticTokens/full', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SEMANTIC_FULL, 0.5)
    local core = require 'core.semantic-tokens'
    local uri = params.textDocument.uri
    local text  = files.getText(uri)
    if not text then
        return nil
    end
    local results = core(uri, 0, #text)
    return {
        data = results
    }
end)

proto.on('textDocument/semanticTokens/range', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SEMANTIC_RANGE, 0.5)
    local core = require 'core.semantic-tokens'
    local uri = params.textDocument.uri
    local start  = files.offsetOfWord(uri, params.range.start)
    local finish = files.offsetOfWord(uri, params.range['end'])
    local results = core(uri, start, finish)
    return {
        data = results
    }
end)

proto.on('textDocument/foldingRange', function (params)
    local core    = require 'core.folding'
    local uri     = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local regions = core(uri)
    if not regions then
        return nil
    end

    local results = {}
    for _, region in ipairs(regions) do
        local startLine = files.position(uri, region.start).line
        local endLine   = files.position(uri, region.finish).line
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
end)

proto.on('window/workDoneProgress/cancel', function (params)
    progress.cancel(params.token)
end)

proto.on('$/didChangeVisibleRanges', function (params)
    files.setVisibles(params.uri, params.ranges)
end)

proto.on('$/status/click', function ()
    do return end
    local titleDiagnostic = '进行工作区诊断'
    local titleRestart    = '重启语言服务'
    local result = proto.awaitRequest('window/showMessageRequest', {
        type    = define.MessageType.Info,
        message = '点击',
        actions = {
            {
                title = titleDiagnostic,
            },
            {
                title = titleRestart,
            },
        },
    })
    if not result then
        return
    end
    if result.title == titleDiagnostic then
        local diagnostic = require 'provider.diagnostic'
        diagnostic.diagnosticsAll()
        proto.notify('window/showMessage', {
            type     = define.MessageType.Info,
            message  = '诊断完成',
        })
    end
    if result.title == titleRestart then
        proto.notify('$/command', {
            command   = 'extension.lua.doc',
            data      = 'en-us/51/manual.html',
        })
        --os.exit(true)
    end
end)

proto.on('textDocument/onTypeFormatting', function (params)
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_TYPE_FORMATTING, 0.5)
    local ch     = params.ch
    local uri    = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local core   = require 'core.type-formatting'
    local offset = files.offset(uri, params.position)
    local edits  = core(uri, offset - 1, ch)
    if #edits == 0 then
        return nil
    end
    local tab = '\t'
    if params.options.insertSpaces then
        tab = (' '):rep(params.options.tabSize)
    end
    local results = {}
    for i, edit in ipairs(edits) do
        results[i] = {
            range   = files.range(uri, edit.start, edit.finish),
            newText = edit.text:gsub('\t', tab),
        }
    end
    return results
end)

-- Hint
do
    local function updateHint(uri)
        local awaitID = 'hint:' .. uri
        await.close(awaitID)
        if not config.get 'Lua.hint.enable' then
            return
        end
        await.setID(awaitID)
        workspace.awaitReady()
        local visibles = files.getVisibles(uri)
        if not visibles then
            return
        end
        local edits = {}
        local hint = require 'core.hint'
        local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_HINT, 0.5)
        for _, visible in ipairs(visibles) do
            local piece = hint(uri, visible.start, visible.finish)
            if piece then
                for _, edit in ipairs(piece) do
                    edits[#edits+1] = {
                        newText = edit.newText,
                        range   = files.range(uri, edit.start, edit.finish)
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
            await.call(function ()
                updateHint(uri)
            end)
        end
    end)
end
