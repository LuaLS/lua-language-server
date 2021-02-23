---@meta
ngx_ssl={}
function ngx_ssl.set_der_priv_key(data) end
function ngx_ssl.parse_pem_priv_key(pem) end
function ngx_ssl.get_tls1_version() end
function ngx_ssl.set_cert(cert) end
ngx_ssl.TLS1_VERSION=769
function ngx_ssl.set_priv_key(priv_key) end
function ngx_ssl.raw_server_addr() end
function ngx_ssl.clear_certs() end
function ngx_ssl.raw_client_addr() end
function ngx_ssl.parse_pem_cert(pem) end
ngx_ssl.version="0.1.17"
ngx_ssl.TLS1_2_VERSION=771
function ngx_ssl.server_name() end
ngx_ssl.TLS1_1_VERSION=770
ngx_ssl.SSL3_VERSION=768
function ngx_ssl.set_der_cert(data) end
function ngx_ssl.get_tls1_version_str() end
function ngx_ssl.priv_key_pem_to_der(pem) end
function ngx_ssl.cert_pem_to_der(pem) end
return ngx_ssl