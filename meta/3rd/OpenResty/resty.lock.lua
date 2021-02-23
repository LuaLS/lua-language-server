---@meta
resty_lock={}
function resty_lock.expire(self, time) end
function resty_lock.unlock(self) end
function resty_lock.new(_, dict_name, opts) end
resty_lock._VERSION="0.08"
function resty_lock.lock(self, key) end
return resty_lock