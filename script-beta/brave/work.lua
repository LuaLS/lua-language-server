local brave   = require 'brave.brave'
local jsonrpc = require 'jsonrpc'
local parser  = require 'parser'
local fs      = require 'bee.filesystem'
local furi    = require 'file-uri'
local util    = require 'utility'

brave.on('loadProto', function ()
    while true do
        local proto = jsonrpc.decode(io.read, log.error)
        --log.debug('loaded proto', proto.method)
        if proto then
            brave.push('proto', proto)
        end
    end
end)

brave.on('compile', function (text)
    local state, err = parser:compile(text, 'lua', 'Lua 5.4')
    if not state then
        log.error(err)
        return
    end
    local lines = parser:lines(text)
    return {
        root  = state.root,
        value = state.value,
        errs  = state.errs,
        lines = lines,
    }
end)

brave.on('listDirectory', function (uri)
    local path = fs.path(furi.decode(uri))
    local uris = {}
    for child in path:list_directory() do
        local childUri = furi.encode(child:string())
        uris[#uris+1] = childUri
    end
    return uris
end)

brave.on('isDirectory', function (uri)
    local path = fs.path(furi.decode(uri))
    return fs.is_directory(path)
end)

brave.on('loadFile', function (uri)
    local filename = furi.decode(uri)
    return util.loadFile(filename)
end)

brave.on('saveFile', function (params)
    local filename = furi.decode(params.uri)
    return util.saveFile(filename, params.text)
end)
