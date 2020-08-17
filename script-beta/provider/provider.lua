local util      = require 'utility'
local cap       = require 'provider.capability'
local completion= require 'provider.completion'
local await     = require 'await'
local files     = require 'files'
local proto     = require 'proto.proto'
local define    = require 'proto.define'
local workspace = require 'workspace'
local config    = require 'config'
local library   = require 'library'
local markdown  = require 'provider.markdown'

local function updateConfig()
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
        library.reload()
    end
    if not util.equal(oldConfig.diagnostics, newConfig.diagnostics) then
    end
    if not util.equal(oldConfig.plugin, newConfig.plugin) then
    end
    if not util.equal(oldConfig.workspace, newConfig.workspace)
    or not util.equal(oldConfig.plugin, newConfig.plugin)
    or not util.equal(oldOther.associations, newOther.associations)
    or not util.equal(oldOther.exclude, newOther.exclude)
    then
        workspace.reload()
    end

    if newConfig.completion.enable then
        completion.enable()
    else
        completion.disable()
    end
end

proto.on('initialize', function (params)
    --log.debug(util.dump(params))
    if params.workspaceFolders then
        local name = params.workspaceFolders[1].name
        local uri  = params.workspaceFolders[1].uri
        workspace.init(name, uri)
    end
    return {
        capabilities = cap.initer,
    }
end)

proto.on('initialized', function (params)
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
    await.create(workspace.awaitPreload)
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

proto.on('workspace/configuration', function ()
    updateConfig()
end)

proto.on('workspace/didChangeWatchedFiles', function (params)
end)

proto.on('textDocument/didOpen', function (params)
    local doc   = params.textDocument
    local uri   = doc.uri
    local text  = doc.text
    files.open(uri)
    files.setText(uri, text)
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
    local doc    = params.textDocument
    local change = params.contentChanges
    local uri    = doc.uri
    local text   = change[1].text
    if files.isLua(uri) or files.isOpen(uri) then
        --log.debug('didChange:', uri)
        files.setText(uri, text)
        --log.debug('setText:', #text)
    end
end)

proto.on('textDocument/hover', function (params)
    local core = require 'core.hover'
    local doc    = params.textDocument
    local uri    = doc.uri
    if not files.exists(uri) then
        return nil
    end
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local hover = core.byUri(uri, offset)
    if not hover then
        return nil
    end
    local md = markdown()
    md:add('lua', hover.label)
    md:add('md',  hover.description)
    return {
        contents = {
            value = md:string(),
            kind  = 'markdown',
        },
        range = define.range(lines, text, hover.source.start, hover.source.finish),
    }
end)

proto.on('textDocument/definition', function (params)
    local core   = require 'core.definition'
    local uri    = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for i, info in ipairs(result) do
        local targetUri = info.uri
        if targetUri then
            local targetLines = files.getLines(targetUri)
            local targetText  = files.getText(targetUri)
            response[i] = define.locationLink(targetUri
                , define.range(targetLines, targetText, info.target.start, info.target.finish)
                , define.range(targetLines, targetText, info.target.start, info.target.finish)
                , define.range(lines,       text,       info.source.start, info.source.finish)
            )
        end
    end
    return response
end)

proto.on('textDocument/references', function (params)
    local core   = require 'core.reference'
    local uri    = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for i, info in ipairs(result) do
        local targetUri = info.uri
        local targetLines = files.getLines(targetUri)
        local targetText  = files.getText(targetUri)
        response[i] = define.location(targetUri
            , define.range(targetLines, targetText, info.target.start, info.target.finish)
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
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for _, info in ipairs(result) do
        response[#response+1] = {
            range = define.range(lines, text, info.start, info.finish),
            kind  = info.kind,
        }
    end
    return response
end)

proto.on('textDocument/rename', function (params)
    local core = require 'core.rename'
    local uri  = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local result = core.rename(uri, offset, params.newName)
    if not result then
        return nil
    end
    local workspaceEdit = {
        changes = {},
    }
    for _, info in ipairs(result) do
        local ruri   = info.uri
        local rlines = files.getLines(ruri)
        local rtext  = files.getText(ruri)
        if not workspaceEdit.changes[ruri] then
            workspaceEdit.changes[ruri] = {}
        end
        local textEdit = define.textEdit(define.range(rlines, rtext, info.start, info.finish), info.text)
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
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local result = core.prepareRename(uri, offset)
    if not result then
        return nil
    end
    return {
        range       = define.range(lines, text, result.start, result.finish),
        placeholder = result.text,
    }
end)

proto.on('textDocument/completion', function (params)
    --log.info(util.dump(params))
    local core = require 'core.completion'
    --log.debug('completion:', params.context and params.context.triggerKind, params.context and params.context.triggerCharacter)
    local uri  = params.textDocument.uri
    if not files.exists(uri) then
        return nil
    end
    await.setPriority(1000)
    local clock  = os.clock()
    local lines  = files.getLines(uri)
    local text   = files.getText(uri)
    local offset = define.offset(lines, text, params.position)
    local result = core.completion(uri, offset)
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
            sortText         = ('%04d'):format(i),
            insertText       = res.insertText,
            insertTextFormat = res.insertTextFormat,
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
                    version = files.globalVersion,
                    id      = res.id,
                }
            end
        end
        items[i] = item
    end
    return items
end)

proto.on('completionItem/resolve', function (item)
    local core = require 'core.completion'
    if not item.data then
        return item
    end
    local globalVersion = item.data.version
    local id = item.data.id
    if globalVersion ~= files.globalVersion then
        return item
    end
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
    return item
end)
