local furi = require 'uri'

--- @param lsp LSP
--- @param params table
--- @return boolean
return function (lsp, params)
    local doc = params.textDocument
    if #lsp.workspaces == 0 then
        lsp:addWorkspace('root', furi.encode(furi.decode(doc.uri):parent_path()))
    end
    lsp:open(doc.uri, doc.version, doc.text)
    return true
end
