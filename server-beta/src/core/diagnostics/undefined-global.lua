local files    = require 'files'
local guide    = require 'parser.guide'
local searcher = require 'searcher'
local define   = require 'proto.define'
local lang     = require 'language'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local hasSet = {}
    searcher.eachGlobal(ast.ast, function (info)
        local key = info.key
        if hasSet[key] ~= nil then
            return
        end
        hasSet[key] = false
        searcher.eachRef(info.source, function (info)
            if info.mode == 'set' then
                hasSet[key] = true
            end
        end)
    end)
    searcher.eachGlobal(ast.ast, function (info)
        local source = info.source
        if info.mode == 'get' and not hasSet[info.key] then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_UNDEF_GLOBAL', info.key),
            }
        end
    end)
end
