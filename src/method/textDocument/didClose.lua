return function (lsp, params)
    local doc = params.textDocument
    log.debug('关闭文件：', doc.uri)
    lsp:removeText(doc.uri, doc.version)
    return true
end
