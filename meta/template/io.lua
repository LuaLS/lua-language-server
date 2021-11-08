---@meta

---#DES 'io'
---@class iolib
---#DES 'io.stdin'
---@field stdin  file*
---#DES 'io.stdout'
---@field stdout file*
---#DES 'io.stderr'
---@field stderr file*
io = {}

---@alias openmode
---|>'"r"'   # ---#DESTAIL 'openmode.r'
---| '"w"'   # ---#DESTAIL 'openmode.w'
---| '"a"'   # ---#DESTAIL 'openmode.a'
---| '"r+"'  # ---#DESTAIL 'openmode.r+'
---| '"w+"'  # ---#DESTAIL 'openmode.w+'
---| '"a+"'  # ---#DESTAIL 'openmode.a+'
---| '"rb"'  # ---#DESTAIL 'openmode.rb'
---| '"wb"'  # ---#DESTAIL 'openmode.wb'
---| '"ab"'  # ---#DESTAIL 'openmode.ab'
---| '"r+b"' # ---#DESTAIL 'openmode.r+b'
---| '"w+b"' # ---#DESTAIL 'openmode.w+b'
---| '"a+b"' # ---#DESTAIL 'openmode.a+b'

---#DES 'io.close'
---@param file? file*
---@return boolean?  suc
---@return exitcode? exitcode
---@return integer?  code
function io.close(file) end

---#DES 'io.flush'
function io.flush() end

---#DES 'io.input'
---@overload fun():file*
---@param file string|file*
function io.input(file) end

---#DES 'io.lines'
---@param filename string?
---@param ... readmode
---@return fun():string|number
function io.lines(filename, ...) end

---#DES 'io.open'
---@param filename string
---@param mode     openmode
---@return file*?
---@return string? errmsg
---@nodiscard
function io.open(filename, mode) end

---#DES 'io.output'
---@overload fun():file*
---@param file string|file*
function io.output(file) end

---@alias popenmode
---| '"r"' # ---#DESTAIL 'popenmode.r'
---| '"w"' # ---#DESTAIL 'popenmode.w'

---#DES 'io.popen'
---@param prog  string
---@param mode? popenmode
---@return file*?
---@return string? errmsg
function io.popen(prog, mode) end

---#DES 'io.read'
---@param ... readmode
---@return string|number
---@return ...
---@nodiscard
function io.read(...) end

---#DES 'io.tmpfile'
---@return file*
---@nodiscard
function io.tmpfile() end

---@alias filetype
---| '"file"'        # ---#DESTAIL 'filetype.file'
---| '"closed file"' # ---#DESTAIL 'filetype.closed file'
---| 'nil'           # ---#DESTAIL 'filetype.nil'

---#DES 'io.type'
---@param file file*
---@return filetype
---@nodiscard
function io.type(file) end

---#DES 'io.write'
---@return file*
---@return string? errmsg
function io.write(...) end

---#DES 'file'
---@class file*
local file = {}

---@alias readmode number
---#if VERSION >= 5.3 then
---| '"n"'  # ---#DESTAIL 'readmode.n'
---| '"a"'  # ---#DESTAIL 'readmode.a'
---|>'"l"'  # ---#DESTAIL 'readmode.l'
---| '"L"'  # ---#DESTAIL 'readmode.L'
---#else
---| '"*n"' # ---#DESTAIL 'readmode.n'
---| '"*a"' # ---#DESTAIL 'readmode.a'
---|>'"*l"' # ---#DESTAIL 'readmode.l'
---#if JIT then
---| '"*L"' # ---#DESTAIL 'readmode.L'
---#end
---#end

---@alias exitcode '"exit"'|'"signal"'

---#DES 'file:close'
---@return boolean?  suc
---@return exitcode? exitcode
---@return integer?  code
function file:close() end

---#DES 'file:flush'
function file:flush() end

---#DES 'file:lines'
---@param ... readmode
---@return fun():string|number
function file:lines(...) end

---#DES 'file:read'
---@param ... readmode
---@return string|number
---@nodiscard
function file:read(...) end

---@alias seekwhence
---| '"set"' # ---#DESTAIL 'seekwhence.set'
---|>'"cur"' # ---#DESTAIL 'seekwhence.cur'
---| '"end"' # ---#DESTAIL 'seekwhence.end'

---#DES 'file:seek'
---@param whence? seekwhence
---@param offset? integer
---@return integer offset
---@return string? errmsg
function file:seek(whence, offset) end

---@alias vbuf
---| '"no"'   # ---#DESTAIL 'vbuf.no'
---| '"full"' # ---#DESTAIL 'vbuf.full'
---| '"line"' # ---#DESTAIL 'vbuf.line'

---#DES 'file:setvbuf'
---@param mode vbuf
---@param size integer
function file:setvbuf(mode, size) end

---#DES 'file:write'
---@param ... string|number
---@return file*?
---@return string? errmsg
function file:write(...) end

return io
