---@meta

---#DES 'os'
---@class os*
os = {}

---#DES 'os.clock'
---@return number
function os.clock() end

---#DES 'os.date'
---@param format? string
---@param time?   integer
---@return string
function os.date(format, time) end

---#DES 'os.difftime'
---@param t2 integer
---@param t1 integer
---@return integer
function os.difftime(t2, t1) end

---#DES 'os.execute'
---#if VERSION <= 5.1 then
---@param command  string
---@return integer code
function os.execute(command) end
---#else
---@param command string
---@return boolean?  suc
---@return exitcode? exitcode
---@return integer?  code
function os.execute(command) end
---#end

---#if VERSION <= 5.1 and not JIT then
---#DES 'os.exit<5.1'
---@param code? integer
function os.exit(code, close) end
---#else
---#DES 'os.exit>5.2'
---@param code?  boolean|integer
---@param close? boolean
function os.exit(code, close) end
---#end

---#DES 'os.getenv'
---@param varname string
---@return string
function os.getenv(varname) end

---#DES 'os.remove'
---@param filename string
---@return boolean suc
---@return string? errmsg
function os.remove(filename) end

---#DES 'os.rename'
---@param oldname string
---@param newname string
---@return boolean suc
---@return string? errmsg
function os.rename(oldname, newname) end

---@alias localecategory
---|>'"all"'
---| '"collate"'
---| '"ctype"'
---| '"monetary"'
---| '"numeric"'
---| '"time"'

---#DES 'os.setlocale'
---@param locale    string|nil
---@param category? localecategory
---@return string localecategory
function os.setlocale(locale, category) end

---#DES 'os.time'
---@param date? table
---@return integer
function os.time(date) end

---#DES 'os.tmpname'
---@return string
function os.tmpname() end

return os
