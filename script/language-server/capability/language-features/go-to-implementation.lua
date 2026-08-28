ls.capability.registerCapability.implementationProvider = {
    workDoneProgress = true,
}

---@async
ls.capability.register('textDocument/implementation', function (server, params, task)
    ---@cast params LSP.ImplementationParams

    local uri = params.textDocument.uri
    local document, scope = ls.scope.findDocument(uri)
    if not document or not scope then
        return
    end

    local dconverter = document:makeLSPConverter(server.positionEncoding)

    local results = ls.feature.implementation(uri, dconverter:at(params.position))
    local locations = {}

    local sconverter = scope:makeLSPConverter(server.positionEncoding)
    local linkSupport = server.client.capabilities.textDocument?.implementation?.linkSupport
    for _, res in ipairs(results) do
        if linkSupport then
            local link = sconverter:locationLink(res)
            if link and res.originRange then
                -- originRange 位于请求文件中，需用请求文件的 converter 转换
                link.originSelectionRange = dconverter:range(res.originRange)
            end
            locations[#locations+1] = link
        else
            locations[#locations+1] = sconverter:location(res)
        end
    end

    if #locations == 0 then
        return
    end

    task:resolve(locations)
end)
