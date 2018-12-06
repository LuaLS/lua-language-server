local lni = require 'lni'

local Libs
local function getLibs()
    if Libs then
        return Libs
    end
    local language = require 'language'
    Libs = {}
    for path in io.scan(ROOT / 'libs') do
        if path:extension():string() == '.lni' then
            local buf = io.load(path)
            if buf then
                local suc = xpcall(lni.classics, log.error, buf, path:string(), {Libs})
                if suc then
                    local locale = io.load(path:parent_path() / (path:stem():string() .. '.' .. language))
                    if locale then
                        xpcall(lni.classics, log.error, locale, path:string(), {Libs})
                    end
                end
            end
        end
    end
    return Libs
end

return function (var)
    local key = var.key
    local libs = getLibs()
    return libs[key]
end
