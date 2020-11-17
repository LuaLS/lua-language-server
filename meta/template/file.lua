---@meta

---@class file*
local file = {}

---@alias readmode number
---| '"n"'
---| '"a"'
---|>'"l"'
---| '"L"'

---@alias exitcode | '"exit"'|'"signal"'

---@return boolean  suc?
---@return exitcode exitcode?
---@return integer  code?
function file:close() end

function file:flush() end

---@vararg readmode
---@return fun():string|number
function file:lines(...) end

---@vararg readmode
---@return string|number
function file:read(...) end

---@alias seekwhence
---| '"set"'
---|>'"cur"'
---| '"end"'

---@param whence seekwhence?
---@param offset integer?
---@return integer offset
---@return string errmsg?
function file:seek(whence, offset) end

---@alias vbuf
---| '"no"'
---| '"full"'
---| '"line"'
---@param mode vbuf
---@param size integer
function file:setvbuf(mode, size) end

---@vararg string|number
---@return file?
---@return string errmsg?
function file:write(...) end
