---@meta
resty_limit_req={}
function resty_limit_req.set_rate(self, rate) end
function resty_limit_req.uncommit(self, key) end
function resty_limit_req.set_burst(self, burst) end
function resty_limit_req.new(dict_name, rate, burst) end
function resty_limit_req.incoming(self, key, commit) end
resty_limit_req._VERSION="0.06"
return resty_limit_req