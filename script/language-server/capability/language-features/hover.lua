local markdown = require 'tools.markdown'

ls.capability.registerCapability.hoverProvider = true

ls.capability.register('textDocument/hover', function (server, params, task)
    ---@cast params LSP.HoverParams

    local uri = params.textDocument.uri
    local document = ls.scope.findDocument(uri)
    if not document then
        return
    end
    local converter = document:makeLSPConverter(server.positionEncoding)

    local sources, scope = ls.scope.findSources(uri, converter:at(params.position))
    local source = sources and sources[1]
    if not source or not scope then
        return
    end

    local type = scope.vm:getNode(source)
    local view
    if type then
        view = type:view()
    else
        view = source.code
    end

    ---@type LSP.Hover
    local hover = {
        contents = {
            kind  = 'markdown',
            value = markdown.create()
                : append('lua', view)
                : string(),
        },
        range = converter:range(source.start, source.finish)
    }

    task:resolve(hover)
end)
