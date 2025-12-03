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
        local inferred = vm.getInfer(source):view(uri)
        if inferred ~= 'unknown' then return end
        local functionType = vm.getInfer(source.node)
        if functionType:view(uri) == 'unknown' then return end -- we can't say anything about what unknown types support
        local operators = vm.getOperators("call", source.node)
        local canCall = functionType:hasFunction(uri) or #operators ~= 0
        if canCall then return end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UNKNOWN_OPERATION_CALL', functionType:view(uri)),
        }
    end)
end
