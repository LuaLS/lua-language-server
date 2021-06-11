local files  = require 'files'
local guide  = require 'parser.guide'
local define = require 'proto.define'
local lang   = require 'language'

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    guide.eachSourceType(ast.ast, 'label', function (source)
        if not source.ref then
            callback {
                start   = source.start,
                finish  = source.finish,
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script('DIAG_UNUSED_LABEL', source[1]),
            }
        end
    end)
end
