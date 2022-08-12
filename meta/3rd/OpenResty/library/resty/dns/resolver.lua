---@meta

---
--- lua-resty-dns - Lua DNS resolver for the ngx_lua based on the cosocket API
---
--- https://github.com/openresty/lua-resty-dns
---
---# Description
---
--- This Lua library provides a DNS resolver for the ngx_lua nginx module:
---
--- https://github.com/openresty/lua-nginx-module/#readme
---
--- This Lua library takes advantage of ngx_lua's cosocket API, which ensures
--- 100% nonblocking behavior.
---
--- Note that at least [ngx_lua 0.5.12](https://github.com/openresty/lua-nginx-module/tags) or [OpenResty 1.2.1.11](http://openresty.org/#Download) is required.
---
--- Also, the [bit library](http://bitop.luajit.org/) is also required. If you're using LuaJIT 2.0 with ngx_lua, then the `bit` library is already available by default.
---
--- Note that, this library is bundled and enabled by default in the [OpenResty bundle](http://openresty.org/).
---
--- IMPORTANT: to be able to generate unique ids, the random generator must be properly seeded using `math.randomseed` prior to using this module.
---
---# Automatic Error Logging
---
--- By default, the underlying [ngx_lua](https://github.com/openresty/lua-nginx-module/#readme) module does error logging when socket errors happen. If you are already doing proper error handling in your own Lua code, then you are recommended to disable this automatic error logging by turning off [ngx_lua](https://github.com/openresty/lua-nginx-module/#readme)'s [lua_socket_log_errors](https://github.com/openresty/lua-nginx-module/#lua_socket_log_errors) directive, that is:
---
---```nginx
---    lua_socket_log_errors off;
---```
---
---# Limitations
---
--- * This library cannot be used in code contexts like `set_by_lua*`, `log_by_lua*`, and `header_filter_by_lua*` where the ngx_lua cosocket API is not available.
--- * The `resty.dns.resolver` object instance cannot be stored in a Lua variable at the Lua module level, because it will then be shared by all the concurrent requests handled by the same nginx worker process (see https://github.com/openresty/lua-nginx-module/#data-sharing-within-an-nginx-worker ) and result in bad race conditions when concurrent requests are trying to use the same `resty.dns.resolver` instance. You should always initiate `resty.dns.resolver` objects in function local variables or in the `ngx.ctx` table. These places all have their own data copies for each request.
---
---@class resty.dns.resolver
---@field _VERSION string
---
--- undocumented/private fields--use at your own risk
---
---@field cur         integer
---@field socks       udpsock[]
---@field tcp_sock    tcpsock
---@field servers     resty.dns.resolver.nameserver_tuple[]
---@field retrans     integer
---@field no_recurse  boolean
local resolver = {}


--- The `A` resource record type, equal to the decimal number 1.
---@class resty.dns.resolver.TYPE_A
resolver.TYPE_A = 1

--- The `NS` resource record type, equal to the decimal number `2`.
---@class resty.dns.resolver.TYPE_NS
resolver.TYPE_NS = 2

--- The `CNAME` resource record type, equal to the decimal number `5`.
---@class resty.dns.resolver.TYPE_CNAME
resolver.TYPE_CNAME = 5

--- The `SOA` resource record type, equal to the decimal number `6`.
---@class resty.dns.resolver.TYPE_SOA
resolver.TYPE_SOA = 6

--- The `PTR` resource record type, equal to the decimal number `12`.
---@class resty.dns.resolver.TYPE_PTR
resolver.TYPE_PTR = 12

--- The `MX` resource record type, equal to the decimal number `15`.
---@class resty.dns.resolver.TYPE_MX
resolver.TYPE_MX = 15

--- The `TXT` resource record type, equal to the decimal number `16`.
---@class resty.dns.resolver.TYPE_TXT
resolver.TYPE_TXT = 16

--- The `AAAA` resource record type, equal to the decimal number `28`.
---@class resty.dns.resolver.TYPE_AAAA
resolver.TYPE_AAAA = 28

--- The `SRV` resource record type, equal to the decimal number `33`.
---
--- See RFC 2782 for details.
---@class resty.dns.resolver.TYPE_SRV
resolver.TYPE_SRV = 33

--- The `SPF` resource record type, equal to the decimal number `99`.
---
--- See RFC 4408 for details.
---@class resty.dns.resolver.TYPE_SPF
resolver.TYPE_SPF = 99


---@alias resty.dns.resolver.TYPE integer
---| `resolver.TYPE_A`     # A
---| 1                     # A
---| `resolver.TYPE_NS`    # NS
---| 2                     # NS
---| `resolver.TYPE_CNAME` # CNAME
---| 5                     # CNAME
---| `resolver.TYPE_SOA`   # SOA
---| 6                     # SOA
---| `resolver.TYPE_PTR`   # PTR
---| 12                    # PTR
---| `resolver.TYPE_MX`    # MX
---| 15                    # MX
---| `resolver.TYPE_TXT`   # TXT
---| 16                    # TXT
---| `resolver.TYPE_AAAA`  # AAAA
---| 28                    # AAAA
---| `resolver.TYPE_SRV`   # SRV
---| 33                    # SRV
---| `resolver.TYPE_SPF`   # SPF
---| 99                    # SPF


---@alias resty.dns.resolver.CLASS integer
---| `resolver.CLASS_IN`
---| 1

--- The `Internet` resource record type
---@class resty.dns.resolver.CLASS_IN
resolver.CLASS_IN = 1


---@alias resty.dns.resolver.SECTION integer
---| `resolver.SECTION_AN` # Answer section
---| 1                     # Answer section
---| `resolver.SECTION_NS` # Authority section
---| 2                     # Authority section
---| `resolver.SECTION_AR` # Additional section
---| 3                     # Additional section


--- Identifier of the `Answer` section in the DNS response.
---@class resty.dns.resolver.SECTION_AN
resolver.SECTION_AN = 1


--- Identifier of the `Authority` section in the DNS response.
---@class resty.dns.resolver.SECTION_NS
resolver.SECTION_NS = 2


--- Identifier of the `Additional` section in the DNS response.
---@class resty.dns.resolver.SECTION_AR
resolver.SECTION_AR = 3


---@alias resty.dns.resolver.ERRCODE integer
---| 1  # format error
---| 2  # server failure
---| 3  # name error
---| 4  # not implemented
---| 5  # refused


---@alias resty.dns.resolver.ERRSTR
---| "format error"    # errcode 1
---| "server failure"  # errcode 2
---| "name error"      # errcode 3
---| "not implemented" # errcode 4
---| "refused"         # errcode 5
---| "unknown"         # errcode unknown


--- Creates a dns.resolver object.
---
--- On error, returns `nil` and an error string.
---
---@param opts resty.dns.resolver.new.opts
---@return resty.dns.resolver? resolver
---@return string? error
function resolver:new(opts) end


---@class resty.dns.resolver.nameserver_tuple
---@field [1] string  # hostname or addr
---@field [2] integer # port number

---@alias resty.dns.resolver.nameserver
---| string
---| resty.dns.resolver.nameserver_tuple


--- Options for `resty.dns.resolver:new()`
---
---@class resty.dns.resolver.new.opts : table
---
---@field nameservers resty.dns.resolver.nameserver[] # a list of nameservers to be used. Each nameserver entry can be either a single hostname string or a table holding both the hostname string and the port number. The nameserver is picked up by a simple round-robin algorithm for each `query` method call. This option is required.
---
---@field retrans? number # (default: `5`) the total number of times of retransmitting the DNS request when receiving a DNS response times out according to the `timeout` setting. When trying to retransmit the query, the next nameserver according to the round-robin algorithm will be picked up.
---
---@field timeout? number # (default: `2000`) the time in milliseconds for waiting for the response for a single attempt of request transmission. note that this is ''not'' the maximal total waiting time before giving up, the maximal total waiting time can be calculated by the expression `timeout x retrans`. The `timeout` setting can also be changed by calling the `set_timeout` method.
---
---@field no_recurse? boolean # (default: `false`) a boolean flag controls whether to disable the "recursion desired" (RD) flag in the UDP request.
---
---@field no_random? boolean # (default: `false`) a boolean flag controls whether to randomly pick the nameserver to query first, if `true` will always start with the first nameserver listed.


--- Performs a DNS standard query.
---
--- The query is sent to the nameservers specified by the `new` method, and
---
--- Returns all the answer records in an array-like Lua table.
---
--- In case of errors, it will return nil and a string describing the error instead.
---
--- If the server returns a non-zero error code, the fields `errcode` and `errstr` will be set accordingly in the Lua table returned.
---
--- The optional parameter `tries` can be provided as an empty table, and will be returned as a third result. The table will be an array with the error message for each (if any) failed try.
---
--- When data truncation happens, the resolver will automatically retry using the TCP transport mode to query the current nameserver. All TCP connections are short lived.
---
---@param qname string
---@param opts? resty.dns.resolver.query.opts
---@param tries? string[]
---@return resty.dns.resolver.query.answer[] results
---@return string? error
---@return string[]? tries
function resolver:query(qname, opts, tries) end


---@class resty.dns.resolver.answer : table
---
---@field name string # The resource record name.
---
---@field type resty.dns.resolver.TYPE # The current resource record type, possible values are 1 (TYPE_A), 5 (TYPE_CNAME), 28 (TYPE_AAAA), and any other values allowed by RFC 1035.
---
---@field section resty.dns.resolver.SECTION # The identifier of the section that the current answer record belongs to. Possible values are 1 (SECTION_AN), 2 (SECTION_NS), and 3 (SECTION_AR).
---
---@field ttl number # The time-to-live (TTL) value in seconds for the current resource record.
---
---@field class resty.dns.resolver.CLASS # The current resource record class, possible values are 1 (CLASS_IN) or any other values allowed by RFC 1035.
---
---@field rdata string # The raw resource data (RDATA) for resource records that are not recognized.
---
---@field errcode? resty.dns.resolver.ERRCODE # Error code returned by the DNS server
---
---@field errstr? resty.dns.resolver.ERRSTR # Error string returned by the DNS server


--- A-type answer
---
---@class resty.dns.resolver.answer.A : resty.dns.resolver.answer
---
---@field address string # The IPv4 address.

--- AAAA-type answer
---
---@class resty.dns.resolver.answer.AAAA : resty.dns.resolver.answer
---
---@field address string # The IPv6 address. Successive 16-bit zero groups in IPv6 addresses will not be compressed by default, if you want that, you need to call the compress_ipv6_addr static method instead.


--- CNAME-type answer
---
---@class resty.dns.resolver.answer.CNAME : resty.dns.resolver.answer
---
---@field cname? string # The (decoded) record data value for CNAME resource records.


--- MX-type answer
---
---@class resty.dns.resolver.answer.MX : resty.dns.resolver.answer
---
---@field preference integer # The preference integer number for MX resource records.
---
---@field exchange? string # The exchange domain name for MX resource records.


--- SRV-type answer
---
---@class resty.dns.resolver.answer.SRV : resty.dns.resolver.answer
---
---@field priority number
---
---@field weight number
---
---@field port integer
---
---@field target string


--- NS-type answer
---
---@class resty.dns.resolver.answer.NS : resty.dns.resolver.answer
---
---@field nsdname string # A domain-name which specifies a host which should be authoritative for the specified class and domain. Usually present for NS type records.
---


--- TXT-type answer
---
---@class resty.dns.resolver.answer.TXT : resty.dns.resolver.answer
---
---@field txt? string|string[] # The record value for TXT records. When there is only one character string in this record, then this field takes a single Lua string. Otherwise this field takes a Lua table holding all the strings.


--- SPF-type answer
---
---@class resty.dns.resolver.answer.SPF : resty.dns.resolver.answer
---
---@field spf? string|string[] # The record value for SPF records. When there is only one character string in this record, then this field takes a single Lua string. Otherwise this field takes a Lua table holding all the strings.


--- PTR-type answer
---
---@class resty.dns.resolver.answer.PTR : resty.dns.resolver.answer
---
---@field ptrdname string # The record value for PTR records.


--- SOA-type answer
---
---@class resty.dns.resolver.answer.SOA : resty.dns.resolver.answer
---
---@field serial   integer # SOA serial
---@field refresh  integer # SOA refresh
---@field retry    integer # SOA retry
---@field expire   integer # SOA expire
---@field minimum  integer # SOA minimum


---@alias resty.dns.resolver.query.answer
---| resty.dns.resolver.answer
---| resty.dns.resolver.answer.A
---| resty.dns.resolver.answer.AAAA
---| resty.dns.resolver.answer.CNAME
---| resty.dns.resolver.answer.MX
---| resty.dns.resolver.answer.NS
---| resty.dns.resolver.answer.PTR
---| resty.dns.resolver.answer.SOA
---| resty.dns.resolver.answer.SPF
---| resty.dns.resolver.answer.SRV
---| resty.dns.resolver.answer.TXT


--- Options for `resty.dns.resolver:query()`
---
---@class resty.dns.resolver.query.opts : table
---
---@field qtype? resty.dns.resolver.TYPE # (default: `1`) The type of the question. Possible values are 1 (TYPE_A), 5 (TYPE_CNAME), 28 (TYPE_AAAA), or any other QTYPE value specified by RFC 1035 and RFC 3596.
---
---@field authority_section? boolean # (default: `false`) When `true`, the answers return value includes the `Authority` section of the DNS response.
---
---@field additional_section? boolean # (default: `false`) When `true`, the answers return value includes the `Additional` section of the DNS response.


--- Just like the query method, but enforce the TCP transport mode instead of UDP.
---
--- All TCP connections are short lived.
---
---@param qname string
---@param opts? resty.dns.resolver.query.opts
---@return resty.dns.resolver.query.answer[] results
---@return string? error
function resolver:tcp_query(qname, opts) end


--- Performs a PTR lookup for both IPv4 and IPv6 addresses.
---
--- This function is basically a wrapper for the query command which uses the `arpa_str` function to convert the IP address on the fly.
---
---@param addr string
---@return resty.dns.resolver.query.answer[] results
---@return string? error
function resolver:reverse_query(addr) end


--- Overrides the current timeout setting for all nameserver peers.
---
---@param timeout number # timeout in milliseconds
function resolver:set_timeout(timeout) end

--- Compresses the successive 16-bit zero groups in the textual format of the IPv6 address.
---
--- For example, the following will yield `FF01::101` in the new_addr return value:
---
---```lua
---  local resolver = require "resty.dns.resolver"
---  local compress = resolver.compress_ipv6_addr
---  local new_addr = compress("FF01:0:0:0:0:0:0:101")
---```
---
---@param addr string
---@return string compressed
function resolver.compress_ipv6_addr(addr) end

--- Expands the successive 16-bit zero groups in the textual format of the IPv6 address.
---
--- For example, the following will yield `FF01:0:0:0:0:0:0:101` in the new_addr return value:
---
---```lua
---  local resolver = require "resty.dns.resolver"
---  local expand = resolver.expand_ipv6_addr
---  local new_addr = expand("FF01::101")
---```
---
---@param addr string
---@return string expanded
function resolver.expand_ipv6_addr(addr) end

--- Generates the reverse domain name for PTR lookups for both IPv4 and IPv6 addresses.
---
--- Compressed IPv6 addresses will be automatically expanded.
---
--- For example, the following will yield `4.3.2.1.in-addr.arpa` for `ptr4` and `1.0.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.F.F.ip6.arpa` for `ptr6`:
---
---```lua
---  local resolver = require "resty.dns.resolver"
---  local ptr4 = resolver.arpa_str("1.2.3.4")
---  local ptr6 = resolver.arpa_str("FF01::101")
---```
---
---@param addr string
---@return string
function resolver.arpa_str(addr) end


return resolver