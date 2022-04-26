local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'getlocal', function (src)
        local checkNil
        local nxt = src.next
        if nxt then
            if nxt.type == 'getfield'
            or nxt.type == 'getmethod'
            or nxt.type == 'getindex'
            or nxt.type == 'call' then
                checkNil = true
            end
        end
        local call = src.parent
        if call and call.type == 'call' and call.node == src then
            checkNil = true
        end
        if not checkNil then
            return
        end
        local node = vm.compileNode(src)
        if node:hasFalsy() then
            callback {
                start   = src.start,
                finish  = src.finish,
                message = lang.script('DIAG_NEED_CHECK_NIL'),
            }
        end
    end)
end
