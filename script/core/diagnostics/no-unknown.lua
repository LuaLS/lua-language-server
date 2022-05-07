local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local vm      = require 'vm'

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
        if vm.getInfer(source):view() == 'unknown' then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_UNKNOWN'),
            }
        end
    end)
end
