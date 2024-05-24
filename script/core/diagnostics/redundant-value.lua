local files  = require 'files'
local define = require 'proto.define'
local lang   = require 'language'
local guide  = require 'parser.guide'
local await  = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    local delayer = await.newThrottledDelayer(50000)
    guide.eachSource(state.ast, function (src) ---@async
        delayer:delay()
        if src.redundant then
            callback {
                start   = src.start,
                finish  = src.finish,
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script('DIAG_OVER_MAX_VALUES', src.redundant.max, src.redundant.passed)
            }
        end
    end)
end
