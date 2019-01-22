return function (lsp, params)
    local doc = params.textDocument
    lsp:close(doc.uri)
    return true
end
