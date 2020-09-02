local method = {}

local function init(name)
    method[name] = require('method.' .. name:gsub('/', '.'))
end

init 'exit'
init 'initialize'
init 'initialized'
init 'shutdown'
init 'completionItem/resolve'
init 'textDocument/codeAction'
init 'textDocument/completion'
init 'textDocument/definition'
init 'textDocument/didOpen'
init 'textDocument/didChange'
init 'textDocument/didClose'
init 'textDocument/documentHighlight'
init 'textDocument/documentSymbol'
init 'textDocument/foldingRange'
init 'textDocument/hover'
init 'textDocument/implementation'
init 'textDocument/onTypeFormatting'
init 'textDocument/publishDiagnostics'
init 'textDocument/rename'
init 'textDocument/references'
init 'textDocument/semanticTokens/full'
init 'textDocument/signatureHelp'
init 'workspace/didChangeConfiguration'
init 'workspace/didChangeWatchedFiles'
init 'workspace/didChangeWorkspaceFolders'
init 'workspace/executeCommand'
init 'workspace/symbol'

return method
