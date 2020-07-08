local fn = require 'filename'

--- @param lsp LSP
--- @param params table
--- @return boolean
return function (lsp, params)
    local doc = params.textDocument
    local change = params.contentChanges
    local ws = lsp:findWorkspaceFor(doc.uri)
    if ws then
        local path = ws:relativePathByUri(doc.uri)
        if not path or not fn.isLuaFile(path) then
            return
        end
        if not lsp:isOpen(doc.uri) and ws.gitignore(path:string()) then
            return
        end
    end
    -- TODO 支持差量更新
    lsp:saveText(doc.uri, doc.version, change[1].text)
    return true
end
