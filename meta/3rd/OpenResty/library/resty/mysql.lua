---@meta
resty_mysql={}
function resty_mysql.read_result() end
function resty_mysql.new(self) end
function resty_mysql.connect(self, opts) end
function resty_mysql.server_ver(self) end
function resty_mysql.send_query() end
function resty_mysql.set_keepalive(self, ...) end
function resty_mysql.set_compact_arrays(self, value) end
function resty_mysql.query(self, query, est_nrows) end
function resty_mysql.set_timeout(self, timeout) end
function resty_mysql.close(self) end
resty_mysql._VERSION="0.21"
function resty_mysql.get_reused_times(self) end
return resty_mysql