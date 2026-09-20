---@class Tools.MemoryGuard
local m = {}

local HOOK_COUNT = 100000

---@type function?
m.hook = nil

---@return boolean
function m.isEnabled()
    return m.hook ~= nil
end

---@param memLimitGB? number
---@return boolean
function m.enable(memLimitGB)
    if m.hook then
        return false
    end
    if not memLimitGB or memLimitGB <= 0 then
        return false
    end
    if debug.gethook() then
        return false
    end

    local memLimitKB = memLimitGB * 1024 * 1024
    local hook = function ()
        local heapKB = collectgarbage('count')
        if heapKB > memLimitKB then
            io.write(('[MEMORY GUARD] (%s) Lua heap %.1f GB exceeded limit %.1f GB, force exit\n')
                :format(ls.threadName or 'master', heapKB / 1024 / 1024, memLimitKB / 1024 / 1024))
            io.flush()
            os.exit(1)
        end
    end

    local mask  = ''
    local count = HOOK_COUNT

    debug.sethook(hook, mask, count)
    m.hook = hook

    local rawCreate = coroutine.create

    local function attach(co)
        debug.sethook(co, hook, mask, count)
        return co
    end

    coroutine.create = function (f)
        return attach(rawCreate(f))
    end

    coroutine.wrap = function (f)
        local co = attach(rawCreate(f))
        return function (...)
            local results = table.pack(coroutine.resume(co, ...))
            if not results[1] then
                error(results[2], 0)
            end
            return table.unpack(results, 2, results.n)
        end
    end

    return true
end

return m
