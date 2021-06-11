local files  = require 'files'
local define = require 'proto.define'
local lang   = require 'language'
local guide  = require 'parser.guide'

return function (uri, callback, code)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local last

    local function checkSet(source)
        if source.value then
            last = source
        else
            if not last then
                return
            end
            if  last.start       <= source.start
            and last.value.start >= source.finish then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    message = lang.script('DIAG_UNBALANCED_ASSIGNMENTS')
                }
            else
                last = nil
            end
        end
    end

    guide.eachSource(ast.ast, function (source)
        if source.type == 'local'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'setfield'
        or source.type == 'setindex' then
            checkSet(source)
        end
    end)
end
