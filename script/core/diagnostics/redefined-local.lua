local files = require 'files'
local searcher = require 'core.searcher'
local lang  = require 'language'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    searcher.eachSourceType(ast.ast, 'local', function (source)
        local name = source[1]
        if name == '_'
        or name == ast.ENVMode then
            return
        end
        local exist = searcher.getLocal(source, name, source.start-1)
        if exist then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_REDEFINED_LOCAL', name),
                related = {
                    {
                        start  = exist.start,
                        finish = exist.finish,
                        uri    = uri,
                    }
                },
            }
        end
    end)
end
