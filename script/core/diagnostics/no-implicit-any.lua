local files   = require 'files'
local guide   = require 'core.guide'
local lang    = require 'language'
local define  = require 'proto.define'
local vm      = require 'vm'

return function (uri, callback)
    local ast = files.getAst(uri)
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
        if vm.getInferType(source, 0) == 'any' then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_IMPLICIT_ANY'),
            }
        end
    end)
end
