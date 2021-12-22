---@meta
local resty_core_regex={}
function resty_core_regex.collect_captures(compiled, rc, subj, flags, res) end
function resty_core_regex.set_buf_grow_ratio(ratio) end
function resty_core_regex.re_sub_compile(regex, opts, replace, fun) end
function resty_core_regex.is_regex_cache_empty() end
function resty_core_regex.check_buf_size(buf, buf_size, pos, len, new_len, must_alloc) end
function resty_core_regex.re_match_compile(regex, opts) end
function resty_core_regex.destroy_compiled_regex(compiled) end
resty_core_regex.version = require("resty.core.base").version
return resty_core_regex