local files  = require 'files'
local guide  = require 'parser.guide'
local define = require 'proto.define'
local lang   = require 'language'

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    guide.eachSourceType(ast.ast, 'function', function (source)
        local args = source.args
        if not args then
            return
        end

        for _, arg in ipairs(args) do
            if arg.type == '...' then
                if not arg.ref then
                    callback {
                        start   = arg.start,
                        finish  = arg.finish,
                        tags    = { define.DiagnosticTag.Unnecessary },
                        message = lang.script.DIAG_UNUSED_VARARG,
                    }
                end
            end
        end
    end)
end
