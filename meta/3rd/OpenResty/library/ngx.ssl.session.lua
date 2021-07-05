---@meta
ngx_ssl_session={}
function ngx_ssl_session.set_serialized_session(sess) end
function ngx_ssl_session.get_serialized_session() end
function ngx_ssl_session.get_session_id() end
ngx_ssl_session.version="0.1.17"
return ngx_ssl_session