local suc = pcall(require, 'luatracy')
local originTracy = tracy

local function enable()
    tracy = originTracy
end

local function disable()
    tracy = {
        ZoneBeginN = function () end,
        ZoneEnd    = function () end,
    }
end

return {
    enable  = enable,
    disable = disable,
}
