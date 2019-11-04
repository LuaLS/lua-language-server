local util      = require 'utility'
local cap       = require 'proto.capability'
local task      = require 'task'
local files     = require 'files'
local proto     = require 'proto.proto'
local interface = require 'proto.interface'
local workspace = require 'workspace'
local config    = require 'config'

local function updateConfig()
    local configs = proto.request('workspace/configuration', {
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
    end
    if not util.equal(oldConfig.diagnostics, newConfig.diagnostics) then
    end
    if newConfig.completion.enable then
    else
    end
    if not util.equal(oldConfig.plugin, newConfig.plugin) then
    end
    if not util.equal(oldConfig.workspace, newConfig.workspace)
    or not util.equal(oldConfig.plugin, newConfig.plugin)
    or not util.equal(oldOther.associations, newOther.associations)
    or not util.equal(oldOther.exclude, newOther.exclude)
    then
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
    proto.request('client/registerCapability', {
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
    task.create(function ()
        workspace.preload()
    end)
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
    files.setText(uri, text)
end)

proto.on('textDocument/hover', function ()
    return {
        contents = {
            value = 'Hello loli!',
            kind  = 'markdown',
        }
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
    local offset = interface.offset(lines, text, params.position)
    local result = core(uri, offset)
    if not result then
        return nil
    end
    local response = {}
    for i, info in ipairs(result) do
        local targetUri = info.uri
        local targetLines = files.getLines(targetUri)
        response[i] = interface.locationLink(targetUri
            , interface.range(targetLines, text, info.target.start - 1, info.target.finish)
            , interface.range(targetLines, text, info.target.start - 1, info.target.finish)
            , interface.range(lines      , text, info.source.start - 1, info.source.finish)
        )
    end
    return response
end)
