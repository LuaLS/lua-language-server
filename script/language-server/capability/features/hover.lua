local markdown = require 'tools.markdown'

ls.capability.serverCapabilities.hoverProvider = true

ls.capability.register('textDocument/hover', function (server, params, task)
    ---@cast params LSP.HoverParams

    local uri = params.textDocument.uri

    ---@type LSP.Hover
    local hover = {
        contents = {
            kind  = 'markdown',
            value = markdown.create()
                : append('lua', ls.inspect(params))
                : string(),
        }
    }

    task:resolve(hover)
end)
