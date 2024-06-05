---@meta

---@class bee.filewatch.instance
local instance = {}

---@param path string
function instance:add(path)
end

---@param enable boolean
---@return boolean
function instance:set_recursive(enable)
end

---@param enable boolean
---@return boolean
function instance:set_follow_symlinks(enable)
end

---@param callback? fun(path: string):boolean
---@return boolean
function instance:set_filter(callback)
end

---@class bee.filewatch
local fw = {}

---@return bee.filewatch.instance
function fw.create()
end

return fw
