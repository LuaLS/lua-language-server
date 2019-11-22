local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    local lines = files.getLines(uri)

    guide.eachSourceType(ast.ast, 'call', function (source)
        local node = source.node
        local args = source.args
        if not args then
            return
        end

        -- 必须有其他人在继续使用当前对象
        if not source.next then
            return
        end

        local nodeRow = guide.positionOf(lines, node.finish)
        local argRow  = guide.positionOf(lines, args.start)
        if nodeRow == argRow then
            return
        end

        if #args == 1 then
            callback {
                start   = args.start,
                finish  = args.finish,
                message = lang.script.DIAG_PREVIOUS_CALL,
            }
        end
    end)
end
