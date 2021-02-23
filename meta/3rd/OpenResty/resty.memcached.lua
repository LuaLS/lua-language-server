---@meta
resty_memcached={}
function resty_memcached.cas(self, key, value, cas_uniq, exptime, flags) end
function resty_memcached.new(self, opts) end
function resty_memcached.append(self, ...) end
function resty_memcached.gets(self, key) end
function resty_memcached.quit(self) end
function resty_memcached.get_reused_times(self) end
function resty_memcached.close(self) end
function resty_memcached.touch(self, key, exptime) end
function resty_memcached.replace(self, ...) end
function resty_memcached.delete(self, key) end
function resty_memcached.version(self) end
function resty_memcached.set(self, ...) end
function resty_memcached.stats(self, args) end
function resty_memcached.flush_all(self, time) end
function resty_memcached.add(self, ...) end
function resty_memcached.set_timeout(self, timeout) end
function resty_memcached.incr(self, key, value) end
function resty_memcached.set_keepalive(self, ...) end
function resty_memcached.connect(self, ...) end
function resty_memcached.prepend(self, ...) end
function resty_memcached.decr(self, key, value) end
function resty_memcached.verbosity(self, level) end
resty_memcached._VERSION="0.13"
function resty_memcached.get(self, key) end
return resty_memcached