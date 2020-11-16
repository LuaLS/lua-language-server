---@class os
os = {}

---@return number
function os.clock() end

---@param format string?
---@param time integer?
---@return string
function os.date(format, time) end

---@param t2 integer
---@param t1 integer
---@return integer
function os.difftime(t2, t1) end

---@param command string
---@return boolean  suc?
---@return exitcode exitcode?
---@return integer  code?
function os.execute(command) end

---@param code boolean|integer?
---@param close boolean?
function os.exit(code, close) end

---@param varname string
---@return string
function os.getenv(varname) end

---@param filename string
---@return boolean suc
---@return string errmsg?
function os.remove(filename) end

---@param oldname string
---@param newname string
---@return boolean suc
---@return string errmsg?
function os.rename(oldname, newname) end

---@alias localecategory
---|>'"all"'
---| '"collate"'
---| '"ctype"'
---| '"monetary"'
---| '"numeric"'
---| '"time"'

---@param locale string|nil
---@param category localecategory?
---@return string localecategory
function os.setlocale(locale, category) end

---@param date table?
---@return integer
function os.time(date) end

---@return string
function os.tmpname() end

return os
