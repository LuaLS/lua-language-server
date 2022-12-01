---@meta

---@class resty.core.regex
---@field no_pcre boolean
local regex = {}

---@param ratio integer
function regex.set_buf_grow_ratio(ratio) end

---@return boolean is_empty
function regex.is_regex_cache_empty() end

---@class resty.core.regex.compiled : ffi.cdata*
---@field captures        ffi.cdata*
---@field ncaptures       integer
---@field name_count      integer
---@field name_table      ffi.cdata*
---@field name_entry_size integer

---@param compiled resty.core.regex.compiled
---@param flags integer
---@param res ngx.re.captures
function regex.collect_captures(compiled, flags, res) end

---@param compiled resty.core.regex.compiled
function regex.destroy_compiled_regex(compiled) end

---@param  re                         string
---@param  opts                       ngx.re.options
---@return resty.core.regex.compiled? compiled
---@return boolean|string             compile_once_or_error
---@return integer?                   flags
function regex.re_match_compile(re, opts) end

---@param  buf        ffi.cdata*
---@param  buf_size   integer
---@param  pos        integer
---@param  len        integer
---@param  new_len    integer
---@param  must_alloc boolean
---@return ffi.cdata* buf
---@return integer    buf_size
---@return integer    new_len
function regex.check_buf_size(buf, buf_size, pos, len, new_len, must_alloc) end

---@param  re                         string
---@param  opts                       ngx.re.options
---@param  replace?                   string
---@param  func?                      fun(match:string):string
---@return resty.core.regex.compiled? compiled
---@return boolean|string             compile_once_or_error
---@return integer?                   flags
function regex.re_sub_compile(re, opts, replace, func) end

return regex