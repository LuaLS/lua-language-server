local fs = require 'bee.filesystem'
local json = require 'json'
local config = require 'config'

local command = {}

function command.config(lsp, data)
    local def = config.config
    for _, k in ipairs(data.key) do
        def = def[k]
        if not def then
            return
        end
    end
    if data.action == 'add' then
        if type(def) ~= 'table' then
            return
        end
    end

    local vscodePath = lsp.workspace.root / '.vscode'
    local settingBuf = io.load(vscodePath / 'settings.json')
    if not settingBuf then
        fs.create_directories(vscodePath)
    end

    local setting = json.decode(settingBuf, true) or {}
    local key = 'Lua.' .. table.concat(data.key, '.')
    local attr = setting[key]

    if data.action == 'add' then
        if attr == nil then
            attr = {}
        elseif type(attr) == 'string' then
            attr = {attr}
        elseif type(attr) == 'table' then
        else
            return
        end

        attr[#attr+1] = data.value
        setting[key] = attr
    end

    io.save(vscodePath / 'settings.json', json.encode(setting) .. '\r\n')
end

return function (lsp, params)
    local name = params.command
    if not command[name] then
        return
    end
    local result = command[name](lsp, params.arguments[1])
    return result
end
