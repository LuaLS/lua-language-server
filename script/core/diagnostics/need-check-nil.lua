local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'
local await = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    local delayer = await.newThrottledDelayer(500)
    ---@async
    guide.eachSourceType(state.ast, 'getlocal', function (src)
        delayer:delay()
        local checkNil
        local nxt = src.next
        if nxt then
            if nxt.type == 'getfield'
            or nxt.type == 'getmethod'
            or nxt.type == 'getindex'
            or nxt.type == 'call' then
                -- 安全导航（?. / ?.( / ?.[ 等）：访问本身已判空，无需再次检查
                if not nxt.safe then
                    checkNil = true
                end
            end
        end
        local call = src.parent
        if call and call.type == 'call' and call.node == src then
            -- 安全导航调用（f?.()）：已判空，无需再次检查
            if not call.safe then
                checkNil = true
            end
        end
        local setIndex = src.parent
        if setIndex and setIndex.type == 'setindex' and setIndex.index == src then
            checkNil = true
        end
        if not checkNil then
            return
        end
        local node = vm.compileNode(src)
        if node:hasFalsy() and not vm.getInfer(src):hasType(uri, 'any') then
            callback {
                start   = src.start,
                finish  = src.finish,
                message = lang.script('DIAG_NEED_CHECK_NIL'),
            }
        end
    end)
end
