local method = {}

local function init(name)
    method[name] = require('method.' .. name:gsub('/', '.'))
end

init 'exit'
init 'initialize'
init 'initialized'
init 'shutdown'
init 'textDocument/definition'
init 'textDocument/didOpen'
init 'textDocument/didChange'
init 'textDocument/didClose'
init 'textDocument/implementation'
init 'textDocument/rename'
init 'textDocument/references'

return method
