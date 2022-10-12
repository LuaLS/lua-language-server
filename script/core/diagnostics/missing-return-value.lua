local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local await  = require 'await'

---@param func parser.object
---@return integer
local function getReturnsMin(func)
    local min = vm.countReturnsOfFunction(func, true)
    if min == 0 then
        return 0
    end
    for _, doc in ipairs(func.bindDocs) do
        if doc.type == 'doc.overload' then
            local n = vm.countReturnsOfFunction(doc.overload)
            if n == 0 then
                return 0
            end
            if n < min then
                min = n
            end
        end
    end
    return min
end

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
        local min = getReturnsMin(source)
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
