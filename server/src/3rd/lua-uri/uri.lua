local M = { _NAME = "uri", VERSION = "1.0" }
M.__index = M

local Util = require "uri._util"

local _UNRESERVED = "A-Za-z0-9%-._~"
local _GEN_DELIMS = ":/?#%[%]@"
local _SUB_DELIMS = "!$&'()*+,;="
local _RESERVED = _GEN_DELIMS .. _SUB_DELIMS
local _USERINFO = "^[" .. _UNRESERVED .. "%%" .. _SUB_DELIMS .. ":]*$"
local _REG_NAME = "^[" .. _UNRESERVED .. "%%" .. _SUB_DELIMS .. "]*$"
local _IP_FUTURE_LITERAL = "^v[0-9A-Fa-f]+%." ..
                           "[" .. _UNRESERVED .. _SUB_DELIMS .. "]+$"
local _QUERY_OR_FRAG = "^[" .. _UNRESERVED .. "%%" .. _SUB_DELIMS .. ":@/?]*$"
local _PATH_CHARS = "^[" .. _UNRESERVED .. "%%" .. _SUB_DELIMS .. ":@/]*$"

local function _normalize_percent_encoding (s)
    if s:find("%%$") or s:find("%%.$") then
        error("unfinished percent encoding at end of URI '" .. s .. "'")
    end

    return s:gsub("%%(..)", function (hex)
        if not hex:find("^[0-9A-Fa-f][0-9A-Fa-f]$") then
            error("invalid percent encoding '%" .. hex ..
                  "' in URI '" .. s .. "'")
        end

        -- Never percent-encode unreserved characters, and always use uppercase
        -- hexadecimal for percent encoding.  RFC 3986 section 6.2.2.2.
        local char = string.char(tonumber("0x" .. hex))
        return char:find("^[" .. _UNRESERVED .. "]") and char or "%" .. hex:upper()
    end)
end

local function _is_ip4_literal (s)
    if not s:find("^[0-9]+%.[0-9]+%.[0-9]+%.[0-9]+$") then return false end

    for dec_octet in s:gmatch("[0-9]+") do
        if dec_octet:len() > 3 or dec_octet:find("^0.") or
           tonumber(dec_octet) > 255 then
            return false
        end
    end

    return true
end

local function _is_ip6_literal (s)
    local had_elipsis = false       -- true when '::' found
    local num_chunks = 0
    while s ~= "" do
        num_chunks = num_chunks + 1
        local p1, p2 = s:find("::?")
        local chunk
        if p1 then
            chunk = s:sub(1, p1 - 1)
            s = s:sub(p2 + 1)
            if p2 ~= p1 then    -- found '::'
                if had_elipsis then return false end    -- two of '::'
                had_elipsis = true
                if chunk == "" then num_chunks = num_chunks - 1 end
            else
                if chunk == "" then return false end    -- ':' at start
                if s == "" then return false end        -- ':' at end
            end
        else
            chunk = s
            s = ""
        end

        -- Chunk is neither 4-digit hex num, nor IPv4address in last chunk.
        if (not chunk:find("^[0-9a-f]+$") or chunk:len() > 4) and
           (s ~= "" or not _is_ip4_literal(chunk)) and
           chunk ~= "" then
            return false
        end

        -- IPv4address in last position counts for two chunks of hex digits.
        if chunk:len() > 4 then num_chunks = num_chunks + 1 end
    end

    if had_elipsis then
        if num_chunks > 7 then return false end
    else
        if num_chunks ~= 8 then return false end
    end

    return true
end

local function _is_valid_host (host)
    if host:find("^%[.*%]$") then
        local ip_literal = host:sub(2, -2)
        if ip_literal:find("^v") then
            if not ip_literal:find(_IP_FUTURE_LITERAL) then
                return "invalid IPvFuture literal '" .. ip_literal .. "'"
            end
        else
            if not _is_ip6_literal(ip_literal) then
                return "invalid IPv6 address '" .. ip_literal .. "'"
            end
        end
    elseif not _is_ip4_literal(host) and not host:find(_REG_NAME) then
        return "invalid host value '" .. host .. "'"
    end

    return nil
end

local function _normalize_and_check_path (s, normalize)
    if not s:find(_PATH_CHARS) then return false end
    if not normalize then return s end

    -- Remove unnecessary percent encoding for path values.
    -- TODO - I think this should be HTTP-specific (probably file also).
    --s = Util.uri_decode(s, _SUB_DELIMS .. ":@")

    return Util.remove_dot_segments(s)
end

function M.new (class, uri, base)
    if not uri then error("usage: URI:new(uristring, [baseuri])") end
    if type(uri) ~= "string" then uri = tostring(uri) end

    if base then
        local uri, err = M.new(class, uri)
        if not uri then return nil, err end
        if type(base) ~= "table" then
            base, err = M.new(class, base)
            if not base then return nil, "error parsing base URI: " .. err end
        end
        if base:is_relative() then return nil, "base URI must be absolute" end
        local ok, err = pcall(uri.resolve, uri, base)
        if not ok then return nil, err end
        return uri
    end

    local s = _normalize_percent_encoding(uri)

    local _, p
    local scheme, authority, userinfo, host, port, path, query, fragment

    _, p, scheme = s:find("^([a-zA-Z][-+.a-zA-Z0-9]*):")
    if scheme then
        scheme = scheme:lower()
        s = s:sub(p + 1)
    end

    _, p, authority = s:find("^//([^/?#]*)")
    if authority then
        s = s:sub(p + 1)

        _, p, userinfo = authority:find("^([^@]*)@")
        if userinfo then
            if not userinfo:find(_USERINFO) then
                return nil, "invalid userinfo value '" .. userinfo .. "'"
            end
            authority = authority:sub(p + 1)
        end

        p, _, port = authority:find(":([0-9]*)$")
        if port then
            port = (port ~= "") and tonumber(port) or nil
            authority = authority:sub(1, p - 1)
        end

        host = authority:lower()
        local err = _is_valid_host(host)
        if err then return nil, err end
    end

    _, p, path = s:find("^([^?#]*)")
    if path ~= "" then
        local normpath = _normalize_and_check_path(path, scheme)
        if not normpath then return nil, "invalid path '" .. path .. "'" end
        path = normpath
        s = s:sub(p + 1)
    end

    _, p, query = s:find("^%?([^#]*)")
    if query then
        s = s:sub(p + 1)
        if not query:find(_QUERY_OR_FRAG) then
            return nil, "invalid query value '?" .. query .. "'"
        end
    end

    _, p, fragment = s:find("^#(.*)")
    if fragment then
        if not fragment:find(_QUERY_OR_FRAG) then
            return nil, "invalid fragment value '#" .. fragment .. "'"
        end
    end

    local o = {
        _scheme = scheme,
        _userinfo = userinfo,
        _host = host,
        _port = port,
        _path = path,
        _query = query,
        _fragment = fragment,
    }
    setmetatable(o, scheme and class or (require "uri._relative"))

    return o:init()
end

function M.uri (self, ...)
    local uri = self._uri

    if not uri then
        local scheme = self:scheme()
        if scheme then
            uri = scheme .. ":"
        else
            uri = ""
        end

        local host, port, userinfo = self:host(), self._port, self:userinfo()
        if host or port or userinfo then
            uri = uri .. "//"
            if userinfo then uri = uri .. userinfo .. "@" end
            if host then uri = uri .. host end
            if port then uri = uri .. ":" .. port end
        end

        local path = self:path()
        if uri == "" and path:find("^[^/]*:") then
            path = "./" .. path
        end

        uri = uri .. path
        if self:query() then uri = uri .. "?" .. self:query() end
        if self:fragment() then uri = uri .. "#" .. self:fragment() end

        self._uri = uri     -- cache
    end

    if select("#", ...) > 0 then
        local new = ...
        if not new then error("URI can't be set to nil") end
        local newuri, err = M:new(new)
        if not newuri then
            error("new URI string is invalid (" .. err .. ")")
        end
        setmetatable(self, getmetatable(newuri))
        for k in pairs(self) do self[k] = nil end
        for k, v in pairs(newuri) do self[k] = v end
    end

    return uri
end

function M.__tostring (self) return self:uri() end

function M.eq (a, b)
    if type(a) == "string" then a = assert(M:new(a)) end
    if type(b) == "string" then b = assert(M:new(b)) end
    return a:uri() == b:uri()
end

function M.scheme (self, ...)
    local old = self._scheme

    if select("#", ...) > 0 then
        local new = ...
        if not new then error("can't remove scheme from absolute URI") end
        if type(new) ~= "string" then new = tostring(new) end
        if not new:find("^[a-zA-Z][-+.a-zA-Z0-9]*$") then
            error("invalid scheme '" .. new .. "'")
        end
        Util.do_class_changing_change(self, M, "scheme", new,
                                      function (uri, new) uri._scheme = new end)
    end

    return old
end

function M.userinfo (self, ...)
    local old = self._userinfo

    if select("#", ...) > 0 then
        local new = ...
        if new then
            if not new:find(_USERINFO) then
                error("invalid userinfo value '" .. new .. "'")
            end
            new = _normalize_percent_encoding(new)
        end
        self._userinfo = new
        if new and not self._host then self._host = "" end
        self._uri = nil
    end

    return old
end

function M.host (self, ...)
    local old = self._host

    if select("#", ...) > 0 then
        local new = ...
        if new then
            new = tostring(new):lower()
            local err = _is_valid_host(new)
            if err then error(err) end
        else
            if self._userinfo or self._port then
                error("there must be a host if there is a userinfo or port," ..
                      " although it can be the empty string")
            end
        end
        self._host = new
        self._uri = nil
    end

    return old
end

function M.port (self, ...)
    local old = self._port or self:default_port()

    if select("#", ...) > 0 then
        local new = ...
        if new then
            if type(new) == "string" then new = tonumber(new) end
            if new < 0 then error("port number must not be negative") end
            local newint = new - new % 1
            if newint ~= new then error("port number not integer") end
            if new == self:default_port() then new = nil end
        end
        self._port = new
        if new and not self._host then self._host = "" end
        self._uri = nil
    end

    return old
end

function M.path (self, ...)
    local old = self._path

    if select("#", ...) > 0 then
        local new = ... or ""
        new = _normalize_percent_encoding(new)
        new = Util.uri_encode(new, "^A-Za-z0-9%-._~%%!$&'()*+,;=:@/")
        if self._host then
            if new ~= "" and not new:find("^/") then
                error("path must begin with '/' when there is an authority")
            end
        else
            if new:find("^//") then new = "/%2F" .. new:sub(3) end
        end
        self._path = new
        self._uri = nil
    end

    return old
end

function M.query (self, ...)
    local old = self._query

    if select("#", ...) > 0 then
        local new = ...
        if new then
            new = Util.uri_encode(new, "^" .. _UNRESERVED .. "%%" .. _SUB_DELIMS .. ":@/?")
        end
        self._query = new
        self._uri = nil
    end

    return old
end

function M.fragment (self, ...)
    local old = self._fragment

    if select("#", ...) > 0 then
        local new = ...
        if new then
            new = Util.uri_encode(new, "^" .. _UNRESERVED .. "%%" .. _SUB_DELIMS .. ":@/?")
        end
        self._fragment = new
        self._uri = nil
    end

    return old
end

function M.init (self)
    local scheme_class
        = Util.attempt_require("uri." .. self._scheme:gsub("[-+.]", "_"))
    if scheme_class then
        setmetatable(self, scheme_class)
        if self._port and self._port == self:default_port() then
            self._port = nil
        end
        -- Call the subclass 'init' method, if it has its own.
        if scheme_class ~= M and self.init ~= M.init then
            return self:init()
        end
    end
    return self
end

function M.default_port () return nil end
function M.is_relative () return false end
function M.resolve () end   -- only does anything in uri._relative

-- TODO - there should probably be an option or something allowing you to
-- choose between making a link relative whenever possible (always using a
-- relative path if the scheme and authority are the same as the base URI) or
-- just using a relative reference to make the link as small as possible, which
-- might meaning using a path of '/' instead if '../../../' or whatever.
-- This method's algorithm is loosely based on the one described here:
--    http://lists.w3.org/Archives/Public/uri/2007Sep/0003.html
function M.relativize (self, base)
    if type(base) == "string" then base = assert(M:new(base)) end

    -- Leave it alone if we can't a relative URI, or if it would be a network
    -- path reference.
    if self._scheme ~= base._scheme or self._host ~= base._host or
       self._port ~= base._port or self._userinfo ~= base._userinfo then
        return
    end

    local basepath = base._path
    local oldpath = self._path
    -- This is to avoid trying to make a URN or something relative, which
    -- is likely to lead to grief.
    if not basepath:find("^/") or not oldpath:find("^/") then return end

    -- Turn it into a relative reference.
    self._uri = nil
    self._scheme = nil
    self._host = nil
    self._port = nil
    self._userinfo = nil
    setmetatable(self, require "uri._relative")

    -- Use empty path if the path in the base URI is already correct.
    if oldpath == basepath then
        if self._query or not base._query then
            self._path = ""
        else
            -- An empty URI reference leaves the query string in the base URI
            -- unchanged, so to get a result with no query part we have to
            -- have something in the relative path.
            local _, _, lastseg = oldpath:find("/([^/]+)$")
            if lastseg and lastseg:find(":") then lastseg = "./" .. lastseg end
            self._path = lastseg or "."
        end
        return
    end

    if oldpath == "/" or basepath == "/" then return end

    local basesegs = Util.split("/", basepath:sub(2))
    local oldsegs = Util.split("/", oldpath:sub(2))

    if oldsegs[1] ~= basesegs[1] then return end

    table.remove(basesegs)

    while #oldsegs > 1 and #basesegs > 0 and oldsegs[1] == basesegs[1] do
        table.remove(oldsegs, 1)
        table.remove(basesegs, 1)
    end

    local path_naked = true
    local newpath = ""
    while #basesegs > 0 do
        table.remove(basesegs, 1)
        newpath = newpath .. "../"
        path_naked = false
    end

    if path_naked and #oldsegs == 1 and oldsegs[1] == "" then
        newpath = "./"
        table.remove(oldsegs)
    end

    while #oldsegs > 0 do
        if path_naked then
            if oldsegs[1]:find(":") then
                newpath = newpath .. "./"
            elseif #oldsegs > 1 and oldsegs[1] == "" and oldsegs[2] == "" then
                newpath = newpath .. "/."
            end
        end

        newpath = newpath .. oldsegs[1]
        path_naked = false
        table.remove(oldsegs, 1)
        if #oldsegs > 0 then newpath = newpath .. "/" end
    end

    self._path = newpath
end

return M
-- vi:ts=4 sw=4 expandtab
