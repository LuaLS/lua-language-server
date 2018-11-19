return function (lsp, params)
    local doc = params.textDocument
    local change = params.contentChanges
    log.debug('更新文件：', doc.uri)
    -- TODO 支持差量更新
    lsp:saveText(doc.uri, doc.version, change[1].text)
    return true
end
