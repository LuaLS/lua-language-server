local M = { _NAME = "uri.file.unix" }
local URI = require "uri"
local Util = require "uri._util"

function M.filesystem_path (uri)
    if uri:host() ~= "" then
        error("a file URI with a host name can't be converted to a Unix path")
    end
    local path = uri:path()
    if path:find("%%00") or path:find("%%2F") then
        error("Unix paths cannot contain encoded null bytes or slashes")
    end
    return Util.uri_decode(path)
end

function M.make_file_uri (path)
    if not path:find("^/") then
        error("Unix relative paths can't be converted to file URIs")
    end
    path = path:gsub("//+", "/")
    path = Util.uri_encode(path, "^A-Za-z0-9%-._~!$&'()*+,;=@/")
    return assert(URI:new("file://" .. path))
end

return M
-- vi:ts=4 sw=4 expandtab
