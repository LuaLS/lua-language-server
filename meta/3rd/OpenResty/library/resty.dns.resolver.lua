---@meta
resty_dns_resolver={}
resty_dns_resolver.SECTION_NS=2
resty_dns_resolver.SECTION_AN=1
resty_dns_resolver.TYPE_AAAA=28
function resty_dns_resolver.new(class, opts) end
resty_dns_resolver.TYPE_NS=2
function resty_dns_resolver.query(self, qname, opts, tries) end
resty_dns_resolver.TYPE_A=1
function resty_dns_resolver.compress_ipv6_addr(addr) end
resty_dns_resolver.TYPE_SRV=33
resty_dns_resolver.TYPE_PTR=12
function resty_dns_resolver.reverse_query(self, addr) end
resty_dns_resolver.TYPE_SPF=99
resty_dns_resolver._VERSION="0.21"
function resty_dns_resolver.expand_ipv6_addr() end
function resty_dns_resolver.set_timeout(self, timeout) end
function resty_dns_resolver.tcp_query(self, qname, opts) end
resty_dns_resolver.TYPE_TXT=16
resty_dns_resolver.TYPE_SOA=6
resty_dns_resolver.TYPE_MX=15
resty_dns_resolver.CLASS_IN=1
function resty_dns_resolver.arpa_str(addr) end
resty_dns_resolver.SECTION_AR=3
resty_dns_resolver.TYPE_CNAME=5
return resty_dns_resolver