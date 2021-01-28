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

local function updateConfig()
    local diagnostics = require 'provider.diagnostic'
    local vm          = require 'vm'
    local configs = proto.awaitRequest('workspace/configuration', {
        items = {
            {
                scopeUri = workspace.uri,
                section = 'Lua',
            },
            {
                scopeUri = workspace.uri,
                section = 'files.associations',
            },
            {
                scopeUri = workspace.uri,
                section = 'files.exclude',
            }
        },
    })
    if not configs or not configs[1] then
        log.warn('No config?', util.dump(configs))
        return
    end

    local updated = configs[1]
    local other   = {
        associations = configs[2],
        exclude      = configs[3],
    }

    local oldConfig = util.deepCopy(config.config)
    local oldOther  = util.deepCopy(config.other)
    config.setConfig(updated, other)
    local newConfig = config.config
    local newOther  = config.other

    if not util.equal(oldConfig.runtime, newConfig.runtime) then
        library.init()
        workspace.reload()
        semantic.refresh()
    end
    if not util.equal(oldConfig.diagnostics, newConfig.diagnostics) then
        diagnostics.diagnosticsAll()
    end
    if not util.equal(oldConfig.workspace, newConfig.workspace)
    or not util.equal(oldOther.associations, newOther.associations)
    or not util.equal(oldOther.exclude, newOther.exclude)
    then
        workspace.reload()
        semantic.refresh()
    end
    if not util.equal(oldConfig.intelliSense, newConfig.intelliSense) then
        files.flushCache()
    end

    if newConfig.completion.enable then
        completion.enable()
    else
        completion.disable()
    end
    if newConfig.color.mode == 'Semantic' then
        semantic.enable()
    else
        semantic.disable()
    end
    if newConfig.window.statusBar then
        proto.notify('$/status/show')
    else
        proto.notify('$/status/hide')
    end
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
    proto.awaitRequest('client/registerCapability', {
        registrations = {
            -- 监视文件变化
            {
                id = '0',
                method = 'workspace/didChangeWatchedFiles',
                registerOptions = {
                    watchers = {
                        {
                            globPattern = '**/',
                            kind = 1 | 2 | 4,
                        }
                    },
                },
            },
            -- 配置变化
            {
                id = '1',
                method = 'workspace/didChangeConfiguration',
            }
        }
    })
    workspace.awaitReload()
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
    updateConfig()
end)

proto.on('workspace/didChangeWatchedFiles', function (params)
    for _, change in ipairs(params.changes) do
        local uri = change.uri
        -- TODO 创建文件与删除文件直接重新扫描（文件改名、文件夹删除等情况太复杂了）
        if change.type == define.FileChangeType.Created
        or change.type == define.FileChangeType.Deleted then
            workspace.reload()
            break
        elseif change.type == define.FileChangeType.Changed then
            -- 如果文件处于关闭状态，则立即更新；否则等待didChange协议来更新
            if files.isLua(uri) and not files.isOpen(uri) then
                while not plugin.isReady() do
                    await.sleep(0.1)
                end
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
    end
end)

proto.on('textDocument/didOpen', function (params)
    local doc   = params.textDocument
    local uri   = doc.uri
    local text  = doc.text
    files.open(uri)
    while not plugin.isReady() do
        if not files.isOpen(uri) then
            return
        end
        await.sleep(0.1)
    end
    files.setText(uri, text, true)
end)

proto.on('textDocument/didClose', function (params)
    local doc   = params.textDocument
    local uri   = doc.uri
    files.close(uri)
    if not files.isLua(uri) then
        files.remove(uri)
    end
end)

proto.on('textDocument/didChange', function (params)
    local doc     = params.textDocument
    local changes = params.contentChanges
    local uri     = doc.uri
    while not plugin.isReady() or not files.exists(uri) do
        if not files.isLua(uri) and not files.isOpen(uri) then
            return
        end
        await.sleep(0.1)
    end
    files.clearDiff(uri)
    local text = files.getText(uri) or ''
    for _, change in ipairs(changes) do
        if change.range then
            local start, finish = files.unrange(uri, change.range)
            text = text:sub(1, start - 1) .. change.text .. text:sub(finish)
        else
            text = change.text
        end
    end
    files.setText(uri, text, true)
end)

proto.on('textDocument/hover', function (params)
    await.close 'hover'
    await.setID 'hover'
    workspace.awaitReady()
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
    if  hover.label and #hover.label > 0
    and hover.description and #hover.description > 0 then
        md:add('md', "---")
    end
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
    workspace.awaitReady()
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_COMPLETION, 0.5)
    --log.info(util.dump(params))
    local core  = require 'core.completion'
    --log.debug('textDocument/completion')
    --log.debug('completion:', params.context and params.context.triggerKind, params.context and params.context.triggerCharacter)
    local uri  = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    await.setPriority(1000)
    local clock  = os.clock()
    local offset = files.offset(uri, params.position)
    local result = core.completion(uri, offset - 1)
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('Completion takes %.3f sec.'):format(passed))
    end
    if not result then
        return nil
    end
    local easy = false
    local items = {}
    for i, res in ipairs(result) do
        local item = {
            label            = res.label,
            kind             = res.kind,
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
    local id            = item.data.id
    local uri           = item.data.uri
    --await.setPriority(1000)
    local resolved = core.resolve(id)
    if not resolved then
        return nil
    end
    item.detail = resolved.detail
    item.documentation = resolved.description and {
        value = resolved.description,
        kind  = 'markdown',
    }
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
    end)()
    return item
end)

proto.on('textDocument/signatureHelp', function (params)
    if not config.config.signatureHelp.enable then
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
    local offset = files.offsetOfWord(uri, params.position)
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
    local core = require 'core.document-symbol'
    local _ <close> = progress.create(lang.script.WINDOW_PROCESSING_SYMBOL, 0.5)
    local uri   = params.textDocument.uri
    while not files.exists(uri) do
        await.sleep(0.1)
    end

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
    log.debug('semanticTokens/full', uri)
    local text  = files.getText(uri)
    while not text do
        await.sleep(0.1)
        text  = files.getText(uri)
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
    log.debug('semanticTokens/range', uri)
    while not files.exists(uri) do
        await.sleep(0.1)
    end
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
