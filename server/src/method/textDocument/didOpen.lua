return function (lsp, params)
    local doc = params.textDocument
    lsp:saveText(doc.uri, doc.version, doc.text)
    lsp:open(doc.uri)
    return true
end
