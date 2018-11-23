return function (lsp, params)
    local doc = params.textDocument
    log.debug('Open file:', doc.uri)
    lsp:saveText(doc.uri, doc.version, doc.text)
    return true
end
