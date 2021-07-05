---@meta
resty_lrucache_pureffi={}
function resty_lrucache_pureffi.delete(self, key) end
function resty_lrucache_pureffi.new(size, load_factor) end
function resty_lrucache_pureffi.set(self, key, value, ttl) end
function resty_lrucache_pureffi.flush_all(self) end
resty_lrucache_pureffi._VERSION="0.09"
function resty_lrucache_pureffi.get(self, key) end
return resty_lrucache_pureffi