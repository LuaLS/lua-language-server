local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local await  = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'function', function (source)
        await.delay()
        local returns = source.returns
        if not returns then
            return
        end
        local min = vm.countReturnsOfSource(source)
        if min == 0 then
            return
        end
        for _, ret in ipairs(returns) do
            local rmin, rmax = vm.countList(ret)
            if rmax < min then
                if rmin == rmax then
                    callback {
                        start   = ret.start,
                        finish  = ret.start + #'return',
                        message = lang.script('DIAG_MISSING_RETURN_VALUE', {
                            min  = min,
                            rmax = rmax,
                        }),
                    }
                else
                    callback {
                        start   = ret.start,
                        finish  = ret.start + #'return',
                        message = lang.script('DIAG_MISSING_RETURN_VALUE_RANGE', {
                            min  = min,
                            rmin = rmin,
                            rmax = rmax,
                        }),
                    }
                end
            end
        end
    end)
end
