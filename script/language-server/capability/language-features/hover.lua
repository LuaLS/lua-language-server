local markdown = require 'tools.markdown'

ls.capability.registerCapability.hoverProvider = true

ls.capability.register('textDocument/hover', function (server, params, task)
    ---@cast params LSP.HoverParams

    local uri = params.textDocument.uri
    local document = ls.scope.findDocument(uri)
    if not document then
        return
    end

    local sources = ls.scope.findSources(uri, document:at(params.position))
    local source = sources and sources[1]
    if not source then
        return
    end

    ---@type LSP.Hover
    local hover = {
        contents = {
            kind  = 'markdown',
            value = markdown.create()
                : append('lua', source.code)
                : string(),
        },
        range = document:rangeOf(source.start, source.finish)
    }

    task:resolve(hover)
end)
