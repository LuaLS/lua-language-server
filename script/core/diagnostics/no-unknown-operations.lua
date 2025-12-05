local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'
local vm    = require 'vm'
local await = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then return end
    -- TODO: no-unknown doesn't do this but missing-local-export-doc does, is this actually needed?
    if not state.ast then return end

    -- calls are complicated because unknown arguments may or may not cause an introduction of an unknown type
    -- integer(unknown) :: unknown should count as introducing an unknown, but function(unknown) :: unknown should not. We can't directly
    -- check function because it might be overloaded or have a call operator defined.
    ---@async
    guide.eachSourceType(state.ast, 'call', function (source)
        await.delay()

        local resultInfer = vm.getInfer(source):view(uri)
        if resultInfer ~= 'unknown' then return end
        local functionType = vm.getInfer(source.node)
        if functionType:view(uri) == 'unknown' then return end -- we can't say anything about what unknown types support
        if functionType:isCallable(uri) then return end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UNKNOWN_OPERATION_CALL', functionType:view(uri)),
        }
    end)

    -- binary operators are quite similar to function calls, they introduce an unknown if the result is unknown and none of the
    -- parameters are unknown, or if the left side is known to not implement the operator

    ---@async
    guide.eachSourceType(state.ast, 'binary', function (source)
        await.delay()

        local resultInfer = vm.getInfer(source)
        if resultInfer:view(uri) ~= 'unknown' then return end
        local left, right = source[1], source[2]
        local leftInfer, rightInfer = vm.getInfer(left), vm.getInfer(right)
        if leftInfer:view(uri) == 'unknown' then return end
        if rightInfer:view(uri) ~= 'unknown' then
            -- the operator doesn't work for these types
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_UNKNOWN_OPERATION_OPERATOR', source.op.type, leftInfer:view(uri), rightInfer:view(uri)),
            }
            return
        end

        -- TODO: it seems that if the operator is defined and the other arg is unkown it is always inferred as the
        -- return type of the operator, so we can't check that case currently
    end)
end
