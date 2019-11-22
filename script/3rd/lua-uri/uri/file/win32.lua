local M = { _NAME = "uri.file.win32" }
local URI = require "uri"
local Util = require "uri._util"

function M.filesystem_path (uri)
    local host = uri:host()
    local path = Util.uri_decode(uri:path())
    if host ~= "" then path = "//" .. host .. path end
    if path:find("^/[A-Za-z]|/") or path:find("^/[A-Za-z]|$") then
        path = path:gsub("|", ":", 1)
    end
    if path:find("^/[A-Za-z]:/") then
        path = path:sub(2)
    elseif path:find("^/[A-Za-z]:$") then
        path = path:sub(2) .. "/"
    end
    path = path:gsub("/", "\\")
    return path
end

function M.make_file_uri (path)
    path = path:gsub("\\", "/")
    if path:find("^[A-Za-z]:$") then path = path .. "/" end
    local _, _, host, hostpath = path:find("^//([A-Za-z0-9.]+)/(.*)$")
    host = host or ""
    hostpath = hostpath or path
    hostpath = hostpath:gsub("//+", "/")
    hostpath = Util.uri_encode(hostpath, "^A-Za-z0-9%-._~!$&'()*+,;=@/")
    if not hostpath:find("^/") then hostpath = "/" .. hostpath end
    return assert(URI:new("file://" .. host .. hostpath))
end

return M
-- vi:ts=4 sw=4 expandtab
