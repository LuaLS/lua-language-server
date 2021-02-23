---@meta
resty_lrucache={}
function resty_lrucache.delete(self, key) end
function resty_lrucache.new(size) end
function resty_lrucache.set(self, key, value, ttl) end
function resty_lrucache.flush_all(self) end
resty_lrucache._VERSION="0.09"
function resty_lrucache.get(self, key) end
return resty_lrucache