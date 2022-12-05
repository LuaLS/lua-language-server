local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'
local await = require 'await'

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    ---@async
    guide.eachSourceType(ast.ast, 'local', function (source)
        local name = source[1]
        if name == '_'
        or name == ast.ENVMode then
            return
        end
        await.delay()
        local exist = guide.getLocal(source, name, source.start-1)
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
