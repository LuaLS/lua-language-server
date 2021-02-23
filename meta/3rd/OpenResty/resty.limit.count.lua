---@meta
resty_limit_count={}
function resty_limit_count.uncommit(self, key) end
function resty_limit_count.incoming(self, key, commit) end
resty_limit_count._VERSION="0.06"
function resty_limit_count.new(dict_name, limit, window) end
return resty_limit_count