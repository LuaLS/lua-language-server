local brave   = require 'brave.brave'
local jsonrpc = require 'jsonrpc'
local parser  = require 'parser'
local fs      = require 'bee.filesystem'
local furi    = require 'file-uri'
local util    = require 'utility'

brave.on('loadProto', function ()
    while true do
        local proto = jsonrpc.decode(io.read, log.error)
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
        errs  = state.errs,
        lines = lines,
    }
end)

brave.on('listDirectory', function (uri)
    local path = fs.path(furi.decode(uri))
    local uris = {}
    local dirs = {}
    for child in path:list_directory() do
        local childUri = furi.encode(child:string())
        uris[#uris+1] = childUri
        if fs.is_directory(child) then
            dirs[childUri] = true
        end
    end
    return {
        uris = uris,
        dirs = dirs,
    }
end)

brave.on('loadFile', function (uri)
    local filename = furi.decode(uri)
    return util.loadFile(filename)
end)

brave.on('saveFile', function (params)
    local filename = furi.decode(params.uri)
    return util.saveFile(filename, params.text)
end)

return brave
