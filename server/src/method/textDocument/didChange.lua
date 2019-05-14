return function (lsp, params)
    local doc = params.textDocument
    local change = params.contentChanges
    if lsp.workspace then
        local path = lsp.workspace:relativePathByUri(doc.uri)
        if not lsp.workspace:isLuaFile(path) then
            return
        end
        if not lsp:isOpen(doc.uri) and lsp.workspace.gitignore(path:string()) then
            return
        end
    end
    -- TODO 支持差量更新
    lsp:saveText(doc.uri, doc.version, change[1].text)
    return true
end
