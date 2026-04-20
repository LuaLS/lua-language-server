ls.capability.registerCapability.hoverProvider = true

---@async
ls.capability.register('textDocument/hover', function (server, params, task)
    ---@cast params LSP.HoverParams

    local uri = params.textDocument.uri
    local document = ls.scope.findDocument(uri)
    if not document then
        return
    end
    local converter = document:makeLSPConverter(server.positionEncoding)

    local result = ls.feature.hover(uri, converter:at(params.position))
    if not result then
        return
    end

    local source = result.source

    ---@type LSP.Hover
    local hover = {
        contents = {
            kind  = 'markdown',
            value = result.value,
        },
        range = converter:range(source.start, source.finish)
    }

    task:resolve(hover)
end)
