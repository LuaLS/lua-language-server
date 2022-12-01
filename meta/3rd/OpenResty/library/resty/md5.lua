---@meta

---@class resty.md5 : resty.string.checksum
local md5={}

--- Create a new md5 checksum object.
---@return resty.md5
function md5:new() end

--- Add a string to the md5 checksum data
---@param  s       string
---@param  len?    number Optional length (defaults to the length of `s`)
---@return boolean ok
function md5:update(s, len) end

return md5