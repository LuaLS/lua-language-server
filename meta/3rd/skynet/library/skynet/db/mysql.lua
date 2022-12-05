---@meta
---@class MySQL
local _M   = {}

---comment
---@param opts table {database,user, password,charset,host, port, overload}
---@return MySQL
function _M.connect(opts)
end
function _M:disconnect()
end
---@param query string
---@return boolean #whether ok
---@return table # error description table or rows list
function _M:query(query)
end

---@class STMT
---@field prepare_id number
---@field field_count integer
---@field param_count integer
---@field warning_count integer
---@field params table
---@field fields table
local STMT = {}
---@param sql string
---@return boolean #whether ok
---@return STMT|table # error description table or STMT
function _M:prepare(sql)
end

---@param stmt STMT
---@param ... any
---@return boolean #whether ok
---@return table # error description table or rows list
function _M:execute(stmt, ...)
end
---@param stmt STMT
---@return boolean #whether ok
---@return table # error description table or rows list
function _M:stmt_reset(stmt)
end
---@param stmt STMT
function _M:stmt_close(stmt)
end
function _M:ping()
end
function _M.server_ver()
end
function _M.quote_sql_str(str)
end
function _M:set_compact_arrays(value)
end
return _M
