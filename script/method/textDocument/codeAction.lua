local core = require 'core'

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:getVM(uri)
    if not vm then
        return
    end
    local diagnostics = params.context.diagnostics
    local range = params.range

    local results = core.codeAction(lsp
        , uri
        , diagnostics
        , range
    )

    if #results == 0 then
        return nil
    end

    return results
end
