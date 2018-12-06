local lni = require 'lni'

local Libs
local function getLibs()
    if Libs then
        return Libs
    end
    Libs = {}
    for path in io.scan(ROOT / 'libs') do
        local buf = io.load(path)
        if buf then
            xpcall(lni.classics, log.error, buf, path:string(), {Libs})
        end
    end
    return Libs
end

return function (var)
    local key = var.key
    local libs = getLibs()
    return libs[key]
end
