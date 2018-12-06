return function (lsp, params)
    local doc = params.textDocument
    --lsp:removeText(doc.uri, doc.version)
    return true
end
