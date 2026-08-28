ls.capability.registerCapability.referencesProvider = {
    workDoneProgress = true,
}

---@async
ls.capability.register('textDocument/references', function (server, params, task)
    ---@cast params LSP.ReferenceParams

    local uri = params.textDocument.uri
    local document, scope = ls.scope.findDocument(uri)
    if not document or not scope then
        return
    end

    local dconverter = document:makeLSPConverter(server.positionEncoding)

    local prog <close> = ls.progress.create(uri, '正在查找引用', 0.5)

    local results = ls.feature.references(uri, dconverter:at(params.position), params.context?.includeDeclaration)
    if #results == 0 then
        return
    end

    local sconverter = scope:makeLSPConverter(server.positionEncoding)
    local locations = {}
    for _, res in ipairs(results) do
        locations[#locations+1] = sconverter:location(res)
    end

    task:resolve(locations)
end)
