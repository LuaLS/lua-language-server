---@class io
---@field stdin  file
---@field stdout file
---@field stderr file
io = {}

---@alias openmode
---|>'"r"'
---| '"w"'
---| '"a"'
---| '"r+"'
---| '"w+"'
---| '"a+"'
---| '"rb"'
---| '"wb"'
---| '"ab"'
---| '"r+b"'
---| '"w+b"'
---| '"a+b"'

---@param file file?
---@return boolean  suc?
---@return exitcode exitcode?
---@return integer  code?
function io.close(file) end

function io.flush() end

---@overload fun():file
---@param file string|file
function io.input(file) end

---@param filename string?
---@vararg readmode
---@return fun():string|number
function io.lines(filename, ...) end

---@param filename string
---@param mode openmode
---@return file?
---@return string errmsg?
function io.open(filename, mode) end

---@overload fun():file
---@param file string|file
function io.output(file) end

---@alias popenmode
---| '"r"'
---| '"w"'

---@param prog string
---@param mode popenmode?
---@return file?
---@return string errmsg?
function io.popen(prog, mode) end

---@vararg readmode
---@return string|number
---@return ...
function io.read(...) end

---@return file
function io.tmpfile() end

---@alias filetype
---| '"file"'
---| '"closed file"'
---| 'nil'
---@param file file
---@return filetype
function io.type(file) end

---@return file
---@return string errmsg?
function io.write(...) end
