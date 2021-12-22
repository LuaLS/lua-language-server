---@meta

---@class resty.lrucache.pureffi : resty.lrucache
local lrucache_pureffi = {
  _VERSION = "0.11",
}

--- Creates a new cache instance.
---
--- Upon failure, returns nil and a string describing the error.
---
---@param max_items    number specifies the maximal number of items this cache can hold.
---@param load_factor? number designates the "load factor" of the FFI-based hash-table used internally by `resty.lrucache.pureffi`; the default value is 0.5 (i.e. 50%); if the load factor is specified, it will be clamped to the range of [0.1, 1] (i.e. if load factor is greater than 1, it will be saturated to 1; likewise, if load-factor is smaller than 0.1, it will be clamped to 0.1).
---@return resty.lrucache.pureffi? cache
---@return string?                 error
function lrucache_pureffi.new(max_items, load_factor) end

return lrucache_pureffi