return function (lsp, params)
    local doc = params.textDocument
    log.debug('Close file:', doc.uri)
    lsp:removeText(doc.uri, doc.version)
    return true
end
