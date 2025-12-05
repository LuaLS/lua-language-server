ls.capability.registerCapability.definitionProvider = true

ls.capability.register('textDocument/definition', function (server, params, task)
    ---@cast params LSP.DefinitionParams

    local uri = params.textDocument.uri
    local document, scope = ls.scope.findDocument(uri)
    if not document or not scope then
        return
    end

    local dconverter = document:makeLSPConverter(server.positionEncoding)

    local results = ls.feature.definition(uri, dconverter:at(params.position))
    local locations = {}

    local sconverter = scope:makeLSPConverter(server.positionEncoding)
    local linkSupport = server.client.capabilities.textDocument.definition.linkSupport
    for _, res in ipairs(results) do
        if linkSupport then
            locations[#locations+1] = sconverter:locationLink(res)
        else
            locations[#locations+1] = sconverter:location(res)
        end
    end

    if #locations == 0 then
        return
    end

    task:resolve(locations)
end)
