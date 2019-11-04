local files  = require 'files'
local guide  = require 'parser.guide'
local define = require 'proto.define'
local lang   = require 'language'

local function hasGet(loc)
    if not loc.ref then
        return false
    end
    for _, ref in ipairs(loc.ref) do
        if ref.mode == 'get' then
            return true
        end
    end
    return false
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    guide.eachSourceType(ast.ast, 'local', function (source)
        local name = source[1]
        if name == '_'
        or name == '_ENV' then
            return
        end
        if not hasGet(source) then
            callback {
                start   = source.start,
                finish  = source.finish,
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script('DIAG_UNUSED_LOCAL', name),
            }
        end
    end)
end
