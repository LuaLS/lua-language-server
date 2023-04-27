local suc, codeFormat = pcall(require, 'code_format')
if not suc then
    return
end

local config = require 'config'

local m = {}

m.loaded = false

function m.nameStyleCheck(uri, text)
    if not m.loaded then
        local value = config.get(nil, "Lua.nameStyle.config")
        codeFormat.update_name_style_config(value)
        m.loaded = true
    end

    return codeFormat.name_style_analysis(uri, text)
end

config.watch(function (uri, key, value)
    if key == "Lua.nameStyle.config" then
        codeFormat.update_name_style_config(value)
    end
end)

return m
