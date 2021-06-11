local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local infer   = require 'core.infer'

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    guide.eachSource(ast.ast, function (source)
        if  source.type ~= 'local'
        and source.type ~= 'setlocal'
        and source.type ~= 'setglobal'
        and source.type ~= 'getglobal'
        and source.type ~= 'setfield'
        and source.type ~= 'setindex'
        and source.type ~= 'tablefield'
        and source.type ~= 'tableindex' then
            return
        end
        if infer.searchAndViewInfers(source) == 'any' then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_IMPLICIT_ANY'),
            }
        end
    end)
end
