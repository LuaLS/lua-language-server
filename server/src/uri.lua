local fs = require 'bee.filesystem'
local platform = require 'bee.platform'
local sandbox = require 'sandbox'
local luaUriPath = (ROOT / 'src' / '3rd' / 'lua-uri'):string()
local URI = sandbox('uri.lua', luaUriPath, io.open)
local URI_FILE = sandbox('uri/file.lua', luaUriPath, io.open)
local OS = platform.OS == 'Windows' and 'win32' or 'unix'

local function decode(uri)
    local obj = URI:new(uri)
    local fullPath = obj:filesystem_path(OS)
    local path = fs.path(fullPath)
    return path
end

local function encode(path)
    local fullPath = fs.absolute(path)
    local obj = URI_FILE.make_file_uri(fullPath:string(), OS)
    local uri = obj:uri()
    return uri
end

return {
    encode = encode,
    decode = decode,
}
