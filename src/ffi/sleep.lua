local ffi = require 'ffi'
ffi.cdef[[
    void Sleep(unsigned long dwMilliseconds);
]]

return function (time)
    ffi.C.Sleep(time)
end
