local files  = require 'files'
local guide  = require 'parser.guide'
local define = require 'proto.define'
local lang   = require 'language'
local vm     = require 'vm'

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    if vm.isMetaFile(uri) then
        return
    end

    guide.eachSourceType(ast.ast, 'function', function (source)
        if #source == 0 then
            return
        end
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
