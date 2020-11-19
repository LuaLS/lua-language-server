---@meta

---#DES 'file'
---@class file*
local file = {}

---@alias readmode number
---#if VERSION >= 5.3 then
---| '"n"'  # ---#DESENUM 'readmode.n'
---| '"a"'  # ---#DESENUM 'readmode.a'
---|>'"l"'  # ---#DESENUM 'readmode.l'
---| '"L"'  # ---#DESENUM 'readmode.L'
---#else
---| '"*n"' # ---#DESENUM 'readmode.n'
---| '"*a"' # ---#DESENUM 'readmode.a'
---|>'"*l"' # ---#DESENUM 'readmode.l'
---#if JIT then
---| '"*L"' # ---#DESENUM 'readmode.L'
---#endif
---#end

---@alias exitcode | '"exit"'|'"signal"'

---#DES 'file:close'
---@return boolean?  suc
---@return exitcode? exitcode
---@return integer?  code
function file:close() end

---#DES 'file:flush'
function file:flush() end

---#DES 'file:lines'
---@vararg readmode
---@return fun():string|number
function file:lines(...) end

---#DES 'file:read'
---@vararg readmode
---@return string|number
function file:read(...) end

---@alias seekwhence
---| '"set"' # ---#DESENUM 'seekwhence.set'
---|>'"cur"' # ---#DESENUM 'seekwhence.cur'
---| '"end"' # ---#DESENUM 'seekwhence.end'

---#DES 'file:seek'
---@param whence? seekwhence
---@param offset? integer
---@return integer offset
---@return string? errmsg
function file:seek(whence, offset) end

---@alias vbuf
---| '"no"'   # ---#DESENUM 'vbuf.no'
---| '"full"' # ---#DESENUM 'vbuf.full'
---| '"line"' # ---#DESENUM 'vbuf.line'

---#DES 'file:setvbuf'
---@param mode vbuf
---@param size integer
function file:setvbuf(mode, size) end

---#DES 'file:write'
---@vararg string|number
---@return file?
---@return string? errmsg
function file:write(...) end
