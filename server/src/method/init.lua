local method = {}

local function init(name)
    method[name] = require('method.' .. name:gsub('/', '.'))
end

init 'exit'
init 'initialize'
init 'initialized'
init 'shutdown'
init 'textDocument/completion'
init 'textDocument/definition'
init 'textDocument/didOpen'
init 'textDocument/didChange'
init 'textDocument/didClose'
init 'textDocument/hover'
init 'textDocument/implementation'
init 'textDocument/publishDiagnostics'
init 'textDocument/rename'
init 'textDocument/references'
init 'textDocument/signatureHelp'
init 'workspace/didChangeWatchedFiles'
init 'workspace/didChangeWorkspaceFolders'

return method
