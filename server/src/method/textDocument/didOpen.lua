return function (lsp, params)
    local doc = params.textDocument
    lsp:open(doc.uri, doc.version, doc.text)
    return true
end
