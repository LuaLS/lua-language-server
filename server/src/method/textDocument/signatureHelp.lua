local core = require 'core'

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return
    end
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    local hovers = core.signature(vm, position)
    if not hovers then
        return
    end

    local description = hovers[1].description
    table.sort(hovers, function (a, b)
        return a.label < b.label
    end)

    local active
    local signatures = {}
    for i, hover in ipairs(hovers) do
        local signature = {
            label = hover.label,
            documentation = {
                kind = 'markdown',
                value = hover.description,
            },
        }
        if hover.argLabel then
            if not active then
                active = i
            end
            signature.parameters = {
                {
                    label = {
                        hover.argLabel[1] - 1,
                        hover.argLabel[2],
                    }
                }
            }
        end
        signatures[i] = signature
    end

    local response = {
        signatures = signatures,
        activeSignature = active and active - 1 or 0,
    }

    return response
end
