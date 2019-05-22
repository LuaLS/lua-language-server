local core = require 'core'

return function (lsp, params)
    local uri = params.textDocument.uri
    local diagnostics = params.context.diagnostics

    local results = core.codeAction(lsp, uri, diagnostics)

    if #results == 0 then
        return nil
    end

    return results
end
