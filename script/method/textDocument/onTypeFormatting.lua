--- @param lsp LSP
--- @param params table
--- @return any
return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    --log.debug(table.dump(params))
    if not vm then
        return nil
    end
    local position = lines:position(params.position.line + 1, params.position.character)
    local ch = params.ch
    local options = params.options
    local tabSize = options.tabSize
    local insertSpaces = options.insertSpaces
    return nil
end
