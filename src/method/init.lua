local method = {}

local function init(name)
    method[name] = require('method.' .. name:gsub('/', '.'))
end

init 'initialize'
init 'textDocument/definition'
init 'textDocument/didOpen'
init 'textDocument/didChange'

return method
