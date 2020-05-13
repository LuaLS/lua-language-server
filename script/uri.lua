local fs = require 'bee.filesystem'
local furi = require 'file-uri'

local function encode(path)
    return furi.encode(path:string())
end

local function decode(uri)
    return fs.path(furi.decode(uri))
end

return {
    encode = encode,
    decode = decode,
}
