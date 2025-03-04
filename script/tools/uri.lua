local platform = require 'bee.platform'

---@alias Uri string

local escPatt = '[^%w%-%.%_%~%/]'

local function esc(c)
    return ('%%%02X'):format(c:byte())
end

local function normalize(str)
    return str:gsub('%%(%x%x)', function (n)
        return string.char(tonumber(n, 16))
    end)
end

---@class Uri.API
local M = {}

-- c:\my\files               --> file:///c%3A/my/files
-- /usr/home                 --> file:///usr/home
-- \\server\share\some\path  --> file://server/share/some/path

--- path -> uri
---@param path string
---@return Uri uri
function M.encode(path)
    local authority = ''
    if platform.os == 'windows' then
        path = path:gsub('\\', '/')
    end

    if path:sub(1, 2) == '//' then
        local idx = path:find('/', 3)
        if idx then
            authority = path:sub(3, idx)
            path = path:sub(idx + 1)
            if path == '' then
                path = '/'
            end
        else
            authority = path:sub(3)
            path = '/'
        end
    end

    if path:sub(1, 1) ~= '/' then
        path = '/' .. path
    end

    --lower-case windows drive letters in /C:/fff or C:/fff
    local start, finish, drive = path:find '/(%u):'
    if drive and finish then
        path = path:sub(1, start) .. drive:lower() .. path:sub(finish, -1)
    end

    local uri = 'file://'
        .. authority:gsub(escPatt, esc)
        .. path:gsub(escPatt, esc)
    return uri
end

-- file:///c%3A/my/files          --> c:\my\files
-- file:///usr/home               --> /usr/home
-- file://server/share/some/path  --> \\server\share\some\path

--- uri -> path
---@param uri Uri
---@return string path
function M.decode(uri)
    local scheme, authority, path = uri:match('([^:]*):?/?/?([^/]*)(.*)')
    if not scheme then
        return ''
    end
    scheme    = normalize(scheme)
    authority = normalize(authority)
    path      = normalize(path)
    local value
    if scheme == 'file' and #authority > 0 and #path > 1 then
        value = '//' .. authority .. path
    elseif path:match '/%a:' then
        value = path:sub(2, 2):upper() .. path:sub(3)
    else
        value = path
    end
    if platform.os == 'windows' then
        value = value:gsub('/', '\\')
    end
    return value
end

---@param uri Uri
---@return string scheme
---@return string authority
---@return string path
function M.split(uri)
    return uri:match('([^:]*):/?/?([^/]*)(.*)')
end

---@param uri string
---@return boolean
function M.isFile(uri)
    local scheme, authority, path = M.split(uri)
    if not scheme or scheme == '' then
        return false
    end
    if path == '' then
        return false
    end
    if scheme ~= 'file' then
        return false
    end
    return true
end

---@param uri Uri
---@return Uri
function M.normalize(uri)
    if not M.isFile(uri) then
        return uri
    end
    return M.encode(M.decode(uri))
end

---@param uri Uri
---@param path string
---@return Uri
function M.join(uri, path)
    return uri .. '/' .. path
end

---@param uri Uri
---@param baseUri Uri
---@return string?
function M.relativePath(uri, baseUri)
    if string.sub(uri, 1, #baseUri) ~= baseUri then
        return nil
    end
    if string.sub(uri, #baseUri + 1, #baseUri + 1) ~= '/' then
        return nil
    end
    return string.sub(uri, #baseUri + 2)
end

return M
