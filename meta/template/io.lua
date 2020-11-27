---@meta

---#DES 'io'
---@class io*
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
---@vararg readmode
---@return fun():string|number
function io.lines(filename, ...) end

---#DES 'io.open'
---@param filename string
---@param mode     openmode
---@return file*?
---@return string? errmsg
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
---@vararg readmode
---@return string|number
---@return ...
function io.read(...) end

---#DES 'io.tmpfile'
---@return file*
function io.tmpfile() end

---@alias filetype
---| '"file"'        # ---#DESTAIL 'filetype.file'
---| '"closed file"' # ---#DESTAIL 'filetype.closed file'
---| 'nil'           # ---#DESTAIL 'filetype.nil'

---#DES 'io.type'
---@param file file*
---@return filetype
function io.type(file) end

---#DES 'io.write'
---@return file*
---@return string? errmsg
function io.write(...) end

return io
