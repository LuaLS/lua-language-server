---#if not JIT then DISABLE() end
---@meta jit.profile

local profile = {}

---@param mode string
---@param func fun(L: thread, samples: integer, vmst: string)
function profile.start(mode, func)
end

function profile.stop()
end

---@overload fun(th: thread, fmt: string, depth: integer)
---@param fmt string
---@param depth integer
function profile.dumpstack(fmt, depth)
end

return profile