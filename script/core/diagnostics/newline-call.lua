local files = require 'files'
local searcher = require 'core.searcher'
local lang  = require 'language'

return function (uri, callback)
    local ast   = files.getAst(uri)
    local lines = files.getLines(uri)
    local text  = files.getText(uri)
    if not ast or not lines then
        return
    end

    searcher.eachSourceType(ast.ast, 'call', function (source)
        local node = source.node
        local args = source.args
        if not args then
            return
        end

        -- 必须有其他人在继续使用当前对象
        if not source.next then
            return
        end
        if text:sub(args.start, args.start)   ~= '('
        or text:sub(args.finish, args.finish) ~= ')' then
            return
        end

        local nodeRow = searcher.positionOf(lines, node.finish)
        local argRow  = searcher.positionOf(lines, args.start)
        if nodeRow == argRow then
            return
        end

        if #args == 1 then
            callback {
                start   = node.start,
                finish  = args.finish,
                message = lang.script('DIAG_PREVIOUS_CALL', text:sub(node.start, node.finish), text:sub(args.start, args.finish)),
            }
        end
    end)
end
