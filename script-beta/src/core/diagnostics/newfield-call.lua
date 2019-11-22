local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local lines = files.getLines(uri)
    local text  = files.getText(uri)

    guide.eachSourceType(ast.ast, 'table', function (source)
        for i = 1, #source do
            local field = source[i]
            if field.type == 'call' then
                local func = field.node
                local args = field.args
                if args then
                    local funcLine = guide.positionOf(lines, func.finish)
                    local argsLine = guide.positionOf(lines, args.start)
                    if argsLine > funcLine then
                        callback {
                            start   = field.start,
                            finish  = field.finish,
                            message = lang.script('DIAG_PREFIELD_CALL'
                                , text:sub(func.start, func.finish)
                                , text:sub(args.start, args.finish)
                            )
                        }
                    end
                end
            end
        end
    end)
end
