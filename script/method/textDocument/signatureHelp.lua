local core = require 'core'
local config = require 'config'

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    if not config.config.signatureHelp.enable then
        return
    end
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

    local hover = hovers[1]
    local desc = {}
    desc[#desc+1] = hover.description
    desc[#desc+1] = hover.doc
    local active
    local signatures = {}
    for i, hover in ipairs(hovers) do
        local signature = {
            label = hover.label,
            documentation = {
                kind = 'markdown',
                value = table.concat(desc, '\n\n'),
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
