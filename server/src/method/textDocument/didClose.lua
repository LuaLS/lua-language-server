return function (lsp, params)
    local doc = params.textDocument
    lsp:removeText(doc.uri, doc.version)
    lsp:close(doc.uri)
    return true
end
