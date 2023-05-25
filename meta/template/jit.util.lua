---#if not JIT then DISABLE() end
---@meta jit.util

---@class Trace
---@class Proto

local util = {}

---@class jit.funcinfo.lua
local funcinfo = {
    linedefined = 0,
    lastlinedefined = 0,
    stackslots = 0,
    params = 0,
    bytecodes = 0,
    gcconsts = 0,
    nconsts = 0,
    upvalues = 0,
    currentline = 0,
    isvararg = false,
    children = false,
    source = "",
    loc = "",
    ---@type Proto[]
    proto = {}
}

---@class jit.funcinfo.c
---@field ffid integer|nil
local funcinfo2 = {
    addr = 0,
    upvalues = 0,
}


---@param func function
---@param pc? integer
---@return jit.funcinfo.c|jit.funcinfo.lua info
function util.funcinfo(func, pc)
end

---@param func function
---@param pc integer
---@return integer? ins
---@return integer? m
function util.funcbc(func, pc)
end

---@param func function
---@param idx integer
---@return any? k
function util.funck(func, idx)
end

---@param func function
---@param idx integer
---@return string? name
function util.funcuvname(func, idx)
end

---@class jit.traceinfo
local traceinfo = {
    nins = 0,
    nk = 0,
    link = 0,
    nexit = 0,
    linktype = ""
}

---@param tr Trace
---@return jit.traceinfo? info
function util.traceinfo(tr)
end

---@param tr Trace
---@param ref integer
---@return integer? m
---@return integer? ot
---@return integer? op1
---@return integer? op2
---@return integer? prev
function util.traceir(tr, ref)
end

---@param tr Trace
---@param idx integer
---@return any? k
---@return integer? t
---@return integer? slot
function util.tracek(tr, idx)
end

---@class jit.snap : integer[]

---@param tr Trace
---@param sn integer
---@return jit.snap? snap
function util.tracesnap(tr, sn)
end

---@param tr Trace
---@return string? mcode
---@return integer? addr
---@return integer? loop
function util.tracemc(tr)
end

---@overload fun(exitno: integer): integer
---@param tr Trace
---@param exitno integer
---@return integer? addr
function util.traceexitstub(tr, exitno)
end

---@param idx integer
---@return integer? addr
function util.ircalladdr(idx)
end

return util
