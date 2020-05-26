--- @param lsp LSP
--- @param params table
--- @return boolean
return function (lsp, params)
    local doc = params.textDocument
    lsp:close(doc.uri)
    return true
end
