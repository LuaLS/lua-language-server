---@meta

---@class resty.lrucache : table
local lrucache = {
  _VERSION = "0.11",
}

--- User flags value associated with the item to be stored.
---
--- It can be retrieved later with the item. The user flags are stored as an
--- unsigned 32-bit integer internally, and thus must be specified as a Lua
--- number. If not specified, flags will have a default value of 0. This
--- argument was added in the v0.10 release.
---
---@alias resty.lrucache.flags integer

--- Creates a new cache instance.
---
--- Upon failure, returns nil and a string describing the error.
---
---@param  max_items       number specifies the maximal number of items this cache can hold.
---@return resty.lrucache? cache
---@return string?         error
function lrucache.new(max_items) end


--- Sets a key with a value and an expiration time.
---
--- When the cache is full, the cache will automatically evict the least
--- recently used item.
---
---
---@param key    string
---@param value  any
---@param ttl?   number Expiration time, in seconds. If omitted, the value never expires.
---@param flags? resty.lrucache.flags
function lrucache:set(key, value, ttl, flags) end


--- Fetches a value with the key.
---
--- If the key does not exist in the cache or has already expired, `nil` will
--- be returned.
---
--- Starting from v0.03, the stale data is also returned as the second return
--- value if available.
---
---@param  key                   string
---@return any?                  data
---@return any?                  stale_data
---@return resty.lrucache.flags? integer
function lrucache:get(key) end


--- Removes an item specified by the key from the cache.
---
---@param key string
function lrucache:delete(key) end


--- Returns the number of items currently stored in the cache, including expired
--- items if any.
---
--- The returned count value will always be greater or equal to 0 and smaller
--- than or equal to the size argument given to cache:new.
---
--- This method was added in the v0.10 release.
---
---@return integer
function lrucache:count() end


--- Returns the maximum number of items the cache can hold.
---
--- The return value is the same as the size argument given to
--- `resty.lrucache.new()` when the cache was created.
---
--- This method was added in the v0.10 release.
---
---@return integer
function lrucache:capacity() end


--- Fetch the list of keys currently inside the cache, up to `max_count`.
---
--- The keys will be ordered in MRU fashion (Most-Recently-Used keys first).
---
--- This function returns a Lua (array) table (with integer keys) containing
--- the keys.
---
--- When `max_count` is `nil` or `0`, all keys (if any) will be returned.
---
--- When provided with a `res` table argument, this function will not allocate a
--- table and will instead insert the keys in `res`, along with a trailing `nil`
--- value.
---
--- This method was added in the v0.10 release.
---
---@param  max_count? integer
---@param  res?       table
---@return table      keys
function lrucache:get_keys(max_count, res) end


--- Flushes all the existing data (if any) in the current cache instance.
---
--- This is an O(1) operation and should be much faster than creating a brand
--- new cache instance.
---
--- Note however that the `flush_all()` method of `resty.lrucache.pureffi` is any
--- O(n) operation.
function lrucache:flush_all() end


return lrucache