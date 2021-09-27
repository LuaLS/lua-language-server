local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source)
        local node = source.node
        local args = source.args
        if not args then
            return
        end

        -- 必须有其他人在继续使用当前对象
        if not source.next then
            return
        end
        local startOffset  = guide.positionToOffset(state, args.start) + 1
        local finishOffset = guide.positionToOffset(state, args.finish)
        if text:sub(startOffset,  startOffset)  ~= '('
        or text:sub(finishOffset, finishOffset) ~= ')' then
            return
        end

        local nodeRow = guide.rowColOf(node.finish)
        local argRow  = guide.rowColOf(args.start)
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
