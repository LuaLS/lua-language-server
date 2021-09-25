local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local text  = files.getText(uri)

    guide.eachSourceType(ast.ast, 'table', function (source)
        for i = 1, #source do
            local field = source[i]
            if field.type ~= 'tableexp' then
                goto CONTINUE
            end
            local call = field.value
            if not call then
                goto CONTINUE
            end
            if call.type ~= 'call' then
                return
            end
            local func = call.node
            local args = call.args
            if args then
                local funcLine = guide.rowColOf(func.finish)
                local argsLine = guide.rowColOf(args.start)
                if argsLine > funcLine then
                    callback {
                        start   = call.start,
                        finish  = call.finish,
                        message = lang.script('DIAG_PREFIELD_CALL'
                            , text:sub(func.start, func.finish)
                            , text:sub(args.start, args.finish)
                        )
                    }
                end
            end
            ::CONTINUE::
        end
    end)
end
