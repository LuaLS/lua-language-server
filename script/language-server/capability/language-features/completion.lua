ls.capability.registerCapability.completionProvider = {
    resolveProvider = true,
    completionItem = {
        labelDetailsSupport = true,
    }
}

---@async
ls.capability.register('textDocument/completion', function (server, params, task)
    ---@cast params LSP.CompletionParams

    -- 0.1秒防抖
    ls.await.sleep(0.1)

    local uri = params.textDocument.uri
    local document = ls.scope.findDocument(uri)
    if not document then
        return
    end

    local converter = document:makeLSPConverter(server.positionEncoding)
    local byteOffset = converter:at(params.position)

    local items = ls.feature.completion(uri, byteOffset)

    -- 将 CompletionItem[] 转换为 LSP.CompletionItem[]（用正确编码的 range 替换字节偏移）
    ---@param item CompletionItem
    ---@return LSP.CompletionItem
    local function toLSPItem(item)
        local te   = item.textEdit
        local ates = item.additionalTextEdits

        ---@type LSP.TextEdit?
        local lspTE
        if te then
            lspTE = { range = converter:range(te.start, te.finish), newText = te.newText }
        end

        ---@type LSP.TextEdit[]?
        local lspAtes
        if ates then
            lspAtes = {}
            for j, ate in ipairs(ates) do
                lspAtes[j] = { range = converter:range(ate.start, ate.finish), newText = ate.newText }
            end
        end

        ---@type LSP.CompletionItem
        return {
            label               = item.label,
            labelDetails        = item.labelDetails,
            kind                = item.kind,
            tags                = item.tags,
            detail              = item.detail,
            documentation       = item.documentation,
            deprecated          = item.deprecated,
            preselect           = item.preselect,
            sortText            = item.sortText,
            filterText          = item.filterText,
            insertText          = item.insertText,
            insertTextFormat    = item.insertTextFormat,
            insertTextMode      = item.insertTextMode,
            textEdit            = lspTE,
            textEditText        = item.textEditText,
            additionalTextEdits = lspAtes,
            commitCharacters    = item.commitCharacters,
            command             = item.command,
            data                = item.data,
        }
    end

    ---@type LSP.CompletionItem[]
    local lspItems = {}
    for i, item in ipairs(items) do
        lspItems[i] = toLSPItem(item)
    end

    if #lspItems == 0 then
        return
    end

    task:resolve(lspItems)
end)

ls.capability.register('completionItem/resolve', function (server, params, task)
    ---@cast params LSP.CompletionItem

    task:resolve(params)
end)
