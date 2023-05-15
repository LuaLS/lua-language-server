---#if not JIT then DISABLE() end
---@meta jit

---@version JIT
---@class jitlib
---@field version     string
---@field version_num number
---@field os          'Windows'|'Linux'|'OSX'|'BSD'|'POSIX'|'Other'
---@field arch        'x86'|'x64'|'arm'|'arm64'|'arm64be'|'ppc'|'ppc64'|'ppc64le'|'mips'|'mipsel'|'mips64'|'mips64el'|string
jit = {}

---@overload fun(...):...
---@param func       function|boolean
---@param recursive? boolean
function jit.on(func, recursive)
end

---@overload fun(...):...
---@param func       function|boolean
---@param recursive? boolean
function jit.off(func, recursive)
end

---@overload fun(...):...
---@overload fun(tr: number)
---@param func       function|boolean
---@param recursive? boolean
function jit.flush(func, recursive)
end

---@return boolean status
---@return string ...
---@nodiscard
function jit.status()
end

jit.profile = {}

---@param mode string
---@param func fun(L:thread,samples:integer,vmst:string)
function jit.profile.start(mode, func)
end

function jit.profile.stop()
end

---@overload fun(th:thread,fmt:string,depth:integer)
---@param fmt string
---@param depth integer
function jit.profile.dumpstack(fmt, depth)
end

---@class Trace
---@class Proto

jit.util = {}

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
function jit.util.funcinfo(func, pc)
end

---@param func function
---@param pc integer
---@return integer? ins
---@return integer? m
function jit.util.funcbc(func, pc)
end

---@param func function
---@param idx integer
---@return any? k
function jit.util.funck(func, idx)
end

---@param func function
---@param idx integer
---@return string? name
function jit.util.funcuvname(func, idx)
end

---@class jit.traceinfo
local traceinfo = {
    nins = 0,
    nk=0,
    link=0,
    nexit=0,
    linktype = ""
}

---@param tr Trace
---@return jit.traceinfo? info
function jit.util.traceinfo(tr)
end

---@param tr Trace
---@param ref integer
---@return integer? m
---@return integer? ot
---@return integer? op1
---@return integer? op2
---@return integer? prev
function jit.util.traceir(tr, ref)
end

---@param tr Trace
---@param idx integer
---@return any? k
---@return integer? t
---@return integer? slot
function jit.util.tracek(tr, idx)
end

---@class jit.snap : integer[]

---@param tr Trace
---@param sn integer
---@return jit.snap? snap
function jit.util.tracesnap(tr, sn)
end

---@param tr Trace
---@return string? mcode 
---@return integer? addr 
---@return integer? loop 
function jit.util.tracemc(tr)
end

---@overload fun(exitno:integer):integer
---@param tr Trace
---@param exitno integer
---@return integer? addr
function jit.util.traceexitstub(tr, exitno)
end

---@param idx integer
---@return integer? addr
function jit.util.ircalladdr(idx)
end

jit.opt = {}

---@param ... any flags
function jit.opt.start(...)

end

return jit
