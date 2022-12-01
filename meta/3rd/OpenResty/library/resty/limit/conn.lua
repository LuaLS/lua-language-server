---@meta
resty_limit_conn={}
function resty_limit_conn.set_conn(self, conn) end
function resty_limit_conn.uncommit(self, key) end
function resty_limit_conn.is_committed(self) end
function resty_limit_conn.new(dict_name, max, burst, default_conn_delay) end
function resty_limit_conn.set_burst(self, burst) end
function resty_limit_conn.leaving(self, key, req_latency) end
function resty_limit_conn.incoming(self, key, commit) end
resty_limit_conn._VERSION="0.06"
return resty_limit_conn