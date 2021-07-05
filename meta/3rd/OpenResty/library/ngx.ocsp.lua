---@meta
ngx_ocsp={}
function ngx_ocsp.get_ocsp_responder_from_der_chain(certs, maxlen) end
function ngx_ocsp.validate_ocsp_response(resp, chain, max_errmsg_len) end
function ngx_ocsp.create_ocsp_request(certs, maxlen) end
function ngx_ocsp.set_ocsp_status_resp(ocsp_resp) end
ngx_ocsp.version="0.1.17"
return ngx_ocsp