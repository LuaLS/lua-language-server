local util      = require 'utility'
local cap       = require 'proto.capability'
local pub       = require 'pub'
local task      = require 'task'
local files     = require 'files'
local proto     = require 'proto.proto'
local interface = require 'proto.interface'

proto.on('initialize', function (params)
    --log.debug(util.dump(params))
    return {
        capabilities = cap.initer,
    }
end)

proto.on('initialized', function (params)
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
    local clock  = os.clock()
    local core   = require 'core.definition'
    local uri    = params.textDocument.uri
    local ast    = files.getAst(uri)
    local text   = files.getText(uri)
    local offset = interface.offset(ast.lines, text, params.position)
    local result, correct
    repeat
        result, correct = core(ast, text, offset)
    until correct or os.clock() - clock >= 1.0
end)
