local core = require 'core'

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    local hovers = core.signature(vm, position)
    if not hovers then
        return
    end

    local signatures = {}
    for i, hover in ipairs(hovers) do
        signatures[i] = {
            label = hover.label,
            documentation = {
                kind = 'markdown',
                value = hover.description,
            },
            parameters = {
                {
                    label = hover.argLabel,
                },
            },
        }
    end

    local response = {
        signatures = signatures,
        activeSignature = #signatures - 1,
    }

    return response
end
