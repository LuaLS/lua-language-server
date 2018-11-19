return function (lsp, params)
    local doc = params.textDocument
    log.debug('打开文件：', doc.uri)
    lsp:saveText(doc.uri, doc.version, doc.text)
    return true
end
