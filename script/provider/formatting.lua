local suc, codeFormat = pcall(require, 'code_format')
if not suc then
    return
end

local ws          = require 'workspace'
local furi        = require 'file-uri'
local fs          = require 'bee.filesystem'
local fw          = require 'filewatch'
local util        = require 'utility'
local diagnostics = require 'provider.diagnostic'
local config      = require 'config'

local loadedUris = {}

local updateType = {
    Created = 1,
    Changed = 2,
    Deleted = 3,
}

fw.event(function(ev, path)
    if util.stringEndWith(path, '.editorconfig') then
        for uri, fsPath in pairs(loadedUris) do
            loadedUris[uri] = nil
            if fsPath ~= true then
                local status, err = codeFormat.update_config(updateType.Deleted, uri, fsPath:string())
                if not status and err then
                    log.error(err)
                end
            end
        end
    end
end)


local m = {}

m.loadedDefaultConfig = false

---@param uri uri
function m.updateConfig(uri)
    if not m.loadedDefaultConfig then
        m.loadedDefaultConfig = true
        codeFormat.set_default_config(config.get(uri, 'Lua.format.defaultConfig'))
        m.updateNonStandardSymbols(config.get(nil, 'Lua.runtime.nonstandardSymbol'))
    end

    local currentUri = uri
    while true do
        currentUri = currentUri:match('^(.+)/[^/]*$')
        if not currentUri or loadedUris[currentUri] then
            return
        end
        loadedUris[currentUri] = true

        local currentPath        = furi.decode(currentUri)
        local editorConfigFSPath = fs.path(currentPath) / '.editorconfig'
        if fs.exists(editorConfigFSPath) then
            loadedUris[currentUri] = editorConfigFSPath
            local status, err = codeFormat.update_config(updateType.Created, currentUri, editorConfigFSPath:string())
            if not status and err then
                log.error(err)
            end
        end

        if not ws.rootUri then
            return
        end

        for _, scp in ipairs(ws.folders) do
            if scp.uri == currentUri then
                return
            end
        end
    end
end

---@param symbols? string[]
function m.updateNonStandardSymbols(symbols)
    if symbols == nil then
        return
    end

    local eqTokens = {}
    for _, token in ipairs(symbols) do
        if token:find("=") and token ~= "!=" then
            table.insert(eqTokens, token)
        end
    end

    if #eqTokens ~= 0 then
        codeFormat.set_nonstandard_symbol('=', eqTokens)
    end
end

config.watch(function(uri, key, value)
    if  key == "Lua.format.defaultConfig" then
        codeFormat.set_default_config(value)
    elseif key == "Lua.runtime.nonstandardSymbol" then
        m.updateNonStandardSymbols(value)
    end
end)

return m
