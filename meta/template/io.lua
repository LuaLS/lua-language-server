---@meta

---#DES 'io'
---@class io*
---@field stdin  file*
---@field stdout file*
---@field stderr file*
io = {}

---@alias openmode
---|>'"r"'   # ---#DESENUM 'openmode.r'
---| '"w"'   # ---#DESENUM 'openmode.w'
---| '"a"'   # ---#DESENUM 'openmode.a'
---| '"r+"'  # ---#DESENUM 'openmode.r+'
---| '"w+"'  # ---#DESENUM 'openmode.w+'
---| '"a+"'  # ---#DESENUM 'openmode.a+'
---| '"rb"'  # ---#DESENUM 'openmode.rb'
---| '"wb"'  # ---#DESENUM 'openmode.wb'
---| '"ab"'  # ---#DESENUM 'openmode.ab'
---| '"r+b"' # ---#DESENUM 'openmode.r+b'
---| '"w+b"' # ---#DESENUM 'openmode.w+b'
---| '"a+b"' # ---#DESENUM 'openmode.a+b'

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
---| '"r"' # ---#DESENUM 'popenmode.r'
---| '"w"' # ---#DESENUM 'popenmode.w'

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
---| '"file"'        # ---#DESENUM 'filetype.file'
---| '"closed file"' # ---#DESENUM 'filetype.closed file'
---| 'nil'           # ---#DESENUM 'filetype.nil'

---#DES 'io.type'
---@param file file*
---@return filetype
function io.type(file) end

---#DES 'io.write'
---@return file*
---@return string? errmsg
function io.write(...) end

return io
