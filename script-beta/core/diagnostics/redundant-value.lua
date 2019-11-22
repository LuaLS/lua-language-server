local files  = require 'files'
local define = require 'proto.define'
local lang   = require 'language'

return function (uri, callback, code)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local diags = ast.diags[code]
    if not diags then
        return
    end

    for _, info in ipairs(diags) do
        callback {
            start   = info.start,
            finish  = info.finish,
            tags    = { define.DiagnosticTag.Unnecessary },
            message = lang.script('DIAG_OVER_MAX_VALUES', info.max, info.passed)
        }
    end
end
