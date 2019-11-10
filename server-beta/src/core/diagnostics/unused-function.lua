local files    = require 'files'
local guide    = require 'parser.guide'
local searcher = require 'searcher'
local define = require 'proto.define'
local lang   = require 'language'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    guide.eachSourceType(ast.ast, 'function', function (source)
        local hasSet
        local hasGet = searcher.eachRef(source, function (info)
            if     info.mode == 'get' then
                return true
            elseif info.mode == 'set'
            or     info.mode == 'declare' then
                hasSet = true
            end
        end)
        if not hasGet and hasSet then
            callback {
                start   = source.start,
                finish  = source.finish,
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script.DIAG_UNUSED_FUNCTION,
            }
        end
    end)
end
