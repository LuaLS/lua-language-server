local matcher = require 'matcher'

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return {}
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    do return end
    return {
        activeSignature = 0,
        activeParameter = 1,
        signatures = {
            {
                label = 'xxxx(a, b, c)',
                documentation = {
                    kind = 'markdown',
                    value = '函数说明',
                },
                parameters = {
                    {
                        label = 'a',
                        documentation = {
                            kind = 'markdown',
                            value = '参数a说明',
                        },
                    },
                    {
                        label = 'b',
                        documentation = {
                            kind = 'markdown',
                            value = '参数b说明',
                        },
                    },
                    {
                        label = 'c',
                        documentation = {
                            kind = 'markdown',
                            value = '参数c说明',
                        },
                    },
                },
            },
        }
    }
end
